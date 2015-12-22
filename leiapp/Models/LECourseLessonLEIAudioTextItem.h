//
//  LELessonLEIAudioTextItem.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItem.h"
#import "LECourseLessonLEIAudioText.h"

@protocol LECourseLessonLEIAudioTextItem
@end

@interface LECourseLessonLEIAudioTextItem : LECourseLessonSectionItem
@property (nonatomic, strong) NSArray<LECourseLessonLEIAudioText>* audioTexts;
@end
