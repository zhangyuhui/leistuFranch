//
//  LECourseTestSectionItem.m
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseTestSectionItem.h"

@implementation LECourseTestSectionItem

- (instancetype)initWithType:(LECourseTestSectionItemType)type{
    self = [super init];
    if (self){
        _type = type;
    }
    return self;
}

@end
