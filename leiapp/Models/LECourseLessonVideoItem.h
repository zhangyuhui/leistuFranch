//
//  LELessonVideoItem.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItem.h"

@protocol LECourseLessonVideoItem
@end

@interface LECourseLessonVideoItem : LECourseLessonSectionItem
@property (nonatomic, strong) NSString* video;
@end
