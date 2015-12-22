//
//  LEUserService.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseService.h"
#import "LEUser.h"

@interface LEUserService : LEBaseService

+ (instancetype)sharedService;

- (void)getUsers:(int)classId
         success:(void (^)(LEUserService *service, NSArray* users))success
         failure:(void (^)(LEUserService *service, NSString* error))failure;

- (void)getUser:(int)userId
        success:(void (^)(LEUserService *service, LEUser* user))success
        failure:(void (^)(LEUserService *service, NSString* error))failure;

- (void)getContactUsers:(void (^)(LEUserService *service, NSArray* userGroups))success
                failure:(void (^)(LEUserService *service, NSString* error))failure;

@end
