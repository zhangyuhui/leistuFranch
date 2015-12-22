//
//  LEAccountService.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEAccountService.h"
#import "LEAccount.h"
#import "LEHttpRequestOperation.h"
#import "LEConstants.h"
#import "NSString+Addition.h"
#import "LEErrors.h"

#define kAccountServicePathLogin           @"auth/newVersionLogin"
#define kAccountServicePathChangePassword  @"auth/updateUserPassword"
#define kAccountServicePathUpdateAccount   @"auth/user"

#define KAccountServicePathUserIDAccount          @"auth/getUserByUserID"
@interface LEAccountService ()
@property (strong, nonatomic) LEHttpRequestOperation* requestOperation;

- (void)handleLoginFailure:(NSString*)error failure:(void (^)(LEAccountService *service, NSString* error)) failure;
- (void)handleLoginSuccess:(LEAccount*)account success:(void (^)(LEAccountService *service, LEAccount* account))success;

- (void)handleChangePasswordFailure:(NSString*)error failure:(void (^)(LEAccountService *service, NSString* error)) failure;
- (void)handleChangePasswordSuccess:(void (^)(LEAccountService *service))success;

- (void)handleUpdateAccountFailure:(NSString*)error failure:(void (^)(LEAccountService *service, NSString* error)) failure;
- (void)handleUpdateAccountSuccess:(LEAccount*)account success:(void (^)(LEAccountService *service, LEAccount* account))success;


- (void)persistentAccount;
- (void)restoreAccount;
@end

@implementation LEAccountService
@synthesize account = _account;

+ (instancetype)sharedService {
    static LEAccountService *sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[super allocWithZone:NULL] init];
        sharedService.requestOperation = [[LEHttpRequestOperation alloc] init];
        [sharedService restore];
    });
    return sharedService;
}

+ (instancetype)allocWithZone:(NSZone *)zone{
    NSString *reason = [NSString stringWithFormat:@"Attempt to allocate a second instance of the singleton %@", [self class]];
    NSException *exception = [NSException exceptionWithName:@"Multiple singletons" reason:reason userInfo:nil];
    [exception raise];
    return nil;
}

- (void)handleLoginFailure:(NSString*)error failure:(void (^)(LEAccountService *service, NSString* error)) failure {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kLENetworkConnectionUserToken];
    [userDefaults removeObjectForKey:kLENetworkConnectionUserId];
    self.account = nil;
    failure(self, error);
}

- (void)handleLoginSuccess:(LEAccount*)account success:(void (^)(LEAccountService *service, LEAccount* account))success {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:account.token forKey:kLENetworkConnectionUserToken];
    [userDefaults setObject:[NSNumber numberWithInt:account.userId] forKey:kLENetworkConnectionUserId];
    self.account = account;
    
    [self persistent];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLENotificationAccountDidChange object:account];
    
    success(self, account);
}

- (void)handleChangePasswordFailure:(NSString*)error failure:(void (^)(LEAccountService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleChangePasswordSuccess:(void (^)(LEAccountService *service))success {
    success(self);
}

- (void)handleUpdateAccountFailure:(NSString*)error failure:(void (^)(LEAccountService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleUpdateAccountSuccess:(LEAccount*)account success:(void (^)(LEAccountService *service, LEAccount* account))success {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:account.token forKey:kLENetworkConnectionUserToken];
    [userDefaults setObject:[NSNumber numberWithInt:account.userId] forKey:kLENetworkConnectionUserId];
    self.account = account;
    
    [self persistent];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLENotificationAccountDidChange object:account];
    
    success(self, self.account);
}

- (void)loginUser:(NSString*)userName
     password:(NSString*)password
      success:(void (^)(LEAccountService *service, LEAccount* account))success
      failure:(void (^)(LEAccountService *service, NSString* error))failure {
    
    [self.requestOperation requestByPost:kAccountServicePathLogin parameters:@{@"username": userName, @"password": [password md5Hash]} options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSError* error = nil;
        NSString* status = [response objectForKey:@"status"];
        if ([status isEqualToString:@"true"]) {
            LEAccount* account = [[LEAccount alloc] initWithDictionary:response error:&error];
            if (error) {
                [self handleLoginFailure:[error localizedDescription] failure:failure];
            } else {
                [self handleLoginSuccess:account success:success];
            }
        } else {
            [self handleLoginFailure:[response objectForKey:@"error_msg"] failure:failure];
        }
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleLoginFailure:nil failure:failure];
        } else {
            [self handleLoginFailure:[error description] failure:failure];
        }
    }];
}

