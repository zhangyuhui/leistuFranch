//
//  LECourseLessonStudyViewController.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/24/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseViewController.h"
#import "LECourse.h"

@protocol LECourseLessonStudyViewControllerDelegate <NSObject>
-(void) refreshPage;
@end

@interface LECourseLessonStudyViewController : LEBaseViewController
@property (nonatomic, strong) id <LECourseLessonStudyViewControllerDelegate> delegate;
- (instancetype)initWithCourse:(LECourse*)course lesson:(NSUInteger)lesson;
- (instancetype)initWithCourse:(LECourse*)course lesson:(NSUInteger)lesson section:(NSUInteger)section;

@end
