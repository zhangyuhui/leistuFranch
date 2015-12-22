//
//  LECourseLessonSectionItemLEIPracticeItemView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/5/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEAudioCustomView.h"

typedef NS_ENUM(NSInteger, LECourseLessonSectionItemLEIPracticeAnswer) {
    LECourseLessonSectionItemLEIPracticeAnswerNone = 0,
    LECourseLessonSectionItemLEIPracticeAnswerCorrect,
    LECourseLessonSectionItemLEIPracticeAnswerWrong,
    LECourseLessonSectionItemLEIPracticeAnswerMiss
};

@interface LECourseLessonSectionItemLEIPracticeItemView : LEAudioCustomView
@property (assign, nonatomic) int index;
@property (assign, nonatomic) BOOL checked;
@property (assign, nonatomic) BOOL multiple;
@property (assign, nonatomic) LECourseLessonSectionItemLEIPracticeAnswer answer;

-(CGFloat)heightForView;
@end
