//
//  LELesson.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "LECourseLessonSection.h"

typedef NS_ENUM(NSInteger, LELessonStatus) {
    LELessonStatusDownloadReady = 0,
    LELessonStatusDownloadOngoing,
    LELessonStatusDownloadPaused,
    LELessonStatusDownloadError,
    LELessonStatusStudyReady,
    LELessonStatusStudyOngoing,
};

@protocol LECourseLesson
@end


@interface LECourseLesson : JSONModel

@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) int index;
@property (nonatomic, strong) NSIndexSet<Ignore>* records;
@property (nonatomic, strong) NSDictionary<Optional>* notes;
@property (nonatomic, strong) NSArray<LECourseLessonSection>* sections;
@property (nonatomic, assign) int historySection;
@property (nonatomic, strong) NSDate<Optional>*   historyDate;
@property (nonatomic, assign) int totalTime;
@property (nonatomic, assign) int score;//文件总长度
@property (nonatomic, assign) int progress;
@property (nonatomic, assign) int downloadPercentage;
@property (nonatomic, assign) LELessonStatus downloadStatus;
@property (nonatomic, assign) BOOL hasLearn;
@property (nonatomic, strong) NSNumber<Optional>* mPageCount;

@end
