//
//  LELessonLEIAudioItem.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItem.h"

@protocol LECourseLessonLEIAudioItem
@end

@interface LECourseLessonLEIAudioItem : LECourseLessonSectionItem
@property (nonatomic, strong) NSString<Optional>* direction;
@property (nonatomic, strong) NSString* audio;
@property (nonatomic, strong) NSString<Optional>* cover;
@property (nonatomic, strong) NSString<Optional>* transcript;
@end
