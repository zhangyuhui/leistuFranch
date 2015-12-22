//
//  LECourseBookmark.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/23/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseBookmark.h"

@implementation LECourseBookmark

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"lessonID": @"lessonId",
                                                       @"sectionID": @"sectionId",
                                                       @"pageID": @"pageId"
                                                       }];
}

@end
