//
//  LELessonPPTItem.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItem.h"

@protocol LECourseLessonPPTItem
@end

@interface LECourseLessonPPTItem : LECourseLessonSectionItem

@property (nonatomic, strong) NSString* video;
@property (nonatomic, strong) NSString* image;
@property (nonatomic, assign) BOOL next;

@end
