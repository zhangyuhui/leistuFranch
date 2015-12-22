//
//  GapCourseProcess.h
//  CordovaLibTests
//
//  Created by Rambo on 15/7/8.
//
//


#import <AVFoundation/AVFoundation.h>
#import <Cordova/CDV.h>
@interface GapCourseProcess : CDVPlugin<AVAudioPlayerDelegate>
- (void)finish:(CDVInvokedUrlCommand*)command;//返回首页
- (void)back:(CDVInvokedUrlCommand*)command; //
- (void)forward:(CDVInvokedUrlCommand*)command;

- (void)responselist:(CDVInvokedUrlCommand*)command;
- (void)getClassCourseLesson:(CDVInvokedUrlCommand*)command;
- (void)setClassCourseLesson:(CDVInvokedUrlCommand*)command;
- (void)play:(CDVInvokedUrlCommand*)command;
- (void)pause:(CDVInvokedUrlCommand*)command;
- (void)stop:(CDVInvokedUrlCommand*)command;
- (void)device:(CDVInvokedUrlCommand*)command;

- (void)getUser:(CDVInvokedUrlCommand*)command;
- (void)findpwd:(CDVInvokedUrlCommand*)command;
@end
