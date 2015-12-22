//
//  LEBaseService.m
//  leiapp
//
//  Created by Yuhui Zhang on 9/4/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseService.h"
#import "NSString+InflectionSupport.h"
#import "LEDefines.h"

@implementation LEBaseService

- (void)persistent {
    
}

- (void)restore {
    
}
+ (NSString*)rootDataPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* userId = setUserID(nil);
    if (userId) {
        NSString * path = [[paths objectAtIndex:0] stringByAppendingPathComponent:userId];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSError* error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
        }
        return path;
    } else {
        return [paths objectAtIndex:0];
    }
}
- (NSString*)dataPathWithAccount{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* className = NSStringFromClass([self class]);
    NSString *prefix = @"LE";
    if ([className hasPrefix:prefix]) {
        className = [className substringFromIndex:[prefix length]];
    }
    NSString* _path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[[className dasherize] stringByAppendingString:@"_objects"]];
    return _path;
}

- (NSString*)dataPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* className = NSStringFromClass([self class]);
    NSString *prefix = @"LE";
    if ([className hasPrefix:prefix]) {
        className = [className substringFromIndex:[prefix length]];
    }
    NSString* _path = [[[paths objectAtIndex:0] stringByAppendingPathComponent:[[className dasherize] stringByAppendingString:@"_objects_"]] stringByAppendingString:setUserID(nil)];
    NSLog(@"datapath=%@", _path);
    return _path;
}

- (NSString*)dataPath:category {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* className = NSStringFromClass([self class]);
    NSString *prefix = @"LE";
    if ([className hasPrefix:prefix]) {
        className = [className substringFromIndex:[prefix length]];
    }
    NSString* path = [NSString stringWithFormat:@"_%@_objects_%@", category, setUserID(nil)];
    NSLog(@"path=%@", path);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:[[className dasherize] stringByAppendingString:path]];
}
@end
