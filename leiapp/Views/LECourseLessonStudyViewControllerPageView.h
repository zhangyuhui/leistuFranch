//
//  LECourseLessonStudyViewControllerPageView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/25/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECustomView.h"
#import "LECourseLessonSection.h"
#import "LEPageRecord.h"

@protocol LECourseLessonStudyViewControllerPageViewDelegate <NSObject>

@end

@interface LECourseLessonStudyViewControllerPageView : LECustomView
@property (nonatomic, strong) LECourseLessonSection* section;
@property (nonatomic, assign) id<LECourseLessonStudyViewControllerPageViewDelegate> delegate;
- (void)setSection:(LECourseLessonSection *)section pagerecord:(LEPageRecord*)record;
@end
