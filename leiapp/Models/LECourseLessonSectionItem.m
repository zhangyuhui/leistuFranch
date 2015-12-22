//
//  LELessonSectionItem.m
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItem.h"
#import "LECourseLessonLEIPlainTextItem.h"

@implementation LECourseLessonSectionItem

- (instancetype)initWithType:(LECourseLessonSectionItemType)type {
    self = [super init];
    if (!self) {
        return nil;
    }
    _type = type;
    return self;
}

@end
