//
//  LECourseLessonGlossaryDetailViewController.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/19/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseViewController.h"
#import "LECourse.h"

@interface LECourseLessonGlossaryDetailViewController : LEBaseViewController
- (instancetype)initWithGlossaries:(NSArray*)glossaries index:(NSUInteger)index;
@end
