//
//  LECourseLessonPlainTextItem.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItem.h"

@protocol LECourseLessonPlainTextItem
@end

@interface LECourseLessonPlainTextItem : LECourseLessonSectionItem
@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSArray* list;
@end
