//
//  LELessonSection.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "LECourseLessonSectionItem.h"

@protocol LECourseLessonSection
@end

@interface LECourseLessonSection : JSONModel

@property (nonatomic, strong) NSString<Optional>* record;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString<Optional>* audio;
@property (nonatomic, assign) int index;
@property (nonatomic, strong) NSArray<LECourseLessonSectionItem>* items;
@property (nonatomic, strong) NSString* scoID;
@property (nonatomic, assign) int studyTime;
@property (nonatomic, assign) int progress;
@property (nonatomic, assign) int recordCount;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) BOOL complete;
@property (nonatomic) BOOL hasPractice;

@end
