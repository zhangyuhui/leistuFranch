//
//  UFile.h
//  LeiTeacherClient
//
//  Created by Rambo on 15/7/23.
//  Copyright (c) 2015年 U-Learning. All rights reserved.
//

#import <Cordova/CDV.h>

@interface UFile : CDVPlugin
- (void)upload:(CDVInvokedUrlCommand*)command;
- (void)stopUpload:(CDVInvokedUrlCommand*)command;
- (void)delete:(CDVInvokedUrlCommand*)command;
- (void)fileDetail:(CDVInvokedUrlCommand*)command;
- (void)selecteSpokenFile:(CDVInvokedUrlCommand*)command;
- (void)deleteFile:(CDVInvokedUrlCommand*)command;
- (void)uploadSpokenFile:(CDVInvokedUrlCommand*)command;
- (void)startRecord:(CDVInvokedUrlCommand*)command;
- (void)stopRecord:(CDVInvokedUrlCommand*)command;
- (void)playRecord:(CDVInvokedUrlCommand*)command;
- (void)stopPlayRecord:(CDVInvokedUrlCommand*)command;
@end
