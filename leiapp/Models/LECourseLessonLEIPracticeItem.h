//
//  LELessonLEIPracticeItem.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItem.h"
#import "LECourseLessonLEIPracticeQuestion.h"

@interface LECourseLessonLEIPracticeItem : LECourseLessonSectionItem
@property (nonatomic, strong) NSArray<LECourseLessonLEIPracticeQuestion>* questions;
@property (nonatomic) NSInteger score;
@end
