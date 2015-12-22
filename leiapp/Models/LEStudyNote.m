//
//  LEStudyNote.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEStudyNote.h"

@implementation LEStudyNote

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"lessonID": @"lessonId",
                                                       @"sectionID": @"sectionId",
                                                       @"pageID": @"pageId"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    if ([propertyName isEqualToString: @"courseId"]) return YES;
    return NO;
}


@end
