//
//  LEPageNoteRecord.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEPageAudioPractice.h"

@implementation LEPageAudioPractice

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    if ([propertyName isEqualToString: @"score"]) return YES;
    if ([propertyName isEqualToString: @"minutimes"]) return YES;
    if ([propertyName isEqualToString: @"type"]) return YES;
    return NO;
}

@end
