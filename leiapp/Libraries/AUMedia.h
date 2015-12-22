//
//  UMedia.h
//  LeiTeacherClient
//
//  Created by Rambo on 15/7/23.
//  Copyright (c) 2015年 U-Learning. All rights reserved.
//

#import <Cordova/CDV.h>

@interface AUMedia : CDVPlugin
- (void)playVideo:(CDVInvokedUrlCommand*)command;
- (void)playAudio:(CDVInvokedUrlCommand*)command;
- (void)stopAudio:(CDVInvokedUrlCommand*)command;
@end
