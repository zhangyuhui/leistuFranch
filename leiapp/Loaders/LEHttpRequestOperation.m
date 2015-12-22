//
//  LEHttpRequestOperation.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/14/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEHttpRequestOperation.h"

#import <Foundation/Foundation.h>
#import "LEHttpRequestOperation.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "LEConfigurationLoader.h"
#import "LEPreferenceService.h"
#import "LEConstants.h"
#import "LEErrors.h"

typedef void (^AcceptedBlock)();
typedef void (^RejectedBlock)();

@interface LEHttpRequestOperation() <UIAlertViewDelegate>
@property (strong, nonatomic) NSString* host;
@property (strong, nonatomic) NSMutableDictionary* operations;

@property (readwrite, copy) AcceptedBlock accepted;
@property (readwrite, copy) RejectedBlock rejected;

- (AFHTTPRequestOperationManager*)operationManage:(NSDictionary*)options;

- (void)checkNetworkingStatus:(void (^)())accpeted rejected:(void (^)())rejected allowNoneWifi:(BOOL)allowNoneWifi;
- (BOOL)parseAllowNoneWifi:(NSDictionary*)options;
@end

@implementation LEHttpRequestOperation
@synthesize host = _host;

- (instancetype)init {
    LEConfigurationLoader* configuration = [[LEConfigurationLoader alloc] init];
    NSString* host = [configuration stringForKey:kLEConfigurationHost];
    return [self initWithHost:host];
}

- (instancetype)initWithHost:(NSString*)host {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.host = host;
    self.operations = [[NSMutableDictionary alloc] init];
    
    return self;
}
- (AFHTTPRequestOperationManager*) operationManage {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [userDefaults objectForKey:kLENetworkConnectionUserToken];
    if (token) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"oauth2 %@", token] forHTTPHeaderField:@"Authorization"];
    }
    return manager;
}

//此方法由于cookies不合法问题导致程序崩溃！很严重暂时用上边的方式发送。
- (AFHTTPRequestOperationManager*) operationManage:(NSDictionary*)options {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary* httpHeaders = [options objectForKey:@"httpHeaders"];
    if (httpHeaders) {
        [httpHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
            NSString* value = (NSString*)obj;
            NSString* field = (NSString*)key;
            [manager.requestSerializer setValue:value forHTTPHeaderField:field];
        }];
    }
    
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
//    NSURL *hostURL = [NSURL URLWithString:self.host];
//    NSArray *storage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:hostURL];
//    NSDictionary *cookies = [NSHTTPCookie requestHeaderFieldsWithCookies:storage];
//    if (cookies) {
//        [manager.requestSerializer setValuesForKeysWithDictionary:cookies];
//    }
    //header 为空的时候会引起cookies为空导致程序崩溃，这里允许header为空
    //headr 多次引起崩溃 很不解！！！
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [userDefaults objectForKey:kLENetworkConnectionUserToken];
    if (token) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"oauth2 %@", token] forHTTPHeaderField:@"Authorization"];
    }
    return manager;
}

- (BOOL)parseAllowNoneWifi:(NSDictionary*)options {
    BOOL allowNoneWifi = NO;
    if (options != nil) {
        NSNumber* number = [options objectForKey:@"allowNoneWifi"];
        if (number != nil) {
            allowNoneWifi = [number boolValue];
        }
    }
    return allowNoneWifi;
}

- (void)applyRequestHeaders:(NSDictionary*)options {
    
}

