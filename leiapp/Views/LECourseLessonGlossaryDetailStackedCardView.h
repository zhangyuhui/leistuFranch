//
//  LECourseLessonGlossaryDetailStackedCardView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/19/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECourseGlossary.h"

@interface LECourseLessonGlossaryDetailStackedCardView : UIView
@property (strong, nonatomic) LECourseGlossary *glossary;

+ (instancetype)courseLessonGlossaryDetailStackedCardView;
@end
