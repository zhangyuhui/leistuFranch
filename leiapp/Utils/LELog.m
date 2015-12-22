//
//  LELog.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/13/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LELog.h"

// Log level
#if defined (DEBUG_ICOLLEDGE)
static const LELogLevel kLELogLevel = LELogLevelDebug;
#else
static const LELogLevel kLELogLevel = LELogLevelInfo;
#endif

static const BOOL kDefaultMethodNameDisplay = YES;

// Log Descriptions
static NSString * const kLogLevelUndefined = @"Undefined";
static NSString * const kLogLevelVerbose = @"Verbose";
static NSString * const kLogLevelDebug = @"Debug";
static NSString * const kLogLevelInfo = @"Info";
static NSString * const kLogLevelWarn = @"Warn";
static NSString * const kLogLevelError = @"Error";

@interface LELog()
+(NSString *) logDescritionBasedOnLogLevel:(LELogLevel) level;
+(BOOL) logOutputString:(NSString *) logString;
@end


@implementation LELog

+(BOOL) performLog:(LELogLevel)level file:(char*)sourceFile method:(NSString *)method line:(int)line format:(NSString*)format, ... {
    BOOL success = NO;
    if (level >= kLELogLevel) {
        va_list ap;
        va_start(ap,format);
        NSString * fileName = [[NSString alloc] initWithBytes:sourceFile length:strlen(sourceFile) encoding:NSUTF8StringEncoding];
        NSString * printString = [[NSString alloc] initWithFormat:format arguments:ap];
        va_end(ap);
        NSString * displayMethodName = (kDefaultMethodNameDisplay) ? method : @"";
        NSString * logString = [NSString stringWithFormat:@"[%s:%@:%d] %@: %@",[[fileName lastPathComponent] UTF8String],
                                displayMethodName, line, [[self class] logDescritionBasedOnLogLevel:level], printString];
        success = [[self class] logOutputString:logString];
    }
    return success;
}

+(BOOL) logOutputString:(NSString *) logString {
    NSLog(@"%@", logString);
    return YES;
}

+(NSString *) logDescritionBasedOnLogLevel:(LELogLevel) level {
    NSString * description = kLogLevelUndefined;
    switch (level) {
        case LELogLevelVerbose:
            description = kLogLevelVerbose;
            break;
        case LELogLevelDebug:
            description = kLogLevelDebug;
            break;
        case LELogLevelInfo:
            description = kLogLevelInfo;
            break;
        case LELogLevelWarning:
            description = kLogLevelWarn;
            break;
        case LELogLevelError:
            description = kLogLevelError;
            break;
        default:
            description = kLogLevelUndefined;
            break;
    }
    return description;
}


@end