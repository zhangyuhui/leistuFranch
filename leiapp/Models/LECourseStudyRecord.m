//
//  LEStudyRecord.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseStudyRecord.h"

@implementation LECourseStudyRecord

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"courseID": @"courseId"
                                                       }];
}

@end
