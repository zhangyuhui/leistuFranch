//
//  LEPageAudioRecord.m
//  leiappv2
//
//  Created by Yuhui Zhang on 12/1/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEPageAudioRecord.h"

@implementation LEPageAudioRecord

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"filepath": @"filePath"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    if ([propertyName isEqualToString: @"minutimes"]) return YES;
    if ([propertyName isEqualToString: @"recordedCount"]) return YES;
    if ([propertyName isEqualToString: @"type"]) return YES;
    if ([propertyName isEqualToString: @"score"]) return YES;
    return NO;
}

@end
