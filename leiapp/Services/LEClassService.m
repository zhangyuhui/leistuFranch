//
//  LEClassService.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/19/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEClassService.h"
#import "LEConstants.h"
#import "LEHttpRequestOperation.h"
#import "LEErrors.h"

#define kClasseservicePathMyClasses            @"class/getUserClasses"
#define kClasseservicePathGetClassInfo         @"class/getClassInfo"
#define kClasseservicePathQuitClass            @"class/quitClass"
#define kClasseservicePathReclaimClass         @"class/cancelQuitClass"


@interface LEClassService ()

@property (strong, nonatomic) LEHttpRequestOperation* requestOperation;

- (void)handleGetClassesFailure:(NSString*)error failure:(void (^)(LEClassService *service, NSString* error)) failure;
- (void)handleGetClassesSuccess:(NSArray*)classes success:(void (^)(LEClassService *service, NSArray* classes))success;

- (void)handleGetClassFailure:(NSString*)error failure:(void (^)(LEClassService *service, NSString* error)) failure;
- (void)handleGetClassSuccess:(LEClass*)class success:(void (^)(LEClassService *service, LEClass* classe))success;

- (void)handleQuitClassFailure:(NSString*)error failure:(void (^)(LEClassService *service, NSString* error)) failure;
- (void)handleQuitClassSuccess:(void (^)(LEClassService *service))success;

- (void)handleReclaimClassFailure:(NSString*)error failure:(void (^)(LEClassService *service, NSString* error)) failure;
- (void)handleReclaimClassSuccess:(void (^)(LEClassService *service))success;

@end


@implementation LEClassService
@synthesize classes = _classes;
@synthesize requestOperation;

+ (instancetype)sharedService {
    static LEClassService *sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[super allocWithZone:NULL] init];
        sharedService.requestOperation = [[LEHttpRequestOperation alloc] init];
    });
    return sharedService;
}

+ (instancetype)allocWithZone:(NSZone *)zone{
    NSString *reason = [NSString stringWithFormat:@"Attempt to allocate a second instance of the singleton %@", [self class]];
    NSException *exception = [NSException exceptionWithName:@"Multiple singletons" reason:reason userInfo:nil];
    [exception raise];
    return nil;
}

- (void)handleGetClassesFailure:(NSString*)error failure:(void (^)(LEClassService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleGetClassesSuccess:(NSArray*)classes success:(void (^)(LEClassService *service, NSArray* classes))success {
    success(self, classes);
}

- (void)handleGetClassFailure:(NSString*)error failure:(void (^)(LEClassService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleGetClassSuccess:(LEClass*)class success:(void (^)(LEClassService *service, LEClass* class))success {
    success(self, class);
}

- (void)handleQuitClassFailure:(NSString*)error failure:(void (^)(LEClassService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleQuitClassSuccess:(void (^)(LEClassService *service))success {
    success(self);
}

- (void)handleReclaimClassFailure:(NSString*)error failure:(void (^)(LEClassService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleReclaimClassSuccess:(void (^)(LEClassService *service))success {
    success(self);
}

- (void)getClasses:(LEClassStatus)status
           success:(void (^)(LEClassService *service, NSArray* Classes))success
           failure:(void (^)(LEClassService *service, NSString* error))failure {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@", kClasseservicePathMyClasses, userId, [NSString stringWithFormat:@"%d",status]];
    [self.requestOperation requestByGet:path parameters:nil options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSMutableArray* classes = [NSMutableArray arrayWithCapacity:[response count]];
        [response enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            NSError* error = nil;
            [classes addObject:[[LEClass alloc] initWithDictionary:object error:&error]];
        }];
        [self handleGetClassesSuccess:classes success:success];
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleGetClassesFailure:nil failure:failure];
        } else {
            [self handleGetClassesFailure:[error localizedDescription] failure:failure];
        }
    }];
    
}

- (void)getClasse:(int)classId
          success:(void (^)(LEClassService *service, LEClass* classe))success
          failure:(void (^)(LEClassService *service, NSString* error))failure {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@", kClasseservicePathGetClassInfo, userId, [NSString stringWithFormat:@"%d", classId]];
    [self.requestOperation requestByGet:path parameters:nil options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSError* error = nil;
        LEClass* class = [[LEClass alloc] initWithDictionary:response error:&error];
        [self handleGetClassSuccess:class success:success];
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleGetClassFailure:nil failure:failure];
        } else {
            [self handleGetClassFailure:[error localizedDescription] failure:failure];
        }
    }];
    
}

- (void)quitClass:(int)classId
          success:(void (^)(LEClassService *service))success
          failure:(void (^)(LEClassService *service, NSString* error))failure {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@", kClasseservicePathQuitClass, userId, [NSString stringWithFormat:@"%d", classId]];
    [self.requestOperation requestByGet:path parameters:nil options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSString* status = [response objectForKey:@"status"];
        if ([status isEqualToString:@"success"]) {
            [self handleQuitClassSuccess:success];
        } else {
            [self handleQuitClassFailure:@"退出班级出错" failure:failure];
        }
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleQuitClassFailure:nil failure:failure];
        } else {
            [self handleQuitClassFailure:[error localizedDescription] failure:failure];
        }
    }];
    
}

- (void)reclaimClass:(int)classId
             success:(void (^)(LEClassService *service))success
             failure:(void (^)(LEClassService *service, NSString* error))failure {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@", kClasseservicePathReclaimClass, userId, [NSString stringWithFormat:@"%d", classId]];
    [self.requestOperation requestByGet:path parameters:nil options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSString* status = [response objectForKey:@"status"];
        if ([status isEqualToString:@"success"]) {
            [self handleReclaimClassSuccess:success];
        } else {
            [self handleReclaimClassFailure:@"取消退出班级出错" failure:failure];
        }
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleReclaimClassFailure:nil failure:failure];
        } else {
            [self handleReclaimClassFailure:[error localizedDescription] failure:failure];
        }
    }];
}

@end
