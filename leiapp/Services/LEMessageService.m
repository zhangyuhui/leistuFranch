//
//  LEMessageService.m
//  leiapp
//
//  Sendd by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEMessageService.h"
#import "LEHttpRequestOperation.h"
#import "LEErrors.h"

#define kMessageServicePathSendMessage   @"message/addNewMessage"

@interface LEMessageService ()

@property (strong, nonatomic) LEHttpRequestOperation* requestOperation;

- (void)handleSendMessageFailure:(NSString*)error failure:(void (^)(LEMessageService *service, NSString* error)) failure;
- (void)handleSendMessageSuccess:(void (^)(LEMessageService *service))success;

@end

@implementation LEMessageService

+ (instancetype)sharedService {
    static LEMessageService *sharedService = nil;
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

- (void)handleSendMessageFailure:(NSString*)error failure:(void (^)(LEMessageService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleSendMessageSuccess:(void (^)(LEMessageService *service))success {
    success(self);
}

- (void)sendMessage:(LEMessage*)message
              success:(void (^)(LEMessageService *service))success
              failure:(void (^)(LEMessageService *service, NSString* error))failure {
    NSDictionary* parameters = [message toDictionary];
    [self.requestOperation requestByPost:kMessageServicePathSendMessage parameters:parameters options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSString* message = [response objectForKey:@"message"];
        if ([message isEqualToString:@"success"]) {
            [self handleSendMessageSuccess:success];
        } else {
            [self handleSendMessageFailure:@"发送消息出错" failure:failure];
        }
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleSendMessageFailure:nil failure:failure];
        } else {
            [self handleSendMessageFailure:[error localizedDescription] failure:failure];
        }
    }];
    
}

@end
