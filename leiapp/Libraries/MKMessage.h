//
//  MKMessage.h
//  Thread
//
//  Created by chenshuang on 14-5-27.
//  Copyright (c) 2014年 chenshuang. All rights reserved.
//

/*
  class  专门发送通知的类
 */

#import <Foundation/Foundation.h>
#define NOTIFY_RELOADMAINVIEW @"ReLoadMainView"
#define NOTIFY_RELOADPERSONLIST @"ReLoadPersonList"
#define NOTIFY_RELOADSETVIEW @"ReLoadSetView"
#define NOTIFY_WEBFINISH @"WebFinish"
#define NOTIFY_PRESENTMEDIA @"PresentMedia"
#define NOTIFY_COURSEIDARRAY @"CourseIDArray"
#define NOTIFY_MESSAGECHATVIEW @"MessageChatView"
#define NOTIFY_QUIT @"quit"
#define NOTIFY_REFRESHSETCLASSVIEW @"RefreshSetClassView"

#define NOTIFY_RECIVEMESSAGE @"ReciveMessage"

@interface MKMessage : NSObject

/*!
 *	@brief	单例方法
 *
 *	@return	返回对象
 */
+(MKMessage *)shareMessage;

/*!
 *	@brief	发送通知的方法
 *
 *	@param 	data 	接受通知者需要的数据
 *	@param 	name 	通知标识符
 */
-(void)postotification:(id)data name:(NSString*)strng;

@end

/************************************
获取消息的方法
 [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(Recv:) name:@"MKTcpClient Recv" object:nil];

*************************************/