//
//  LECourse.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/19/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "LECourseDetail.h"

typedef NS_ENUM(NSInteger, LECourseStatus) {
    LECourseStatusDownloadReady  = 0,
    LECourseStatusDownloading    = 1,
    LECourseStatusDownloadPaused = 2,
    LECourseStatusDownloadError  = 3,
    LECourseStatusExtractReady   = 4,
    LECourseStatusExtracting     = 5,
    LECourseStatusExtractPaused  = 6,
    LECourseStatusParseReady     = 7,
    LECourseStatusParsing        = 8,
    LECourseStatusParsePaused    = 9,
    LECourseStatusStudyReady     = 10,
    LECourseStatusStudying       = 11,
    LECourseStatusTestReady      = 12,
    LECourseStatusTesting        = 13,
    LECourseStatusFinished       = 14,
    LECourseStatusExprised       = 15
};

@interface LECourse : JSONModel

@property (assign, nonatomic) int identifier;
@property (strong, nonatomic) NSString* code;
@property (strong, nonatomic) NSString* introduction;
@property (assign, nonatomic) BOOL displayAnswer;
@property (strong, nonatomic) NSString* title;
@property (assign, nonatomic) double price;
@property (assign, nonatomic) double scoreLine;
@property (strong, nonatomic) NSString* link;
@property (strong, nonatomic) NSString<Optional>* cover;
@property (strong, nonatomic) NSString* limit;
@property (strong, nonatomic) NSString* author;
@property (strong, nonatomic) NSString<Optional>* copyright;
@property (nonatomic, strong) NSNumber<Optional>* mPageCount;

//Local data
@property (assign, nonatomic) LECourseStatus status;
@property (assign, nonatomic) int download;
@property (strong, nonatomic) LECourseDetail<Optional>* detail;

@end