- (void)logoutUser {
    self.account = nil;
    [self persistent];
}

- (void)changePassword:(NSString*)oldPassword
           newPassword:(NSString*)newPassword
               success:(void (^)(LEAccountService *service))success
               failure:(void (^)(LEAccountService *service, NSString* error))failure {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@/%@", kAccountServicePathChangePassword, [oldPassword md5Hash], [newPassword md5Hash], [userId stringValue]];
    [self.requestOperation requestByGet:path parameters:nil options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSString* message = [response objectForKey:@"message"];
        if ([message isEqualToString:@"success"]) {
            [self handleChangePasswordSuccess:success];
        } else {
            [self handleChangePasswordFailure:@"修改密码出错" failure:failure];
        }
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleChangePasswordFailure:nil failure:failure];
        } else {
            [self handleChangePasswordFailure:[error localizedDescription] failure:failure];
        }
    }];
     
}
- (void)checkAppVersonSuccess:(void (^)(NSString * updateInfo))success
                      failure:(void (^)(NSString* error))failure
{
    [self.requestOperation requestByGetAppInfoParameters:nil options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSArray *respArr = [response objectForKey:@"results"];
        if ([respArr count]==0||!respArr) {
            return ;
        }
        NSDictionary *dic = [respArr objectAtIndex:0];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
        int versionInt;
        if ([version length]==2) {
            versionInt = [version intValue]*10;
        }
        
        NSString *versionServe  = [dic objectForKey:@"version"];
        versionServe = [versionServe stringByReplacingOccurrencesOfString:@"." withString:@""];
        int versionServeInt = [versionServe intValue];
        if ([versionServe length]==2) {
            versionServeInt = [versionServe intValue]*10;
        }
        if (versionServeInt>versionInt) {
            NSString *updateString = [dic objectForKey:@"releaseNotes"];
            success(updateString);
        }else
            failure(nil);
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        failure(error.description);
    }];
}
- (void)updateAccount:(LEAccount*)account
              success:(void (^)(LEAccountService *service, LEAccount* account))success
              failure:(void (^)(LEAccountService *service, NSString* error))failure {
    NSDictionary* forUpdate = @{@"userID": [NSString stringWithFormat:@"%d", account.userId],
                                @"name": (account.userName == nil)?@"":account.userName,
                                @"email": (account.email == nil)?@"":account.email,
                                @"telephone": (account.phone == nil)?@"":account.phone,
                                @"studentID": (account.studentId == nil)?@"":account.studentId,
                                @"sex": [NSString stringWithFormat:@"%d", account.sex]};
    [self.requestOperation requestByPost:kAccountServicePathUpdateAccount parameters:forUpdate options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSString* status = [response objectForKey:@"status"];
        if ([status isEqualToString:@"success"]) {
            [self handleUpdateAccountSuccess:account success:success];
        } else {
            [self handleUpdateAccountFailure:[response objectForKey:@"detail"] failure:failure];
        }
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleUpdateAccountFailure:nil failure:failure];
        } else {
            [self handleUpdateAccountFailure:[error localizedDescription] failure:failure];
        }
    }];
    
}

- (void)persistentAccount {
    if (self.account) {
        NSData* data = [self.account toJSONData];
        [data writeToFile:[self dataPathWithAccount] atomically:YES];
    } else {
        NSString* path = [self dataPathWithAccount];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSError* error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
}

- (void)restoreAccount {
    NSData* data = [[NSFileManager defaultManager] contentsAtPath:[self dataPathWithAccount]];
    NSError* error = nil;
    self.account = [[LEAccount alloc] initWithData:data error:&error];
}

- (void)persistent {
    [super persistent];
    [self persistentAccount];
}

- (void)restore {
    [super restore];
    [self restoreAccount];
}


@end
