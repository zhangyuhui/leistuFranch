//
//  LEHttpRequestOperation.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/14/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEHttpRequestOperation : NSObject

- (instancetype)initWithHost: (NSString*)host;

- (void)requestByGet:(NSString *)path
          parameters:(id)parameters
             options:(id)options
             success:(void (^)(LEHttpRequestOperation *operation, id response))success
             failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure;

- (void)requestByGetAppInfoParameters:(id) parameters
                       options:(id)options
                       success:(void (^)(LEHttpRequestOperation *operation, id response))success
                       failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure;

- (void)requestByPost:(NSString *)path
          parameters:(id)parameters
             options:(id)options
             success:(void (^)(LEHttpRequestOperation *operation, id response))success
             failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure;

- (void)requestByPost:(NSString *)path
                 data:(NSData*)data
              options:(id)options
              success:(void (^)(LEHttpRequestOperation *operation, NSData* response))success
              failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure;

- (void)requestByPut:(NSString *)path
           parameters:(id)parameters
              options:(id)options
              success:(void (^)(LEHttpRequestOperation *operation, id response))success
              failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure;

- (void)requestByDelete:(NSString *)path
          parameters:(id)parameters
             options:(id)options
             success:(void (^)(LEHttpRequestOperation *operation, id response))success
             failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure;

- (void)requestByFile:(NSString *)path
                 file:(NSString*)file
              options:(id)options
             progress:(void (^)(LEHttpRequestOperation *operation, long long read, long long total))progress
              success:(void (^)(LEHttpRequestOperation *operation, NSString* filePath))success
              failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure;

- (void)requestByUploadRecord:(NSData *)postData
                          Url:(NSURL*)url
                      Options:(id)options
                      success:(void (^)(LEHttpRequestOperation *operation, id response))success
                      failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure;
- (void)requestByDownloadRecord:(NSData *)postData
                          Url:(NSURL*)url
                      Options:(id)options
                      success:(void (^)(LEHttpRequestOperation *operation, id response))success
                      failure:(void (^)(LEHttpRequestOperation *operation, NSError *error))failure;


- (void)cancelRequestByFile:(NSString *)path;

- (void)pauseRequestByFile:(NSString *)path;

- (void)cancelAllFileRequests;

@end
