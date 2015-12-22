//
//  LEPushService.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEPushService.h"
#import "LEHttpRequestOperation.h"
#import "LEPushToken.h"
#import "LEConstants.h"
#import "LEErrors.h"

#define kPushServicePathSendPush   @"apns"

@interface LEPushService ()

@property (strong, nonatomic) LEHttpRequestOperation* requestOperation;

- (void)initToken:(NSString *)token;

@end

@implementation LEPushService
@synthesize token = _token;

+ (instancetype)sharedService {
    static LEPushService *sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[super allocWithZone:NULL] init];
        sharedService.requestOperation = [[LEHttpRequestOperation alloc] init];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [sharedService initToken:[userDefaults objectForKey:kLENetworkConnectionPushToken]];
    });
    return sharedService;
}

+ (instancetype)allocWithZone:(NSZone *)zone{
    NSString *reason = [NSString stringWithFormat:@"Attempt to allocate a second instance of the singleton %@", [self class]];
    NSException *exception = [NSException exceptionWithName:@"Multiple singletons" reason:reason userInfo:nil];
    [exception raise];
    return nil;
}

- (void)initToken:(NSString *)token {
    _token = token;
}

- (void)setToken:(NSString *)token {
    BOOL shouldPush = (token && ![token isEqualToString:_token]);
    BOOL isCreated = (_token == nil);
    _token = token;
    if (shouldPush) {
        LEPushToken* pushToken = [[LEPushToken alloc] init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
        pushToken.userId = [userId intValue];
        pushToken.status = 1;
        pushToken.deviceToken = token;
        NSDictionary* parameters = [pushToken toDictionary];
    
        void (^success)(LEHttpRequestOperation *operation, id response) = ^(LEHttpRequestOperation *operation, id response){
            //NSLog(@"发送推送token成功");
        };
        void (^failure)(LEHttpRequestOperation *operation, NSError *error) = ^(LEHttpRequestOperation *operation, NSError *error) {
            //NSLog(@"发送推送token失败");
        };
        
        if (isCreated) {
            [self.requestOperation requestByPost:kPushServicePathSendPush parameters:parameters options:nil success:success failure:failure];
        } else {
            [self.requestOperation requestByPut:kPushServicePathSendPush parameters:parameters options:nil success:success failure:failure];
        }
    }
    
}

- (void)createToken:(NSString *)token {
    
}

- (void)updateToken:(NSString *)token {
    
}

@end
