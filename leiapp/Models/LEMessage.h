//
//  LEMessage.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"
#import <UIKit/UIKit.h>

typedef enum {
    LEMessageTypeText  = 0, //文本
    LEMessageTypeAudio = 1, //语音
    LEMessageTypeImage = 2  //图片
} LEMessageType;

typedef enum {
    LEMessageModePublic   = 1, //群聊
    LEMessageModeOptional = 2, //可选
    LEMessageModePrivate  = 3  //私聊
} LEMessageMode;

@interface LEMessage : JSONModel

@property (assign, nonatomic) int senderId;
@property (strong, nonatomic) NSString* senderName;

@property (assign, nonatomic) int receiverId;
@property (strong, nonatomic) NSString* receiverName;

@property (assign, nonatomic) LEMessageMode mode;  // 聊天模式

@property (assign, nonatomic) LEMessageType type;  // 内容类型

@property (strong, nonatomic) NSString* content;

@property (strong, nonatomic) NSDate* timestamp;
@end
