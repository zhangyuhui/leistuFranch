//
//  LECourseLessonSectionItemLEIPracticeItemView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/5/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECourseLessonLEIPracticeQuestion.h"

@interface LECourseLessonSectionItemLEIPracticeView : UIView
@property (strong, nonatomic) LECourseLessonLEIPracticeQuestion* question;
@property (assign, nonatomic) BOOL submited;
@property (assign, nonatomic) BOOL playing;
-(CGFloat)heightForView;
@end
