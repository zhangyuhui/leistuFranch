//
//  LECommentService.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/23/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseService.h"
#import "LEComment.h"

@interface LECommentService : LEBaseService

+ (instancetype)sharedService;

- (void)getComments:(int)courseId
               page:(int)page
            success:(void (^)(LECommentService *service, int page, NSArray* comments))success
            failure:(void (^)(LECommentService *service, NSString* error))failure;

- (void)getCommentsCount:(int)courseId
            success:(void (^)(LECommentService *service, int count))success
            failure:(void (^)(LECommentService *service, NSString* error))failure;

- (void)postComment:(int)countId
               text:(NSString*)text
            success:(void (^)(LECommentService *service, LEComment* comment))success
            failure:(void (^)(LECommentService *service, NSString* error))failure;

- (void)postReply:(int)courseId
        commentId:(int)commentId
             text:(NSString*)text
          success:(void (^)(LECommentService *service, LEComment* comment))success
          failure:(void (^)(LECommentService *service, NSString* error))failure;

- (void)getMyComments:(int)courseId
                 page:(int)page
              success:(void (^)(LECommentService *service, int page, NSArray* comments))success
              failure:(void (^)(LECommentService *service, NSString* error))failure;

- (void)getReplies:(int)commentId
              success:(void (^)(LECommentService *service, NSArray* comments))success
              failure:(void (^)(LECommentService *service, NSString* error))failure;

- (void)deleteComment:(int)commentId
              success:(void (^)(LECommentService *service))success
              failure:(void (^)(LECommentService *service, NSString* error))failure;


@end
