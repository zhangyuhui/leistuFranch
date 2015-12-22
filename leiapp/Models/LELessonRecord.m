//
//  LELessonRecord.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LELessonRecord.h"

@implementation LELessonRecord

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"lessonID": @"lessonId"
                                                       }];
}

@end
