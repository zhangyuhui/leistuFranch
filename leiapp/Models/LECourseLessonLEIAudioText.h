//
//  LELessonLEIAudioText.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"

@protocol LECourseLessonLEIAudioText
@end

@interface LECourseLessonLEIAudioText : JSONModel
@property (nonatomic, strong) NSString* audio;
@property (nonatomic, strong) NSString* text;
@end
