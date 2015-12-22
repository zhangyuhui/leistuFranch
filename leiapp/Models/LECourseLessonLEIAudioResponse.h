//
//  LELessonLEIAudioResponse.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"

@protocol LECourseLessonLEIAudioResponse
@end

@interface LECourseLessonLEIAudioResponse : JSONModel
@property (nonatomic, strong) NSString* audio;
@property (nonatomic, strong) NSString<Optional>* model;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSString<Optional>* prototype;
@property (nonatomic, strong) NSString<Optional>* record;
@property (nonatomic, strong) NSString* playback;
@property (nonatomic, assign) int total;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) int score;
@property (nonatomic, strong) NSNumber<Optional>* type;
@end
