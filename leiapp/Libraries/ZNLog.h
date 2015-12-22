//
//  ZNLog.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//

//#import <Cocoa/Cocoa.h>


@interface ZNLog : NSObject {}


+(void)file:(char*)sourceFile function:(char*)functionName lineNumber:(int)lineNumber format:(NSString*)format, ...;

#define ZNLog(s, ...) [ZNLog file:__FILE__ function: (char *)__FUNCTION__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]

@end

