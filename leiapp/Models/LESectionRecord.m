//
//  LESectionRecord.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LESectionRecord.h"

@implementation LESectionRecord

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"sectionID": @"sectionId",
                                                       @"studyTime": @"duration"
                                                       }];
}

@end
