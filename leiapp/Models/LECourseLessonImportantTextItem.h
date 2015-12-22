//
//  LECourseLessonImportantTextItem.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItem.h"

@protocol LECourseLessonImportantTextItem
@end

@interface LECourseLessonImportantTextItem : LECourseLessonSectionItem
@property (nonatomic, strong) NSString* text;
@end
