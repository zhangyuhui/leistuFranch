//
//  LEUserService.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEUserService.h"
#import "LEHttpRequestOperation.h"
#import "LEUserGroup.h"
#import "LEConstants.h"
#import "LEErrors.h"

#define kUserServicePathGetUsersByClassId   @"class/getUserInfo"
#define kUserServicePathGetUser             @"auth/getUserByUserId"
#define kUserServicePathGetContactUsers     @"message/getSelPeopleList"

@interface LEUserService ()

@property (strong, nonatomic) LEHttpRequestOperation* requestOperation;

- (void)handleGetUsersFailure:(NSString*)error failure:(void (^)(LEUserService *service, NSString* error)) failure;
- (void)handleGetUsersSuccess:(NSArray*)users success:(void (^)(LEUserService *service, NSArray* users))success;

- (void)handleGetUserFailure:(NSString*)error failure:(void (^)(LEUserService *service, NSString* error)) failure;
- (void)handleGetUserSuccess:(LEUser*)user success:(void (^)(LEUserService *service, LEUser* user))success;

- (void)handleGetContctUsersFailure:(NSString*)error failure:(void (^)(LEUserService *service, NSString* error)) failure;
- (void)handleGetContctUsersSuccess:(NSArray*)userGroups success:(void (^)(LEUserService *service, NSArray* userGroups))success;


@end

@implementation LEUserService

+ (instancetype)sharedService {
    static LEUserService *sharedService = nil;
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

- (void)handleGetUsersFailure:(NSString*)error failure:(void (^)(LEUserService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleGetUsersSuccess:(NSArray*)users success:(void (^)(LEUserService *service, NSArray* users))success {
    success(self, users);
}

- (void)handleGetUserFailure:(NSString*)error failure:(void (^)(LEUserService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleGetUserSuccess:(LEUser*)user success:(void (^)(LEUserService *service, LEUser* user))success {
    success(self, user);
}

- (void)handleGetContctUsersFailure:(NSString*)error failure:(void (^)(LEUserService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleGetContctUsersSuccess:(NSArray*)userGroups success:(void (^)(LEUserService *service, NSArray* userGroups))success {
    success(self, userGroups);
}


- (void)getUsers:(int)classId
         success:(void (^)(LEUserService *service, NSArray* users))success
         failure:(void (^)(LEUserService *service, NSString* error))failure {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", kUserServicePathGetUsersByClassId, [NSString stringWithFormat:@"%d", classId]];
    [self.requestOperation requestByGet:path parameters:nil options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSMutableArray* users = [NSMutableArray arrayWithCapacity:[response count]];
        [response enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            NSError* error = nil;
            [users addObject:[[LEUser alloc] initWithDictionary:object error:&error]];
        }];
        [self handleGetUsersSuccess:users success:success];
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleGetUsersFailure:nil failure:failure];
        } else {
            [self handleGetUsersFailure:[error localizedDescription] failure:failure];
        }
    }];
    
}

- (void)getUser:(int)userId
        success:(void (^)(LEUserService *service, LEUser* user))success
        failure:(void (^)(LEUserService *service, NSString* error))failure {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", kUserServicePathGetUser, [NSString stringWithFormat:@"%d", userId]];
    [self.requestOperation requestByGet:path parameters:nil options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSError* error = nil;
        LEUser* user = [[LEUser alloc] initWithDictionary:response error:&error];
        [self handleGetUserSuccess:user success:success];
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleGetUserFailure:nil failure:failure];
        } else {
            [self handleGetUserFailure:[error localizedDescription] failure:failure];
        }
    }];
    
}

- (void)getContactUsers:(void (^)(LEUserService *service, NSArray* userGroups))success
                failure:(void (^)(LEUserService *service, NSString* error))failure {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    NSString* path = [NSString stringWithFormat:@"%@/%@", kUserServicePathGetContactUsers, userId];
    [self.requestOperation requestByGet:path parameters:nil options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSArray* groupObject = [response objectForKey:@"groups"];
        NSArray* usersObject = [response objectForKey:@"users"];
        
        NSMutableArray* users = [NSMutableArray arrayWithCapacity:[usersObject count]];
        [usersObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSError* error = nil;
            LEUser* user = [[LEUser alloc] initWithDictionary:obj error:&error];
            [users addObject:user];
        }];
     
        NSMutableArray* userGroups = [NSMutableArray arrayWithCapacity:[groupObject count]];
        [groupObject enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            NSError* error = nil;
            LEUserGroup* group = [[LEUserGroup alloc] initWithDictionary:object error:&error];
            
            NSArray* groupUsers = [usersObject objectsAtIndexes:[users indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                LEUser* user = obj;
                return user.groupId == group.groupId;
            }]];
            
            group.groupUsers = groupUsers;
            
            [userGroups addObject:group];
        }];
        
        [self handleGetContctUsersSuccess:userGroups success:success];
        
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleGetContctUsersFailure:nil failure:failure];
        } else {
            [self handleGetContctUsersFailure:[error localizedDescription] failure:failure];
        }
    }];
    
}



@end
