//
//  LEAccountService.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseService.h"
#import "LEAccount.h"

@interface LEAccountService : LEBaseService

+ (instancetype)sharedService;

@property (strong, nonatomic) LEAccount* account;

- (void)loginUser:(NSString*)userName
         password:(NSString*)password
          success:(void (^)(LEAccountService *service, LEAccount* account))success
          failure:(void (^)(LEAccountService *service, NSString* error))failure;

- (void)logoutUser;

- (void)changePassword:(NSString*)oldPassword
           newPassword:(NSString*)newPassword
               success:(void (^)(LEAccountService *service))success
               failure:(void (^)(LEAccountService *service, NSString* error))failure;
- (void)updateAccount:(LEAccount*)account
              success:(void (^)(LEAccountService *service, LEAccount* account))success
              failure:(void (^)(LEAccountService *service, NSString* error))failure;

-(void)checkAppVersonSuccess:(void (^)(NSString * updateInfo ))success
                     failure:(void (^)(NSString* error))failure;
@end
