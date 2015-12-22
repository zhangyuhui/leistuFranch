//
//  MKMessage.m
//  Thread
//
//  Created by chenshuang on 14-5-27.
//  Copyright (c) 2014年 chenshuang. All rights reserved.
//

#import "MKMessage.h"

@implementation MKMessage

static MKMessage * message;
+(MKMessage *)shareMessage{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!message) {
            message=[[MKMessage alloc]init];
        }
    });
    return message;
}

-(void)postotification:(id)data name:(NSString*)strng
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"发送通知：%@",data);
    [[NSNotificationCenter defaultCenter] postNotificationName:strng object:data];
    });
}

@end