- (void)checkNetworkingStatus:(void (^)())accpeted rejected:(void (^)())rejected allowNoneWifi:(BOOL)allowNoneWifi {
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    BOOL isAccpeted = YES;
    BOOL isRejected = NO;
    
    //status = AFNetworkReachabilityStatusReachableViaWWAN;
    
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:{
            isAccpeted = NO;
            isRejected = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误"
                                                            message:@"当前网络不可用，请检查网络连接"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:{
            if (!allowNoneWifi) {
                isAccpeted = NO;
                self.accepted = accpeted;
                self.rejected = rejected;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误"
                                                                message:@"当前处于非Wifi环境，下载会消耗数据流量，确定要下载吗？"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
            break;
        default: {
            isAccpeted = NO;
            isRejected = YES;
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误"
//                                                            message:@"当前网络不可用，请检查网络连接"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
        }
            break;
            
    }
    if (isAccpeted) {
        accpeted();
    }
    if (isRejected) {
        rejected();
    }
}

- (void)requestByGet:(NSString *)path
          parameters:(id) parameters
             options:(id)options
             success:(void (^)(LEHttpRequestOperation *operation, id response))success
             failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure {
    [self checkNetworkingStatus:^{
        [[self operationManage:options] GET:[NSString stringWithFormat:@"%@/%@", self.host, path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
            success(self, response);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(self, error);
        }];
    } rejected:^{
        failure(self,  [NSError errorWithDomain:LEAppErrorDomain code:LENetworkStatusError userInfo:@{NSLocalizedDescriptionKey:@"网络状态异常"}]);
    } allowNoneWifi:[self parseAllowNoneWifi:options]];
}

- (void)requestByGetAppInfoParameters:(id) parameters
             options:(id)options
             success:(void (^)(LEHttpRequestOperation *operation, id response))success
             failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure {
    [[self operationManage] GET:@"https://itunes.apple.com/lookup?id=921453267" parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        success(self, response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(self, error);
    }];
}
- (void)requestByUploadRecord:(NSData *)postData
                          Url:(NSURL*)url
                      Options:(id)options
                      success:(void (^)(LEHttpRequestOperation *operation, id response))success
                      failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure {
//    [self checkNetworkingStatus:^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        [request setTimeoutInterval:5.0];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (error) {
                                       if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
                                           failure(self, error);
                                       } else {
                                           failure(self, error);
                                       }
                                       
                                   }else{
                                       success(self, response);
                                   }
                               }];
//    } rejected:^{
//        failure(self,  [NSError errorWithDomain:LEAppErrorDomain code:LENetworkStatusError userInfo:@{NSLocalizedDescriptionKey:@"网络状态异常"}]);
//    } allowNoneWifi:[self parseAllowNoneWifi:options]];
}

- (void)requestByDownloadRecord:(NSData *)postData
                            Url:(NSURL*)url
                        Options:(id)options
                        success:(void (^)(LEHttpRequestOperation *operation, id response))success
                        failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure {
    [self checkNetworkingStatus:^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        [request setTimeoutInterval:10.0];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (error) {
                                       if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
                                           failure(self, error);
                                       } else {
                                           failure(self, error);
                                       }
                                       
                                   }else{
                                       
                                       NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                       
                                       NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       
                                       success(self, response);
                                   }
                               }];
    } rejected:^{
        failure(self,  [NSError errorWithDomain:LEAppErrorDomain code:LENetworkStatusError userInfo:@{NSLocalizedDescriptionKey:@"网络状态异常"}]);
    } allowNoneWifi:[self parseAllowNoneWifi:options]];
}

- (void)requestByPost:(NSString *)path
           parameters:(id) parameters
              options:(id)options
              success:(void (^)(LEHttpRequestOperation *operation, id response))success
              failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure {
    
    [self checkNetworkingStatus:^{
        [[self operationManage] POST:[NSString stringWithFormat:@"%@/%@", self.host, path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
            success(self, response);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(self, error);
        }];
    } rejected:^{
        failure(self,  [NSError errorWithDomain:LEAppErrorDomain code:LENetworkStatusError userInfo:@{NSLocalizedDescriptionKey:@"网络状态异常"}]);
    } allowNoneWifi:[self parseAllowNoneWifi:options]];
    
}

- (void)requestByPost:(NSString *)path
                 data:(NSData*)data
              options:(id)options
              success:(void (^)(LEHttpRequestOperation *operation, NSData* response))success
              failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure {
    
//    [self checkNetworkingStatus:^{
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.host, path]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"IOS" forHTTPHeaderField:@"User-Agent"];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString* token = [userDefaults objectForKey:kLENetworkConnectionUserToken];
        if (token) {
            [request setValue:[NSString stringWithFormat:@"oauth2 %@", token] forHTTPHeaderField:@"Authorization"];
        }
        [request setHTTPBody:data];
        [request setTimeoutInterval:10.0];
        
        NSURLResponse* response;
        NSError* error;
//        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        NSData* tdata = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            if ([tdata length] > 0 && error == nil && [httpResponse statusCode] == 200) {
                success(self, tdata);
            } else {
                failure(self, error);
            }
        } else {
            failure(self, error);
        }
        

