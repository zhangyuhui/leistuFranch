//
//  LECourseService.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/19/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseService.h"
#import "LECourse.h"
#import "LECourseLesson.h"
#import "LECourseNote.h"
#import "LECourseBookmark.h"
#import "LELessonRecord.h"
#import "QNUploadManager.h"
#import "LESycnStudyRecord.h"

@interface LECourseService : LEBaseService
+ (instancetype)sharedService;

@property (strong, nonatomic) NSArray* courses;
@property (strong, nonatomic) NSArray* records;

- (void)getStudyCourses:(void (^)(LECourseService *service, NSArray* courses))success
           failure:(void (^)(LECourseService *service, NSString* error))failure;

- (void)getStudyRecords:(void (^)(LECourseService *service, NSArray* records))success
                failure:(void (^)(LECourseService *service, NSString* error))failure;

- (void)getStudyCoursesAndRecords:(void (^)(LECourseService *service, NSArray* courses, NSArray* records))success
                failure:(void (^)(LECourseService *service, NSString* error))failure;

- (void)uploadStudyRecords:(NSArray*) records
                   success:(void (^)(LECourseService *service))success
                   failure:(void (^)(LECourseService *service, NSString* error))failure;
//单元上传学习记录
- (void)uploadSycnStudyRecords:(LESycnStudyRecord*) record
                       success:(void (^)(LECourseService *service))success
                       failure:(void (^)(LECourseService *service, NSString* error))failure;
- (void)deleteStudyNote:(LECourseNote*) note
                   success:(void (^)(LECourseService *service))success
                   failure:(void (^)(LECourseService *service, NSString* error))failure;

- (void)deleteStudyBookmark:(LECourseBookmark*) bookmark
                    success:(void (^)(LECourseService *service))success
                    failure:(void (^)(LECourseService *service, NSString* error))failure;

- (void)performRecordFileUpload:(NSArray<LEPageAudioRecord, Optional>*)records complete:(void (^)())complete ;

- (void)startDownloadCourse:(LECourse*)course;

- (void)stopDownloadCourse:(LECourse*)course;

- (void)pauseDownloadCourse:(LECourse*)course;

- (void)startDownloadLesson:(LECourseLesson*)lesson;

- (void)stopDownloadLesson:(LECourseLesson*)lesson;

- (void)pauseDownloadLesson:(LECourseLesson*)lesson;

- (void)stopAllDownloads;
//序列化学习记录数据
- (void)persistentRecords;

- (void)deleteStudyCourse:(LECourse*)course;
- (LELessonRecord*)getLessonRecord:(int)courseId lessonId:(int)lessonId;

- (void) uploadOldVersionStudyRecord;

@end
