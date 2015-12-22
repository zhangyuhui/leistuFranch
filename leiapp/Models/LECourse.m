//
//  LECourse.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/19/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourse.h"

@implementation LECourse


+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"introduction",
                                                       @"copyRight": @"copyright",
                                                       @"id": @"identifier",
                                                       @"androidCover": @"cover"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    if ([propertyName isEqualToString: @"status"]) return YES;
    if ([propertyName isEqualToString: @"download"]) return YES;
    return NO;
}

-(NSData*)toJSONData {
    return [super toJSONData];
}

@end
