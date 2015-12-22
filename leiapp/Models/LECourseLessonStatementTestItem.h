//
//  LELessonStatementTestItem.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItem.h"

@protocol LECourseLessonStatementTestItem
@end

@interface LECourseLessonStatementTestItem : LECourseLessonSectionItem

@property (nonatomic, strong) NSString* note;
@property (nonatomic, strong) NSArray*  statements;
@property (nonatomic, strong) NSArray*  answers;

@end
