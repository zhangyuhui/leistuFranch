//
//  LECommentService.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/23/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECommentService.h"
#import "LEHttpRequestOperation.h"
#import "LEConstants.h"
#import "LEErrors.h"

#define kCommentServicePathGetComments        @"course/comments"
#define kCommentServicePathGetReplies         @"course/comments/replies"

@interface LECommentService ()

@property (strong, nonatomic) LEHttpRequestOperation* requestOperation;

- (void)handleGetCommentsFailure:(NSString*)error failure:(void (^)(LECommentService *service, NSString* error)) failure;
- (void)handleGetCommentsSuccess:(NSArray*)comments page:(int)page success:(void (^)(LECommentService *service, int page, NSArray* comments))success;
- (void)handleGetCommentsSuccess:(NSArray*)comments success:(void (^)(LECommentService *service, NSArray* comments))success;

- (void)handleGetCommentsCountFailure:(NSString*)error failure:(void (^)(LECommentService *service, NSString* error)) failure;
- (void)handleGetCommentsCountSuccess:(int)count success:(void (^)(LECommentService *service, int count))success;

- (void)handlePostCommentFailure:(NSString*)error failure:(void (^)(LECommentService *service, NSString* error)) failure;
- (void)handlePostCommentSuccess:(LEComment*)comment success:(void (^)(LECommentService *service, LEComment* comment))success;

- (void)handleDeleteCommentFailure:(NSString*)error failure:(void (^)(LECommentService *service, NSString* error)) failure;
- (void)handleDeleteCommentSuccess:(void (^)(LECommentService *service))success;

@end

@implementation LECommentService

+ (instancetype)sharedService {
    static LECommentService *sharedService = nil;
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

- (void)handleGetCommentsFailure:(NSString*)error failure:(void (^)(LECommentService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleGetCommentsSuccess:(NSArray*)comments page:(int)page success:(void (^)(LECommentService *service, int page, NSArray* comments))success {
    success(self, page, comments);
}

- (void)handleGetCommentsSuccess:(NSArray*)comments success:(void (^)(LECommentService *service, NSArray* comments))success {
    success(self, comments);
}

- (void)handleGetCommentsCountFailure:(NSString*)error failure:(void (^)(LECommentService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleGetCommentsCountSuccess:(int)count success:(void (^)(LECommentService *service, int count))success {
    success(self, count);
}

- (void)handlePostCommentFailure:(NSString*)error failure:(void (^)(LECommentService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handlePostCommentSuccess:(LEComment*)comment success:(void (^)(LECommentService *service, LEComment* comment))success {
    success(self, comment);
}

- (void)handleDeleteCommentFailure:(NSString*)error failure:(void (^)(LECommentService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleDeleteCommentSuccess:(void (^)(LECommentService *service))success {
    success(self);
}

- (void)getComments:(int)courseId
               page:(int)page
            success:(void (^)(LECommentService *service, int page, NSArray* comments))success
            failure:(void (^)(LECommentService *service, NSString* error))failure {
    
    [self.requestOperation requestByGet: [NSString stringWithFormat:@"%@/%d/%d", kCommentServicePathGetComments, courseId, page] parameters:nil options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSArray* responseArray = response;
        NSMutableArray* comments = [NSMutableArray arrayWithCapacity:[responseArray count]];
        [response enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            LEComment* comment = [[LEComment alloc] initWithDictionary:object error:nil];
            [comments addObject: comment];
        }];
        [self handleGetCommentsSuccess:comments page:page success:success];
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleGetCommentsFailure:nil failure:failure];
        } else {
            [self handleGetCommentsFailure:[error localizedDescription] failure:failure];
        }
    }];
}

- (void)getCommentsCount:(int)courseId
                 success:(void (^)(LECommentService *service, int count))success
                 failure:(void (^)(LECommentService *service, NSString* error))failure {
    [self.requestOperation requestByGet: [NSString stringWithFormat:@"%@/%d", kCommentServicePathGetComments, courseId] parameters:nil options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSNumber* count = [response objectForKey:@"count"];
        [self handleGetCommentsCountSuccess:[count intValue] success:success];
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleGetCommentsCountFailure:nil failure:failure];
        } else {
            [self handleGetCommentsCountFailure:[error localizedDescription] failure:failure];
        }
    }];
}

- (void)postComment:(int)courseId
               text:(NSString*)text
            success:(void (^)(LECommentService *service, LEComment* comment))success
            failure:(void (^)(LECommentService *service, NSString* error))failure {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    NSString* userName = [userDefaults objectForKey:kLENetworkConnectionUserName];
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"username", text, @"text", nil];
    
    [self.requestOperation requestByPost: [NSString stringWithFormat:@"%@/%d/%d", kCommentServicePathGetComments, courseId, [userId intValue]] parameters:parameters options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSError* error = nil;
        LEComment* comment = [[LEComment alloc] initWithDictionary:response error:&error];
        if (error) {
            [self handlePostCommentFailure:@"发送评论出错" failure:failure];
        } else {
            [self handlePostCommentSuccess:comment success:success];
        }
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handlePostCommentFailure:nil failure:failure];
        } else {
            [self handlePostCommentFailure:[error localizedDescription] failure:failure];
        }
    }];
    
}

