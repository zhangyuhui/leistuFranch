//
//  LECourseLessonSummarylViewControllerCell.h
//  leiappv2
//
//  Created by Yuhui Zhang on 11/9/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECourseLessonSection.h"
#import "LECourseLesson.h"
#import "LEPageRecord.h"
@interface LECourseLessonSummarylViewControllerCell : UITableViewCell
@property (strong, nonatomic) LECourseLessonSection *lessonSection;
@property (strong, nonatomic) LEPageRecord *pageRecord;
@property (strong, nonatomic) LECourseLesson *lesson;

+ (instancetype)courseLessonSummarylViewControllerCell;
@end
