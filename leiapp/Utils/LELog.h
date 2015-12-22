//
//  LELog.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/13/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Verbose(s,...) [Logging performLog:LELogLevelVerbose file:__FILE__ method:NSStringFromSelector(_cmd) line:__LINE__ format:(s),##__VA_ARGS__]
#define Debug(s,...) [Logging performLog:LELogLevelDebug file:__FILE__ method:NSStringFromSelector(_cmd) line:__LINE__ format:(s),##__VA_ARGS__]
#define Info(s,...) [Logging performLog:LELogLevelInfo file:__FILE__ method:NSStringFromSelector(_cmd) line:__LINE__ format:(s),##__VA_ARGS__]
#define Warning(s,...) [Logging performLog:LELogLevelWarning file:__FILE__ method:NSStringFromSelector(_cmd) line:__LINE__ format:(s),##__VA_ARGS__]
#define Error(s,...) [Logging performLog:LELogLevelError file:__FILE__ method:NSStringFromSelector(_cmd) line:__LINE__ format:(s),##__VA_ARGS__]

typedef NS_ENUM(NSInteger, LELogLevel) {
    LELogLevelUndefined = 0,
    LELogLevelVerbose,
    LELogLevelDebug,
    LELogLevelInfo,
    LELogLevelWarning,
    LELogLevelError
};


@interface LELog : NSObject
+(BOOL)performLog:(LELogLevel)level file:(char*)file method:(NSString *)method line:(int)line format:(NSString*)format, ...;
@end