- (void)postReply:(int)courseId
        commentId:(int)commentId
             text:(NSString*)text
          success:(void (^)(LECommentService *service, LEComment* comment))success
          failure:(void (^)(LECommentService *service, NSString* error))failure {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    NSString* userName = [userDefaults objectForKey:kLENetworkConnectionUserName];
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"username", text, @"text", commentId, @"parentID", nil];
    
    [self.requestOperation requestByPost: [NSString stringWithFormat:@"%@/%d/%d", kCommentServicePathGetComments, courseId, [userId intValue]] parameters:parameters options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSError* error = nil;
        LEComment* comment = [[LEComment alloc] initWithDictionary:response error:&error];
        if (error) {
            [self handlePostCommentFailure:@"发送评论出错" failure:failure];
        } else {
            [self handlePostCommentSuccess:comment success:success];
        }
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handlePostCommentFailure:nil failure:failure];
        } else {
            [self handlePostCommentFailure:[error localizedDescription] failure:failure];
        }
    }];
    
}

- (void)getMyComments:(int)courseId
                 page:(int)page
              success:(void (^)(LECommentService *service, int page, NSArray* comments))success
              failure:(void (^)(LECommentService *service, NSString* error))failure {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    
    [self.requestOperation requestByGet: [NSString stringWithFormat:@"%@/%d/%d/%d", kCommentServicePathGetComments, courseId, [userId intValue], page] parameters:nil options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSArray* responseArray = response;
        NSMutableArray* comments = [NSMutableArray arrayWithCapacity:[responseArray count]];
        [response enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            LEComment* comment = [[LEComment alloc] initWithDictionary:object error:nil];
            [comments addObject: comment];
        }];
        [self handleGetCommentsSuccess:comments page:page success:success];
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleGetCommentsFailure:nil failure:failure];
        } else {
            [self handleGetCommentsFailure:[error localizedDescription] failure:failure];
        }
    }];
    
}

- (void)getReplies:(int)commentId
           success:(void (^)(LECommentService *service, NSArray* comments))success
           failure:(void (^)(LECommentService *service, NSString* error))failure {
    
    [self.requestOperation requestByGet: [NSString stringWithFormat:@"%@/%d", kCommentServicePathGetReplies, commentId] parameters:nil options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSArray* responseArray = response;
        NSMutableArray* comments = [NSMutableArray arrayWithCapacity:[responseArray count]];
        [response enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            LEComment* comment = [[LEComment alloc] initWithDictionary:object error:nil];
            [comments addObject: comment];
        }];
        [self handleGetCommentsSuccess:comments success:success];
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleGetCommentsFailure:nil failure:failure];
        } else {
            [self handleGetCommentsFailure:[error localizedDescription] failure:failure];
        }
    }];
}

- (void)deleteComment:(int)commentId
              success:(void (^)(LECommentService *service))success
              failure:(void (^)(LECommentService *service, NSString* error))failure {
    
    [self.requestOperation requestByDelete: [NSString stringWithFormat:@"%@/%d", kCommentServicePathGetReplies, commentId] parameters:nil options:nil success:^(LEHttpRequestOperation *operation, id response) {
        [self handleDeleteCommentSuccess:success];
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleDeleteCommentFailure:nil failure:failure];
        } else {
            [self handleDeleteCommentFailure:[error localizedDescription] failure:failure];
        }
    }];
}

@end
