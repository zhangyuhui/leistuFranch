//
//  LECourseLessonSummarylViewController.h
//  leiappv2
//
//  Created by Yuhui Zhang on 11/9/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseViewController.h"
#import "LECourse.h"
#import "LECourseLesson.h"
#import "LELessonRecord.h"

@interface LECourseLessonSummarylViewController : LEBaseViewController
@property(nonatomic, strong) LELessonRecord* lessonRecord;
@property(nonatomic, strong) NSArray* pages;
- (instancetype)initWithCourseAndLesson:(LECourse*)course lesson:(LECourseLesson*)lesson;
@end
