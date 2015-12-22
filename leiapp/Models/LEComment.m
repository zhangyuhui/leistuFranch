//
//  LEComment.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/23/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEComment.h"

@implementation LEComment

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"identity",
                                                       @"sub_num": @"count",
                                                       @"username": @"userName"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    if ([propertyName isEqualToString: @"parentId"]) return YES;
    return NO;
}

@end
