//
//  LELessonOptionTestItem.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItem.h"

@protocol LECourseLessonOptionTestItem
@end

@interface LECourseLessonOptionTestItem : LECourseLessonSectionItem

@property (nonatomic, strong) NSString* question;
@property (nonatomic, strong) NSArray*  options;
@property (nonatomic, strong) NSArray*  answers;
@property (nonatomic, strong) NSArray*  selections;
@property (nonatomic, strong) NSString* feedback;
@property (nonatomic, assign) BOOL      submited;

@end
