//
//  LEPageRecord.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEPageRecord.h"

@implementation LEPageRecord

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"pageID": @"pageId",
                                                       @"complete": @"isCompleted",
                                                       @"studyTime": @"duration"
                                                       }];
}

@end