//        [NSURLConnection sendSynchronousRequest:request
//                                           queue:queue
//                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
//                                   dispatch_async(dispatch_get_main_queue(), ^{
//                                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//                                       if ([data length] > 0 && error == nil && [httpResponse statusCode] == 200) {
//                                           success(self, data);
//                                       } else {
//                                           failure(self, error);
//                                       }
//                                   });
//                               }];
//    } rejected:^{
//        failure(self,  [NSError errorWithDomain:LEAppErrorDomain code:LENetworkStatusError userInfo:@{NSLocalizedDescriptionKey:@"网络状态异常"}]);
//    } allowNoneWifi:[self parseAllowNoneWifi:options]];
}

- (void)requestByPut:(NSString *)path
          parameters:(id) parameters
             options:(id)options
             success:(void (^)(LEHttpRequestOperation *operation, id response))success
             failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure {
    [self checkNetworkingStatus:^{
        [[self operationManage:options] PUT:[NSString stringWithFormat:@"%@/%@", self.host, path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
            success(self, response);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(self, error);
        }];
    } rejected:^{
        failure(self,  [NSError errorWithDomain:LEAppErrorDomain code:LENetworkStatusError userInfo:@{NSLocalizedDescriptionKey:@"网络状态异常"}]);
    } allowNoneWifi:[self parseAllowNoneWifi:options]];
    
}

- (void)requestByDelete:(NSString *)path
             parameters:(id) parameters
                options:(id)options
                success:(void (^)(LEHttpRequestOperation *operation, id response))success
                failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure {
    [self checkNetworkingStatus:^{
        [[self operationManage:options] DELETE:[NSString stringWithFormat:@"%@/%@", self.host, path] parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
            success(self, response);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(self, error);
        }];
    } rejected:^{
        failure(self,  [NSError errorWithDomain:LEAppErrorDomain code:LENetworkStatusError userInfo:@{NSLocalizedDescriptionKey:@"网络状态异常"}]);
    } allowNoneWifi:[self parseAllowNoneWifi:options]];
    
}

- (void)requestByFile:(NSString *)path
                 file:(NSString*)file
              options:(id)options
             progress:(void (^)(LEHttpRequestOperation *operation, long long read, long long total))progress
              success:(void (^)(LEHttpRequestOperation *operation, NSString* filePath))success
              failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure{
    
    [self checkNetworkingStatus:^{
        AFURLConnectionOperation *operation = [self.operations objectForKey:path];
        if (operation && [operation isPaused]) {
            [operation resume];
            return;
        }
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
        
        // 不使用缓存，避免文件更新下载仍是旧到文件
        operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:file append:NO];
        [operation setDownloadProgressBlock:^(NSUInteger bytes, long long read, long long total) {
            progress(self, read, total);
        }];
        [operation setCompletionBlock:^{
            AFURLConnectionOperation * operation = [self.operations objectForKey:path];
            if (operation.error) {
                failure(self, operation.error);
            } else {
                success(self, file);
            }
            [self.operations removeObjectForKey:path];
        }];
        
        [self.operations setObject:operation forKey:path];
        
        [operation start];
    } rejected:^{
        failure(self,  [NSError errorWithDomain:LEAppErrorDomain code:LENetworkStatusError userInfo:@{NSLocalizedDescriptionKey:@"网络状态异常"}]);
    } allowNoneWifi:[self parseAllowNoneWifi:options]];
}

- (void)cancelRequestByFile:(NSString *)path {
    AFURLConnectionOperation *operation = [self.operations objectForKey:path];
    if (operation) {
        [operation cancel];
    }
}

- (void)pauseRequestByFile:(NSString *)path {
    AFURLConnectionOperation *operation = [self.operations objectForKey:path];
    if (operation) {
        [operation pause];
    }
}

- (void)cancelAllFileRequests {
    [self.operations enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
        AFURLConnectionOperation *operation = obj;
        [operation cancel];
    }];
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (self.rejected) {
            self.rejected();
        }
    } else {
        if (self.accepted) {
            self.accepted();
        }
    }
    
    if (self.rejected) {
        self.rejected = nil;
    }
    if (self.accepted) {
        self.accepted = nil;
    }
}
@end