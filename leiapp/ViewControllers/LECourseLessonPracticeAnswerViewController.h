//
//  LECourseLessonPracticeAnswerViewController.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/6/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseModalViewController.h"
#import "LECourseLessonLEIPracticeItem.h"
#import "LECourseLesson.h"
#import "LEPageRecord.h"

@interface LECourseLessonPracticeAnswerViewController : LEBaseModalViewController
- (instancetype)initWithLEIPractice:(LECourseLessonLEIPracticeItem*)practice lesson:(LECourseLesson*)lesson section:(LECourseLessonSection*)section pageRecord:(LEPageRecord*) pageRecord;
@end
