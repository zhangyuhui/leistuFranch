//
//  LECourseDetail.m
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseDetail.h"

@implementation LECourseDetail

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    if ([propertyName isEqualToString: @"historyLesson"]) return YES;
    return NO;
}
@end
