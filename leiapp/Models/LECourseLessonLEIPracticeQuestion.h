//
//  LELessonLEIPracticeQuestion.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"

@protocol LECourseLessonLEIPracticeQuestion
@end

@interface LECourseLessonLEIPracticeQuestion : JSONModel

@property (nonatomic, strong) NSString* question;
@property (nonatomic, strong) NSArray<Optional>* options;
@property (nonatomic, strong) NSArray<Optional>* images;
@property (nonatomic, strong) NSArray<Optional>* audios;
@property (nonatomic, strong) NSArray<Optional>* answers;
@property (nonatomic, strong) NSArray<Optional>* selections;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int index;

- (BOOL)hasImages;
- (BOOL)hasAudios;
- (BOOL)hasOptions;
- (BOOL)hasInputs;
- (BOOL)hasNote;

@end
