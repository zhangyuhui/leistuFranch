//
//  LECourseLessonPracticeAnswerFooterView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 12/25/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECustomView.h"

@interface LECourseLessonPracticeAnswerFooterView : LECustomView
@property (strong, nonatomic) NSArray* answers;
-(CGFloat)heightForView;
@end
