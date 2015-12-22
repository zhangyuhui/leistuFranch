//
//  LELessonLEIAudioResponseItem.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItem.h"
#import "LECourseLessonLEIAudioResponse.h"

@protocol LECourseLessonLEIAudioResponseItem
@end

@interface LECourseLessonLEIAudioResponseItem : LECourseLessonSectionItem
@property (nonatomic, assign) int total;
@property (nonatomic, assign) int score;
@property (nonatomic, strong) NSArray<LECourseLessonLEIAudioResponse>* responses;
@end
