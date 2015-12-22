//
//  LECourseLessonsViewControllerLessonView.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/7/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECourseLesson.h"

@class LECourseLessonsViewControllerLessonView;

@protocol LECourseLessonsViewControllerLessonViewDelegate <NSObject>
- (void)courseLessonsViewControllerLessonView:(LECourseLessonsViewControllerLessonView*)courseLessonsViewControllerLessonView studyLesson:(LECourseLesson*)lesson;
@end

@interface LECourseLessonsViewControllerLessonView : UIView

@property (strong, nonatomic) LECourseLesson *courseLesson;

@property (assign, nonatomic) id<LECourseLessonsViewControllerLessonViewDelegate> delegate;

- (void)refreshDisplay;

@end
