//
//  LECourseService.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/19/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseService.h"
#import "LEConstants.h"
#import "LECourse.h"
#import "JSON.h"
#import "LECourseStudyRecord.h"
#import "LEHttpRequestOperation.h"
#import "ZipArchive.h"
#import "LECourseParser.h"
#import "LEPreferenceService.h"
#import "LEErrors.h"
#import "LEDefines.h"
#import "LEConfigurationLoader.h"
#import "LESycnStudyRecord.h"
#import "LECourseLessonLEIAudioResponseItem.h"
#import "LECourseLessonSectionItemView.h"
#import "NSString+Addition.h"
#import "FMDB.h"

#define kCourseServicePathMyCourses              @"course/mycourses"
#define kCourseServicePathGetStudyRecrods        @"studyrecord/get"
#define kCourseServicePathUploadStudyRecrods     @"studyrecord/update"
#define kCourseServicePathDeleteStudyNote        @"studyrecord/notesdelete"
#define kCourseServicePathDeleteStudyBookmark    @"studyrecord/bookmarksdelete"
#define kCourseServicePathGetStudyRecrodsTimestamp @"studyrecord/timestamp"

#define kCourseServicePathGetFileUploadToken     @"token/getToken"

#define kCourseServiceAssetsPath                 @"courseservice_assets"

#define kCourseServiceLessonDownloadPath         @"http://static.longmanenglish.cn/upload/coursePackage"

#define kCourseServiceDownloadDelay              1.0

@interface LECourseService ()
@property (strong, nonatomic) LEHttpRequestOperation* requestOperation;

- (LECourseStudyRecord*)normalizeStudyRecord:(id)response;
- (NSDictionary*)serializeStudyRecord:(LECourseStudyRecord*)record;

- (void)persistentCourses;
- (void)restoreCourses;

- (NSString*)getLessonDownloadLink:(LECourseLesson*)lesson;

//- (NSArray*)mergeStudyRecords:(NSArray*)records;
//- (NSArray<LELessonRecord>*)mergeLessonRecords:(NSArray<LELessonRecord>*)records updatedRecords:(NSArray<LELessonRecord>*)updatedRecords;
//- (NSArray<LESectionRecord>*)mergeSectionRecords:(NSArray<LESectionRecord>*)baseRecords updatedRecords:(NSArray<LESectionRecord>*)updatedRecords;
//- (NSArray<LEPageRecord>*)mergePageRecords:(NSArray<LEPageRecord>*)baseRecords updatedRecords:(NSArray<LEPageRecord>*)updatedRecords;
//- (NSArray<LECourseNote>*)mergeLessonNotes:(NSArray<LECourseNote>*)notes updatedNotes:(NSArray<LECourseNote>*)updatedNotes;
//- (NSArray<LECourseBookmark>*)mergeLessonBookmarks:(NSArray<LECourseBookmark>*)bookmarks updatedBookmarks:(NSArray<LECourseBookmark>*)updatedBookmarks;
//
- (void)performCourseFileUpload:(NSArray*)courses
                        success:(void (^)(LECourse* course))success
                        failure:(void (^)(NSString* error))failure;
//- (void)cleanupStudyRecords:(NSArray*)records;
//- (void)cleanupLessonRecords:(NSArray<LELessonRecord>*)records;
//- (void)cleanupSectionRecords:(NSArray<LESectionRecord>*)records;
//- (void)cleanupPageRecords:(NSArray<LEPageRecord>*)records;
//- (void)cleanupLessonNotes:(NSArray<LECourseNote>*)notes;
//- (void)cleanupLessonBookmarks:(NSArray<LECourseBookmark>*)bookmarks;


- (void)handleGetCoursesFailure:(NSString*)error failure:(void (^)(LECourseService *service, NSString* error)) failure;
- (void)handleGetCoursesSuccess:(NSArray*)courses success:(void (^)(LECourseService *service, NSArray* courses))success;

- (void)handleGetStudyRecordsFailure:(NSString*)error failure:(void (^)(LECourseService *service, NSString* error)) failure;
- (void)handleGetStudyRecordsSuccess:(NSArray*)records success:(void (^)(LECourseService *service, NSArray* records))success;

- (void)handleUploadStudyRecordsFailure:(NSString*)error failure:(void (^)(LECourseService *service, NSString* error)) failure;
- (void)handleUploadStudyRecordsSuccess:(void (^)(LECourseService *service))success;

- (void)handleGetStudyCourseRecordsFailure:(NSString*)error failure:(void (^)(LECourseService *service, NSString* error)) failure;
- (void)handleGetStudyCourseRecordsSuccess:(NSArray*)courses records:(NSArray*)records success:(void (^)(LECourseService *service, NSArray* courses, NSArray* records))success;

- (void)handleDeleteStudyNoteFailure:(NSString*)error failure:(void (^)(LECourseService *service, NSString* error)) failure;
- (void)handleDeleteStudyNoteSuccess:(void (^)(LECourseService *service))success;

- (void)handleDeleteStudyBookmarkFailure:(NSString*)error failure:(void (^)(LECourseService *service, NSString* error)) failure;
- (void)handleDeleteStudyBookmarkSuccess:(void (^)(LECourseService *service))success;

@end


@implementation LECourseService

+ (instancetype)sharedService {
    static LECourseService *sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[super allocWithZone:NULL] init];
        sharedService.requestOperation = [[LEHttpRequestOperation alloc] init];
        [sharedService restore];
    });
    return sharedService;
}

+ (instancetype)allocWithZone:(NSZone *)zone{
    NSString *reason = [NSString stringWithFormat:@"Attempt to allocate a second instance of the singleton %@", [self class]];
    NSException *exception = [NSException exceptionWithName:@"Multiple singletons" reason:reason userInfo:nil];
    [exception raise];
    return nil;
}

- (void)handleGetCoursesFailure:(NSString*)error failure:(void (^)(LECourseService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleGetCoursesSuccess:(NSArray*)courses success:(void (^)(LECourseService *service, NSArray* courses))success {
    success(self, courses);
}

- (void)handleGetStudyRecordsFailure:(NSString*)error failure:(void (^)(LECourseService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleGetStudyRecordsSuccess:(NSArray*)records success:(void (^)(LECourseService *service, NSArray* records))success {
    success(self, records);
}

- (void)handleGetStudyCourseRecordsFailure:(NSString*)error failure:(void (^)(LECourseService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleGetStudyCourseRecordsSuccess:(NSArray*)courses records:(NSArray*)records success:(void (^)(LECourseService *service, NSArray* courses, NSArray* records))success {
    success(self, courses, records);
}

- (void)handleUploadStudyRecordsFailure:(NSString*)error failure:(void (^)(LECourseService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleUploadStudyRecordsSuccess:(void (^)(LECourseService *service))success {
    success(self);
}

- (void)handleDeleteStudyNoteFailure:(NSString*)error failure:(void (^)(LECourseService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleDeleteStudyNoteSuccess:(void (^)(LECourseService *service))success {
    success(self);
}

- (void)handleDeleteStudyBookmarkFailure:(NSString*)error failure:(void (^)(LECourseService *service, NSString* error)) failure {
    failure(self, error);
}

- (void)handleDeleteStudyBookmarkSuccess:(void (^)(LECourseService *service))success {
    success(self);
}
- (NSDictionary*)preprocessRecordsResponse:(NSDictionary*)response {
    NSMutableDictionary* processedResponse = [NSMutableDictionary dictionaryWithDictionary:response];
    NSArray* lessons = [processedResponse objectForKey:@"lessons"];
    if (lessons && [lessons count] > 0) {
        NSMutableArray* processedLessons = [NSMutableArray array];
        [lessons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
            NSMutableDictionary* processedLesson = [NSMutableDictionary dictionaryWithDictionary:obj];
            NSArray* sections = [processedLesson objectForKey:@"sections"];
            if (sections && [sections count] > 0) {
                NSMutableArray* processedSections = [NSMutableArray array];
                NSMutableDictionary* processedSection = [NSMutableDictionary dictionaryWithDictionary:[sections firstObject]];
                NSArray* pages = [processedSection objectForKey:@"pages"];
                if (pages && [pages count] > 0) {
                    NSMutableArray* processedPages = [NSMutableArray array];
                    [pages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
                        NSMutableDictionary* processedPage = [NSMutableDictionary dictionaryWithDictionary:obj];
                        NSString* record = [processedPage objectForKey:@"record"];
                        
                        if (record) {
                            record = [(NSString *)record stringByReplacingOccurrencesOfString:@"+" withString:@""];
                            record = [record stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                            NSData* data = [record dataUsingEncoding:NSUTF8StringEncoding];
                            NSError* error;
//                            NSData* data = [[record stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
                            NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:NSJSONReadingMutableContainers
                                                                               error:&error];
                            [processedPage setValue:array forKey:@"record"];
                        }
                        [processedPages addObject:processedPage];
                    }];
                    [processedSection setValue:processedPages forKey:@"pages"];
                }
                [processedSections addObject:processedSection];
                [processedLesson setObject:processedSections forKey:@"sections"];
            }
            [processedLessons addObject:processedLesson];
        }];
        [processedResponse setObject:processedLessons forKey:@"lessons"];
    }
    return processedResponse;
}

- (LECourseStudyRecord*)normalizeStudyRecord:(id)response {
    NSError* error = nil;
    LECourseStudyRecord* record = [[LECourseStudyRecord alloc] initWithDictionary:[self preprocessRecordsResponse:response] error:&error];
    
//    [record.lessons enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
//        LELessonRecord* lesson = object;
//        [lesson.sections enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
//            LESectionRecord* section = object;
//            [section.pages enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
//                LEPageRecord* page = object;
//                if (page.record) {
//                    NSString* record = [[page.record stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                    NSArray* recordArray = [NSJSONSerialization JSONObjectWithData:[record dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
//                    NSMutableArray* practises = [NSMutableArray arrayWithCapacity:[recordArray count]];
//                    [recordArray enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
//                        LEPageAudioPractice* practise = [[LEPageAudioPractice alloc] initWithDictionary:object error:nil];
//                        [practises addObject:practise];
//                    }];
//                    page.practices = practises;
//                }
    
//            }];
//        }];
//    }];
    return record;
}

- (NSDictionary*)serializeStudyRecord:(LECourseStudyRecord*)record {
    //TODO
    //Need generate record here
    return [record toDictionary];
}

- (void)getStudyCourses:(void (^)(LECourseService *service, NSArray* courses))success
                failure:(void (^)(LECourseService *service, NSString* error))failure {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    NSString* path = [NSString stringWithFormat:@"%@/%@", kCourseServicePathMyCourses, userId];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    [self.requestOperation requestByGet:path parameters:@{@"role": @9, @"version": version} options:nil success:^(LEHttpRequestOperation *operation, id response) {
        if (![response isEqual:[NSArray class]]) {
            [self handleGetCoursesFailure:nil failure:failure];
        }
        NSMutableArray* courses = [NSMutableArray arrayWithCapacity:[(NSArray*)response count]];
        [response enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            NSError* error = nil;
            LECourse* course = [[LECourse alloc] initWithDictionary:object error:&error];
            if (self.courses != nil) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %d", course.identifier];
                NSArray *filtered = [self.courses filteredArrayUsingPredicate:predicate];
                if ([filtered count] > 0) {
                    LECourse* existingCourse = [filtered objectAtIndex:0];
                    course.status = existingCourse.status;
                    course.download = existingCourse.download;
                    course.detail = existingCourse.detail;
                    course.mPageCount = existingCourse.mPageCount;
                } else {
                    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
                    [formater setDateFormat:@"yyyy-MM-dd"];
                    NSDate *date = [formater dateFromString:course.limit];
                    if([[NSDate date] compare:[formater dateFromString:course.limit]]==NSOrderedDescending){
                        course.status = LECourseStatusExprised;
                    }else
                        course.status = LECourseStatusDownloadReady;
                    course.download = 0;
                }
            }
            [courses addObject:course];
        }];
        self.courses = courses;
        [self persistentCourses];
        [self handleGetCoursesSuccess:courses success:success];
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleGetCoursesFailure:nil failure:failure];
        } else {
            [self handleGetCoursesFailure:[error localizedDescription] failure:failure];
        }
    }];
    
}

- (void)getStudyRecords:(void (^)(LECourseService *service, NSArray* records))success
                failure:(void (^)(LECourseService *service, NSString* error))failure {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    [self.requestOperation requestByGet:kCourseServicePathGetStudyRecrods parameters:@{@"userID": userId} options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSMutableArray* records = [NSMutableArray arrayWithCapacity:[(NSArray*)response count]];
        [response enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            LECourseStudyRecord* record = [self normalizeStudyRecord:object];
            [records addObject:record];
        }];
        //从服务端获取到到学习记录，与未同步的进行累加。做为呈现给用户到学习记录
        self.records = records;
        [self persistentRecords];
        [self handleGetStudyRecordsSuccess:records success:success];
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleGetStudyRecordsFailure:nil failure:failure];
        } else {
            [self handleGetStudyRecordsFailure:[error localizedDescription] failure:failure];
        }
    }];
}

- (void)getStudyCoursesAndRecords:(void (^)(LECourseService *service, NSArray* courses, NSArray* records))success failure:(void (^)(LECourseService *service, NSString* error))failure {
    NSString* _userID = setUserID(nil);
    [self uploadOldVersionStudyRecord];
    //先取课程显示给用户
    [self getStudyCourses:^(LECourseService *service, NSArray *courses) {
        [self handleGetStudyCourseRecordsSuccess:courses records:nil success:success];
        //取学习记录时间戳
        [self.requestOperation requestByGet:kCourseServicePathGetStudyRecrodsTimestamp parameters:@{@"userID": _userID} options:nil success:^(LEHttpRequestOperation *operation, id response) {
            NSString* date  =  UserNameDefault(nil, @"syncTimesTamp", [NSString stringWithFormat:@"syncTimesTamp%@",_userID]);
            date = [NSString stringWithFormat:@"%@", date];
            NSString* syncTimesTamp = [response objectForKey:@"timestamp"];
            syncTimesTamp = [NSString stringWithFormat:@"%@", syncTimesTamp];
            BOOL isEq = [syncTimesTamp isEqualToString:date];
            //比较学习记录时间戳，不相等将服务端时间戳保存本地，然后从服务端获取学习记录
            if (!isEq) {
                UserNameDefault(syncTimesTamp, @"syncTimesTamp", [NSString stringWithFormat:@"syncTimesTamp%@",_userID]);
                [self getStudyRecords:^(LECourseService *service, NSArray *records) {
                    [self handleGetStudyCourseRecordsSuccess:courses records:records success:success];
                } failure:^(LECourseService *service, NSString *error) {
                    
                }];
            }
        } failure:^(LEHttpRequestOperation *operation, NSError *error) {
            
        }];
    } failure:^(LECourseService *service, NSString *error) {
        [self handleGetStudyCourseRecordsFailure:error failure:failure];
    }];
    

//    [self getStudyRecords:^(LECourseService *service, NSArray *records) {
//        [self getStudyCourses:^(LECourseService *service, NSArray *courses) {
//            [self handleGetStudyCourseRecordsSuccess:courses records:records success:success];
//        } failure:^(LECourseService *service, NSString *error) {
//            [self handleGetStudyCourseRecordsFailure:error failure:failure];
//        }];
//    } failure:^(LECourseService *service, NSString *error) {
//        [self handleGetStudyCourseRecordsFailure:error failure:failure];
//    }];
}
-(NSArray*)getAllCourses{
    NSArray *arr = [LESycnStudyRecord findAll];
    NSMutableDictionary * courseids = [NSMutableDictionary dictionary];
    for (LESycnStudyRecord *record in arr) {
        [courseids setObject:[NSNumber numberWithInt:record.courseID] forKey:[NSNumber numberWithInt:record.courseID]];
    }
    NSArray * courseIDArray = [courseids allKeys];
    NSMutableArray *courses = [NSMutableArray arrayWithCapacity:[courseIDArray count]];
    if ([courseIDArray count]==0) {
        return nil;
    }
    for (NSNumber *courseID in courseIDArray) {
        //第一层遍历所有lesson 和courseID 添加到 courses
        NSMutableDictionary *coursedic = [NSMutableDictionary dictionary];
        [coursedic setObject:courseID forKey:@"courseID"];
        NSArray * dblessons = [LESycnStudyRecord findByCourseID:courseID.intValue];
        NSMutableDictionary * lessonIDDic = [NSMutableDictionary dictionary];
        for (LESycnStudyRecord *record in dblessons) {
            [lessonIDDic setObject:[NSNumber numberWithInt:record.lessonID] forKey:[NSNumber numberWithInt:record.lessonID]];
        }
        NSArray *lessonsIDArray = [lessonIDDic allKeys];
        NSMutableArray *lessons = [NSMutableArray arrayWithCapacity:[lessonsIDArray count]];
        for (NSNumber * lessonID in lessonsIDArray) {
            //第二层 遍历所有section 和 lessonID添加到 lessons
            NSMutableDictionary *lessondic = [NSMutableDictionary dictionary];
            [lessondic setObject:lessonID forKey:@"lessonID"];
            NSArray * dbsections = [LESycnStudyRecord findByCourseID:courseID.intValue LessonID:lessonID.intValue];
            NSMutableDictionary * sectionIDDic = [NSMutableDictionary dictionary];
            for (LESycnStudyRecord *record in dbsections) {
                [sectionIDDic setObject:[NSNumber numberWithInt:record.sectionID] forKey:[NSNumber numberWithInt:record.sectionID]];
            }
            NSArray *sectionsIDArray = [sectionIDDic allKeys];
            NSMutableArray *sections = [NSMutableArray arrayWithCapacity:[sectionsIDArray count]];
            for (NSNumber *sectionID in sectionsIDArray) {
                //第三层 遍历所有page 和 sectionID添加到 sections
                NSMutableDictionary *sectiondic = [NSMutableDictionary dictionary];
                [sectiondic setObject:sectionID forKey:@"sectionID"];
                NSArray * dbpages = [LESycnStudyRecord findByCourseID:courseID.intValue LessonID:lessonID.intValue SectionID:sectionID.intValue];
                NSMutableDictionary * pageIDDic = [NSMutableDictionary dictionary];
                for (LESycnStudyRecord *record in dbpages) {
                    [pageIDDic setObject:[NSNumber numberWithInt:record.pageID] forKey:[NSNumber numberWithInt:record.pageID]];
                }
                NSArray *pagesIDArray = [pageIDDic allKeys];
                NSMutableArray *pages = [NSMutableArray arrayWithCapacity:[pagesIDArray count]];
                for (NSNumber * pageID in pagesIDArray) {
                    //第四层 获取page所有属性 添加到 page 遍历结束把page添加到pages
                    NSMutableDictionary *pagedic = [NSMutableDictionary dictionary];
                    NSArray * dbpages = [LESycnStudyRecord findByCourseID:courseID.intValue LessonID:lessonID.intValue SectionID:sectionID.intValue PageID:pageID.intValue];
                    if ([dbpages count]==0) {
                        break;
                    }
                    LESycnStudyRecord *record = [[LESycnStudyRecord alloc] init];//[dbpages objectAtIndex:0];
                    [dbpages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        LESycnStudyRecord* rec = obj;
                        if (record.id < rec.id) {
                            record.id = rec.id;
                            record.score = rec.score;
                            record.complete = rec.complete;
                            record.records = rec.records;
                        }
                        record.studytime += rec.studytime;
                    }];
                    [pagedic setObject:pageID forKey:@"pageID"];
                    [pagedic setObject:[NSNumber numberWithInt:record.studytime] forKey:@"studyTime"];
                    [pagedic setObject:[NSNumber numberWithInt:record.complete] forKey:@"complete"];
                    [pagedic setObject:[NSNumber numberWithInt:record.score] forKey:@"score"];
                    if (record.records.length>10) {
                        [pagedic setObject:record.records forKey:@"record"];
                    }
                    [pages addObject:pagedic];
                }
                [sectiondic setValue:pages forKey:@"pages"];
                [sections addObject:sectiondic];
            }
            [lessondic setValue:sections forKey:@"sections"];
            [lessons addObject:lessondic];
        }
        [coursedic setValue:lessons forKey:@"lessons"];
        [courses addObject:coursedic];
    }
    
    return courses;
}
/*
 *逻辑:获取时间后比较
 *      if(case){
 *       上传
 *}else if(case){
 *       下载
 *}else{
 *
 *}
 */
- (void)uploadStudyRecords:(NSArray*) records
                   success:(void (^)(LECourseService *service))success
                   failure:(void (^)(LECourseService *service, NSString* error))failure {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    [self.requestOperation requestByGet:kCourseServicePathGetStudyRecrodsTimestamp parameters:@{@"userID": userId} options:nil success:^(LEHttpRequestOperation *operation, id response) {
        NSDate* date  =  UserNameDefault(nil, @"syncTimesTamp", [NSString stringWithFormat:@"syncTimesTamp%@",userId]);
        NSDate *syncTimesTamp = [response objectForKey:@"timestamp"];
        if (date) {
            //获取待同步学习记录
            NSArray *arr = [LESycnStudyRecord findAll];
            
            if (!(int)syncTimesTamp > (int)date)
            {
                //增加同步执行接口，获取到学习记录与待同步合并
                [self getStudyRecords:^(LECourseService *service, NSArray *records) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(nil);
                    });

                    UserNameDefault(syncTimesTamp, @"syncTimesTamp", [NSString stringWithFormat:@"syncTimesTamp%@",userId]);
                    self.records = records;
                    if(self.records){
                        
                        //增加同步执行接口，获取到学习记录与待同步合并
//                        [self.records enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                            LECourseStudyRecord* record = obj;
//                            
//                        }];
                    }
                } failure:^(LECourseService *service, NSString *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(nil,error.description);
                    });
//                    failure(nil,error.description);
//                    [self handleUploadStudyRecordsFailure:nil failure:failure];
                }];
            }

//            NSArray* courses = [LESycnStudyRecord getAllCourses];
            NSMutableDictionary * courseids = [NSMutableDictionary dictionary];
            if (arr) {
                for (LESycnStudyRecord *record in arr) {
                    record.record = nil;
                    //同步生产json前先上传录音文件，更新远程文件路径
                    //将录音记录字符串转成对象，上传
                    if (record.records) {
                        SBJsonParser* parser = [[SBJsonParser alloc] init];
                        NSArray* array = [parser objectWithString:record.records];
                        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            NSDictionary* dic = obj;
                            LEPageAudioRecord* ar = [[LEPageAudioRecord alloc] initWithDictionary:dic error:nil];
                            if (!record.record) {
                                record.record = [[NSMutableArray<LEPageAudioRecord, Optional> alloc] init];
                            }
                            NSMutableArray<LEPageAudioRecord, Optional>* arra = [NSMutableArray<LEPageAudioRecord, Optional> arrayWithArray:record.record];
                            [arra addObject:ar];
                            record.record = arra;
                        }];
                        //上传录音文件
                        [self performRecordFileUpload:record.record complete:^{
                        }];
                    }
                    [courseids setObject:[NSNumber numberWithInt:record.courseID] forKey:[NSNumber numberWithInt:record.courseID]];
                }
            }
            
            NSArray * courseIDArray = [courseids allKeys];
            NSMutableArray *courses = [NSMutableArray arrayWithCapacity:[courseIDArray count]];
            if ([courseIDArray count]==0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SHOWHUD(@"已自动同步学习记录");
                    success(nil);
                });
//                SHOWHUD(@"已自动同步学习记录");
//                success(nil);
                return ;
            }
            for (NSNumber *courseID in courseIDArray) {
                //第一层遍历所有lesson 和courseID 添加到 courses
                NSMutableDictionary *coursedic = [NSMutableDictionary dictionary];
                [coursedic setObject:courseID forKey:@"courseID"];
                NSArray * dblessons = [LESycnStudyRecord findByCourseID:courseID.intValue];
                NSMutableDictionary * lessonIDDic = [NSMutableDictionary dictionary];
                for (LESycnStudyRecord *record in dblessons) {
                    [lessonIDDic setObject:[NSNumber numberWithInt:record.lessonID] forKey:[NSNumber numberWithInt:record.lessonID]];
                }
                NSArray *lessonsIDArray = [lessonIDDic allKeys];
                NSMutableArray *lessons = [NSMutableArray arrayWithCapacity:[lessonsIDArray count]];
                for (NSNumber * lessonID in lessonsIDArray) {
                    //第二层 遍历所有section 和 lessonID添加到 lessons
                    NSMutableDictionary *lessondic = [NSMutableDictionary dictionary];
                    [lessondic setObject:lessonID forKey:@"lessonID"];
                    NSArray * dbsections = [LESycnStudyRecord findByCourseID:courseID.intValue LessonID:lessonID.intValue];
                    NSMutableDictionary * sectionIDDic = [NSMutableDictionary dictionary];
                    for (LESycnStudyRecord *record in dbsections) {
                        [sectionIDDic setObject:[NSNumber numberWithInt:record.sectionID] forKey:[NSNumber numberWithInt:record.sectionID]];
                    }
                    NSArray *sectionsIDArray = [sectionIDDic allKeys];
                    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:[sectionsIDArray count]];
                    for (NSNumber *sectionID in sectionsIDArray) {
                        //第三层 遍历所有page 和 sectionID添加到 sections
                        NSMutableDictionary *sectiondic = [NSMutableDictionary dictionary];
                        [sectiondic setObject:sectionID forKey:@"sectionID"];
                        NSArray * dbpages = [LESycnStudyRecord findByCourseID:courseID.intValue LessonID:lessonID.intValue SectionID:sectionID.intValue];
                        NSMutableDictionary * pageIDDic = [NSMutableDictionary dictionary];
                        for (LESycnStudyRecord *record in dbpages) {
                            [pageIDDic setObject:[NSNumber numberWithInt:record.pageID] forKey:[NSNumber numberWithInt:record.pageID]];
                        }
                        NSArray *pagesIDArray = [pageIDDic allKeys];
                        NSMutableArray *pages = [NSMutableArray arrayWithCapacity:[pagesIDArray count]];
                        for (NSNumber * pageID in pagesIDArray) {
                            //第四层 获取page所有属性 添加到 page 遍历结束把page添加到pages
                            NSMutableDictionary *pagedic = [NSMutableDictionary dictionary];
                            NSArray * dbpages = [LESycnStudyRecord findByCourseID:courseID.intValue LessonID:lessonID.intValue SectionID:sectionID.intValue PageID:pageID.intValue];
                            if ([dbpages count]==0) {
                                break;
                            }
                            LESycnStudyRecord *record = [[LESycnStudyRecord alloc] init];//[dbpages objectAtIndex:0];
                            [dbpages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                LESycnStudyRecord* rec = obj;
                                if (record.id < rec.id) {
                                    record.id = rec.id;
                                    record.score = rec.score;
                                    record.complete = rec.complete;
                                    record.records = rec.records;
                                }
                                record.studytime += rec.studytime;
                            }];
                            [pagedic setObject:pageID forKey:@"pageID"];
                            [pagedic setObject:[NSNumber numberWithInt:record.studytime] forKey:@"studyTime"];
                            [pagedic setObject:[NSNumber numberWithInt:record.complete] forKey:@"complete"];
                            [pagedic setObject:[NSNumber numberWithInt:record.score] forKey:@"score"];
                            if (record.records.length>10) {
                                [pagedic setObject:record.records forKey:@"record"];
                            }
                            [pages addObject:pagedic];
                        }
                        [sectiondic setValue:pages forKey:@"pages"];
                        [sections addObject:sectiondic];
                    }
                    [lessondic setValue:sections forKey:@"sections"];
                    [lessons addObject:lessondic];
                }
                [coursedic setValue:lessons forKey:@"lessons"];
                [courses addObject:coursedic];
            }

            if ([courses count]>0) {
                NSDictionary* body = @{@"version": @2, @"userID": userId, @"courses": courses};
                SBJsonWriter *jsonWriter = [SBJsonWriter new];
                NSString *jsonBodyDictionaryString = [jsonWriter stringWithObject:body];
                NSString* _postData = [NSString stringWithFormat:@"userID=%@&postBody=%@", userId,jsonBodyDictionaryString];
                
                BOOL syncInNoneWifi = [LEPreferenceService sharedService].syncInNoneWifi;
                NSDictionary* httpHeaders = @{@"Content-Type": @"application/x-www-form-urlencoded;charset=UTF-8"};
                NSDictionary* options = @{@"allowNoneWifi": [NSNumber numberWithBool:syncInNoneWifi], @"httpHeaders": httpHeaders};
                LEConfigurationLoader* configuration = [[LEConfigurationLoader alloc] init];
                NSString* host = [configuration stringForKey:kLEConfigurationHost];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",host,kCourseServicePathUploadStudyRecrods]];
                NSLog(@"%@", jsonBodyDictionaryString);
                NSData *postData = [_postData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                [self.requestOperation requestByUploadRecord:postData Url:url Options:options success:^(LEHttpRequestOperation *operation, id response) {
//                    [self handleUploadStudyRecordsSuccess:success];
//                    [LESycnStudyRecord clearTable];
                    [LESycnStudyRecord deleteObjects:arr];
//                    success(nil);
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        SHOWHUD(@"已自动同步学习记录");
                        success(nil);
                    });
                } failure:^(LEHttpRequestOperation *operation, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
                            failure(nil,error.description);
                            //                        [self handleUploadStudyRecordsFailure:nil failure:failure];
                        } else {
                            failure(nil,error.description);
                            //                        [self handleUploadStudyRecordsFailure:[error localizedDescription] failure:failure];
                        }
                    });
//                    if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
//                        failure(nil,error.description);
////                        [self handleUploadStudyRecordsFailure:nil failure:failure];
//                    } else {
//                        failure(nil,error.description);
////                        [self handleUploadStudyRecordsFailure:[error localizedDescription] failure:failure];
//                    }
                }];
                //上传

            }else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SHOWHUD(@"已自动同步学习记录");
                    success(nil);
                });
//                SHOWHUD(@"已自动同步学习记录");
//                success(nil);
            }
        }else
        {
            [self getStudyCoursesAndRecords:^(LECourseService *service, NSArray *courses, NSArray *records) {
                success(nil);
                [self handleUploadStudyRecordsSuccess:success];
                UserNameDefault(syncTimesTamp, @"syncTimesTamp", [NSString stringWithFormat:@"syncTimesTamp%@",userId]);
            } failure:^(LECourseService *service, NSString *error) {
                failure(nil,error.description);
//                [self handleUploadStudyRecordsFailure:nil failure:failure];
            }];
        }
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        failure(nil,error.description);
//        SHOWHUD(@"获取时间戳失败");
    }];
}
//单页同步及整课同步及所有课同步
- (void)uploadSycnStudyRecords:(LESycnStudyRecord*) record
                   success:(void (^)(LECourseService *service))success
                   failure:(void (^)(LECourseService *service, NSString* error))failure {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    dispatch_queue_t queue_sycn = dispatch_queue_create("com.sycnrecordupload.serial",DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue_sycn, ^{
        if (!record) {
            return ;
        }

        if (record.record) {
            //上传录音文件，并更新上传后得到到远程文件录音
            //上传时注意文件名是否一样，一样的话说明是已经上传过的，不需重复上传
            //方法中都是同步执行
            [self performRecordFileUpload:record.record complete:^{
            }];
            if ([record.record count]>0) {
                SBJsonWriter *jsonWriter = [SBJsonWriter new];
                NSMutableArray *array = [NSMutableArray array];
                for (LEPageAudioRecord * audioRecord in record.record) {
                    [array addObject:[audioRecord toDictionary]];
                }
                record.records = [jsonWriter stringWithObject:array];
            }
        }

//        records转json失败，增加NSArray<LEPageAudioRecord, Optional>导致
//        LESycnStudyRecord* pageRecord = [records objectAtIndex:0];
        NSDictionary* body = @{@"version": @2, @"userID": userId, @"courses": [record recordToArray]};
        SBJsonWriter *jsonWriter = [SBJsonWriter new];
        NSString *jsonBodyDictionaryString = [jsonWriter stringWithObject:body];
    
//        NSString* jsonBodyDictionaryString =  [jsonWriter stringWithObject:postDic];
    

        NSString* _postData = [NSString stringWithFormat:@"userID=%@&postBody=%@", userId,jsonBodyDictionaryString];
        BOOL syncInNoneWifi = [LEPreferenceService sharedService].syncInNoneWifi;
        NSDictionary* httpHeaders = @{@"Content-Type": @"application/x-www-form-urlencoded;charset=UTF-8"};
        NSDictionary* options = @{@"allowNoneWifi": [NSNumber numberWithBool:syncInNoneWifi], @"httpHeaders": httpHeaders};
        LEConfigurationLoader* configuration = [[LEConfigurationLoader alloc] init];
        NSString* host = [configuration stringForKey:kLEConfigurationHost];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",host,kCourseServicePathUploadStudyRecrods]];
        NSData * postData = [_postData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        [self.requestOperation requestByUploadRecord:postData Url:url Options:options success:^(LEHttpRequestOperation *operation, id response) {
            [record deleteObject];
            [self handleUploadStudyRecordsSuccess:success];
        } failure:^(LEHttpRequestOperation *operation, NSError *error) {
            if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
                [self handleUploadStudyRecordsFailure:nil failure:failure];
            } else {
                [self handleUploadStudyRecordsFailure:[error localizedDescription] failure:failure];
            }
        }];
    });
}
- (void)deleteStudyNote:(LECourseNote*) note
                success:(void (^)(LECourseService *service))success
                failure:(void (^)(LECourseService *service, NSString* error))failure {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:[note toDictionary]];
    [parameters setObject:userId forKey:@"userID"];
    [parameters removeObjectsForKeys:@[@"text", @"date"]];
    
    [self.requestOperation requestByPost:kCourseServicePathDeleteStudyNote parameters:parameters options:nil success:^(LEHttpRequestOperation *operation, id response) {
        [self handleDeleteStudyNoteSuccess:success];
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleDeleteStudyNoteFailure:nil failure:failure];
        } else {
            [self handleDeleteStudyNoteFailure:[error localizedDescription] failure:failure];
        }
    }];
    
}

- (void)deleteStudyBookmark:(LECourseBookmark*) bookmark
                    success:(void (^)(LECourseService *service))success
                    failure:(void (^)(LECourseService *service, NSString* error))failure {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:[bookmark toDictionary]];
    [parameters setObject:userId forKey:@"userID"];
    [parameters removeObjectsForKeys:@[@"date"]];
    
    [self.requestOperation requestByPost:kCourseServicePathDeleteStudyBookmark parameters:parameters options:nil success:^(LEHttpRequestOperation *operation, id response) {
        [self handleDeleteStudyBookmarkSuccess:success];
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
        if ([[error domain] isEqualToString:LEAppErrorDomain] && [error code] == LENetworkStatusError) {
            [self handleDeleteStudyBookmarkFailure:nil failure:failure];
        } else {
            [self handleDeleteStudyBookmarkFailure:[error localizedDescription] failure:failure];
        }
    }];
}

- (void)startDownloadCourse:(LECourse*)course {
    if (course.status == LECourseStatusDownloading) {
        return;
    }
    if (course.status != LECourseStatusDownloadPaused) {
        course.download = 0;
    }
    course.status = LECourseStatusDownloading;
    [self persistentCourses];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kCourseServiceDownloadDelay * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *folder = [[paths objectAtIndex:0] stringByAppendingPathComponent:kCourseServiceAssetsPath];
        NSString *file = [folder stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.zip", course.identifier]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
            NSError* error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:NO attributes:nil error:&error];
        }
        
        BOOL syncInNoneWifi = [LEPreferenceService sharedService].downloadInNoneWifi;
        NSDictionary* options = @{@"allowNoneWifi": [NSNumber numberWithBool:syncInNoneWifi]};
        
        [self.requestOperation requestByFile:course.link file:file options:options progress:^(LEHttpRequestOperation *operation, long long read, long long total) {
            int download = read*100.0/total;
            if (download != course.download) {
                course.download = download;
                //[self persistentCourses];
            }
        } success:^(LEHttpRequestOperation *operation, NSString* file) {
            
            course.download = 100;
            [self persistentCourses];
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kCourseServiceDownloadDelay * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    course.status = LECourseStatusExtracting;
                    [self persistentCourses];
                });
                
                dispatch_queue_t backgroundQueue = dispatch_queue_create("com.leiapp", 0);
                dispatch_async(backgroundQueue, ^{
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *folder = [[paths objectAtIndex:0] stringByAppendingPathComponent:kCourseServiceAssetsPath];
                    NSString *fromFile = file;
                    NSString *toFile = [folder stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", course.identifier]];
                    
                    if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
                        NSError* error = nil;
                        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:NO attributes:nil error:&error];
                    }
                    
                    ZipArchive *zipArchive = [[ZipArchive alloc] init];
                    [zipArchive UnzipOpenFile:fromFile Password:@"ulearning"];
                    BOOL unzip = [zipArchive UnzipFileTo:toFile overWrite:YES];
                    [zipArchive UnzipCloseFile];
                    
                    NSError* error = nil;
                    [[NSFileManager defaultManager] removeItemAtPath:fromFile error:&error];
                    
                    if (!unzip) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            course.status = LECourseStatusExtractPaused;
                            [self persistentCourses];
                        });
                        [[NSFileManager defaultManager] removeItemAtPath:toFile error:nil];
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kCourseServiceDownloadDelay * NSEC_PER_SEC);
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            course.status = LECourseStatusDownloadReady;
                            [self persistentCourses];
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            course.status = LECourseStatusParsing;
                            [self persistentCourses];
                        });
                        
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kCourseServiceDownloadDelay * NSEC_PER_SEC);
                        dispatch_after(popTime, backgroundQueue, ^(void){
                            LECourseParser* parser = [[LECourseParser alloc] init];
                            LECourseDetail* courseDetail = nil;
                            NSString* parseError = nil;
                            [parser parseCourseDetail:course rootPath:toFile detail:&courseDetail error:&parseError];
                            if (parseError) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    course.detail = courseDetail;
                                    course.status = LECourseStatusParsePaused;
                                    [self persistentCourses];
                                });
                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kCourseServiceDownloadDelay * NSEC_PER_SEC);
                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                    course.status = LECourseStatusDownloadReady;
                                    [self persistentCourses];
                                });
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    course.detail = courseDetail;
                                    course.status = LECourseStatusStudyReady;
                                    [self persistentCourses];
                                });
                            }
                            
                            [[NSFileManager defaultManager] removeItemAtPath:toFile error:nil];
                            parser = nil;
                        });
                    }
                });
            });
        } failure:^(LEHttpRequestOperation *operation, NSError *error) {
            BOOL isDownloadPaused = (error.code == NSURLErrorCancelled && error.domain == NSURLErrorDomain);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isDownloadPaused) {
                    course.status = LECourseStatusDownloadPaused;
                } else {
                    course.status = LECourseStatusDownloadError;
                }
                [self persistentCourses];
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kCourseServiceDownloadDelay * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    course.status = LECourseStatusDownloadReady;
                    [self persistentCourses];
                });
            });
        }];
    });
}

- (void)stopDownloadCourse:(LECourse*)course {
    if (course.status == LECourseStatusDownloadPaused) {
        return;
    }
    [self.requestOperation cancelRequestByFile:course.link];
}

- (void)pauseDownloadCourse:(LECourse*)course {
    if (course.status == LECourseStatusDownloadPaused) {
        return;
    }
    [self.requestOperation pauseRequestByFile:course.link];
    
    course.status = LECourseStatusDownloadPaused;
    [self persistentCourses];
}

- (void)startDownloadLesson:(LECourseLesson*)lesson {
    if (lesson.downloadStatus == LELessonStatusDownloadOngoing ||
        lesson.downloadStatus >= LELessonStatusStudyReady ) {
        return;
    }
//    lesson.downloadPercentage = 0.0;
    lesson.downloadStatus = LELessonStatusDownloadOngoing;
    [self persistentCourses];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kCourseServiceDownloadDelay * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[[paths objectAtIndex:0] stringByAppendingPathComponent:kCourseServiceAssetsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", lesson.identifier]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSError* error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
        }
        
        NSString *file = [NSString stringWithFormat:@"%@/lesson-%02d.zip", path, lesson.index + 1];
        NSString *link = [self getLessonDownloadLink:lesson];
        
        BOOL syncInNoneWifi = [LEPreferenceService sharedService].downloadInNoneWifi;
        NSDictionary* options = @{@"allowNoneWifi": [NSNumber numberWithBool:syncInNoneWifi]};
        
        [self.requestOperation requestByFile:link file:file options:options progress:^(LEHttpRequestOperation *operation, long long read, long long total) {
            if (lesson.score == 0) {
                lesson.score = (int)total;
            }
//            int percentage = read*100.0/total;
            int percentage = read*100.0/lesson.score;
            if (percentage != lesson.downloadPercentage) {
                lesson.downloadPercentage = percentage;
                //[self persistentCourses];
            }
        } success:^(LEHttpRequestOperation *operation, NSString* file) {
            lesson.downloadPercentage = 100;
            [self persistentCourses];
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kCourseServiceDownloadDelay * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                dispatch_queue_t backgroundQueue = dispatch_queue_create("com.leiapp", 0);
                dispatch_async(backgroundQueue, ^{
                    
                    NSString *fromFile = file;
                    NSString *toFile = [NSString stringWithFormat:@"%@/lesson-%02d", path, lesson.index + 1];
                    
                    if (![[NSFileManager defaultManager] fileExistsAtPath:toFile]) {
                        NSError* error = nil;
                        [[NSFileManager defaultManager] createDirectoryAtPath:toFile withIntermediateDirectories:NO attributes:nil error:&error];
                    }
                    
                    ZipArchive *zipArchive = [[ZipArchive alloc] init];
                    [zipArchive UnzipOpenFile:fromFile Password:@"ulearning"];
                    BOOL unzip = [zipArchive UnzipFileTo:toFile overWrite:YES];
                    [zipArchive UnzipCloseFile];
                    
                    NSError* error = nil;
                    [[NSFileManager defaultManager] removeItemAtPath:fromFile error:&error];
                    
                    if (unzip) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            LELessonRecord* lessonRecord = [self getLessonRecord:[lesson.identifier intValue] lessonId:lesson.index];
                            if (lessonRecord != nil){
                                __block int pages = 0;
                                __block int totalTime = 0;
                                __block int totalScore = 0;
                                [lesson.sections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
                                    LECourseLessonSection* section = (LECourseLessonSection*)obj;
                                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sectionId == %d", section.index];
                                    NSArray *filtered = [lessonRecord.sections filteredArrayUsingPredicate:predicate];
                                    if ([filtered count] > 0) {
                                        LESectionRecord* record = [filtered objectAtIndex:0];
                                        section.score = record.score;
                                        section.studyTime = record.duration;
                                        totalTime += record.duration;
                                        totalScore += record.score;
                                        if (!section.hasPractice && record.duration > 7) {
                                            pages += 1;
                                        }
                                        if (section.hasPractice && record.score >= 60) {
                                            pages += 1;
                                        }
                                    }
                                }];
                                lesson.score = totalScore/[lesson.sections count];
                                lesson.totalTime = totalTime;
                                lesson.progress = pages*100.0/[lesson.sections count];
                            }
                            
                            lesson.downloadStatus = LELessonStatusStudyReady;
                            
                            [self persistentCourses];
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            lesson.downloadStatus = LELessonStatusDownloadError;
                            [self persistentCourses];
                        });
                        
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kCourseServiceDownloadDelay * NSEC_PER_SEC);
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            lesson.downloadStatus = LELessonStatusDownloadReady;
                            [self persistentCourses];
                        });
                    }
                });
            });
        } failure:^(LEHttpRequestOperation *operation, NSError *error) {
            lesson.score = 0;
            BOOL isDownloadCanceled = (error.code == NSURLErrorCancelled && error.domain == NSURLErrorDomain);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isDownloadCanceled) {
                    lesson.downloadStatus = LELessonStatusDownloadReady;
                } else {
                    lesson.downloadStatus = LELessonStatusDownloadError;
                }
                [self persistentCourses];
                
                if (!isDownloadCanceled) {
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kCourseServiceDownloadDelay * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        lesson.downloadStatus = LELessonStatusDownloadReady;
                        [self persistentCourses];
                    });
                }
            });
        }];
    });
}

- (void)stopDownloadLesson:(LECourseLesson*)lesson {
    if (lesson.downloadStatus != LELessonStatusDownloadOngoing) {
        return;
    }
    NSString *link = [self getLessonDownloadLink:lesson];
    [self.requestOperation cancelRequestByFile:link];
}

- (void)pauseDownloadLesson:(LECourseLesson*)lesson {
    if (lesson.downloadStatus != LELessonStatusDownloadOngoing) {
        return;
    }
    NSString *link = [self getLessonDownloadLink:lesson];
    [self.requestOperation pauseRequestByFile:link];
    
    lesson.downloadStatus = LELessonStatusDownloadPaused;
    [self persistentCourses];
}

- (void)stopAllDownloads {
    [self.requestOperation cancelAllFileRequests];
}

- (void)deleteStudyCourse:(LECourse*)course {
    if (course.status >= LECourseStatusStudyReady) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *folder = [[paths objectAtIndex:0] stringByAppendingPathComponent:kCourseServiceAssetsPath];
        NSString *path = [folder stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", course.identifier]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSError* error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
        course.status = LECourseStatusDownloadReady;
        [self persistentCourses];
    }
}

- (NSString*)getLessonDownloadLink:(LECourseLesson*)lesson {
    return [NSString stringWithFormat:@"%@/%@/lesson-%02d.zip", kCourseServiceLessonDownloadPath, lesson.identifier, lesson.index + 1];
}

- (LELessonRecord*)getLessonRecord:(int)courseId lessonId:(int)lessonId {
    NSPredicate *studyRecordsPredicate = [NSPredicate predicateWithFormat:@"courseId == %d", courseId];
    NSArray *studyRecordsFiltered = [self.records filteredArrayUsingPredicate:studyRecordsPredicate];
    LECourseStudyRecord* studyRecord;
    if ([studyRecordsFiltered count] > 0) {
        studyRecord = [studyRecordsFiltered objectAtIndex:0];
    } else {
        return nil;
    }
    NSArray* lessonRecords = studyRecord.lessons;
    LELessonRecord* lessonRecord;
    NSPredicate *lessonRecordsPredicate = [NSPredicate predicateWithFormat:@"lessonId == %d", lessonId];
    NSArray *lessonRecordsFiltered = [lessonRecords filteredArrayUsingPredicate:lessonRecordsPredicate];
    if ([lessonRecordsFiltered count] > 0) {
        lessonRecord = [lessonRecordsFiltered objectAtIndex:0];
    } else {
        return nil;
    }
    return lessonRecord;
}

- (void)performRecordFileUpload:(NSArray<LEPageAudioRecord, Optional>*)records complete:(void (^)())complete {
    NSString* (^getFilePath)(LEPageAudioRecord*) = ^NSString*(LEPageAudioRecord* record) {
        return [LECourseLessonSectionItemView pathForAsset:[record filePath]];
    };
    
    NSString* (^getFileName)(LEPageAudioRecord*) = ^NSString*(LEPageAudioRecord* record) {
        NSString* fileName = [[[record filePath] componentsSeparatedByString:@"/"] lastObject];
        return [NSMutableString stringWithFormat:@"ios/record/course/%@", fileName];
    };
    
    [records enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LEPageAudioRecord* record = obj;
        if ([record.filePath isEqualToString:@""]||!record.filePath) {//没有录音文件执行下一个
            return ;
        }
        //已经上传文件无需再上传
        if ([record mediaUrl] && [[[[record filePath] componentsSeparatedByString:@"/"] lastObject] isEqualToString:[[[record mediaUrl] componentsSeparatedByString:@"/"] lastObject]]) {
            return ;
        }
        NSString* path = getFilePath(record);
        NSString* filename = getFileName(record);
        
        NSString *postString = [NSString stringWithFormat:@"filename=%@&", filename];
        NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        [self.requestOperation requestByPost:kCourseServicePathGetFileUploadToken data:postData options:nil success:^(LEHttpRequestOperation *operation, NSData* response) {
            
            NSString* token = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            
            __block QNResponseInfo *testInfo = nil;
            
            QNUploadManager* uploadManager = [QNUploadManager sharedInstanceWithRecorder:nil recorderKeyGenerator:nil];
            [uploadManager putFile:path key:filename token:token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                success(key);
                testInfo = info;
                record.mediaUrl = key;
            } option:nil];
            NSDate *giveUpDate = [NSDate dateWithTimeIntervalSinceNow:60.0*5];//10分钟
            while ([giveUpDate timeIntervalSinceNow] > 0 && testInfo == nil) {
                NSDate *loopIntervalDate = [NSDate dateWithTimeIntervalSinceNow:0.01];
                [[NSRunLoop currentRunLoop] runUntilDate:loopIntervalDate];
            }
        } failure:^(LEHttpRequestOperation *operation, NSError *error) {
//            failure([error localizedDescription]);
            NSLog(@"");
        }];
    }];
}

- (void)performCourseFileUpload:(NSArray*)courses complete:(void (^)())complete {
    
    NSMutableArray* audioResponseItems = [NSMutableArray array];
    NSMutableArray* audioResponseRecords = [NSMutableArray array];
    
    NSString* (^getFilePath)(LECourseLessonLEIAudioResponse*) = ^NSString*(LECourseLessonLEIAudioResponse* audioResponse) {
        return [LECourseLessonSectionItemView pathForAsset:audioResponse.record];
    };
    
    NSString* (^getFileName)(LECourseLessonLEIAudioResponse*) = ^NSString*(LECourseLessonLEIAudioResponse* audioResponse) {
        NSString* path = getFilePath(audioResponse);
        NSString* timestamp = [[path componentsSeparatedByString:@"/"] lastObject];
        return [NSMutableString stringWithFormat:@"/ios/record/course/course_record_%@", timestamp];
    };
    
    void(^performUpload)(LECourseLessonLEIAudioResponse*, void(^)(NSString *), void (^)(NSString*)) = ^(LECourseLessonLEIAudioResponse* audioResponse, void(^success)(NSString *) , void(^failure)(NSString *) ) {
        
        NSString* path = getFilePath(audioResponse);
        NSString* filename = getFileName(audioResponse);
        
        NSString *postString = [NSString stringWithFormat:@"filename=%@&", filename];
        NSData *postData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        [self.requestOperation requestByPost:kCourseServicePathGetFileUploadToken data:postData options:nil success:^(LEHttpRequestOperation *operation, NSData* response) {
            
            NSString* token = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            QNUploadManager* uploadManager = [QNUploadManager sharedInstanceWithRecorder:nil recorderKeyGenerator:nil];
            [uploadManager putFile:path key:filename token:token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                success(key);
            } option:nil];
            
        } failure:^(LEHttpRequestOperation *operation, NSError *error) {
            failure([error localizedDescription]);
        }];
    };
    
    [courses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        LECourse* course = obj;
        [course.detail.lessons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
            LECourseLesson* lesson = obj;
            [lesson.sections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
                LECourseLessonSection* section = obj;
                [section.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
                    LECourseLessonSectionItem* item = obj;
                    if (item.type == LECourseLessonSectionItemTypeLEIAudioResponse) {
                        LECourseLessonLEIAudioResponseItem* responseItem = obj;
                        [responseItem.responses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
                            LECourseLessonLEIAudioResponse* audioResponseItem = obj;
                            NSUInteger audioResponseItemIndex = idx;
                            if (audioResponseItem.record && ![audioResponseItem.record isEmptyOrWhitespace]) {
                                NSString* record = [LECourseLessonSectionItemView pathForAsset:audioResponseItem.record];
                                if ([[NSFileManager defaultManager] fileExistsAtPath:record]) {
                                    
                                    NSPredicate *coursePredicate = [NSPredicate predicateWithFormat:@"courseId = %d", course.identifier];
                                    NSArray* courseRecords = [self.records filteredArrayUsingPredicate:coursePredicate];
                                    LECourseStudyRecord* courseRecord = [courseRecords firstObject];
                                    
                                    NSPredicate *lessonPredicate = [NSPredicate predicateWithFormat:@"lessonId = %d", lesson.index];
                                    NSArray *lessonRecords = [courseRecord.lessons filteredArrayUsingPredicate:lessonPredicate];
                                    LELessonRecord* lessonRecord = [lessonRecords firstObject];
                                    
                                    LESectionRecord* sectionRecord = [lessonRecord.sections firstObject];
                                    
                                    NSPredicate *pagePredicate = [NSPredicate predicateWithFormat:@"pageId = %d", section.index];
                                    NSArray *pageRecords = [sectionRecord.pages filteredArrayUsingPredicate:pagePredicate];
                                    LEPageRecord* pageRecord = [pageRecords firstObject];
                                    
                                    if (pageRecord.record == nil) {
                                        pageRecord.record = [NSArray<LEPageAudioRecord> array];
                                    }
                                    
                                    NSPredicate *audioRecordPredicate = [NSPredicate predicateWithFormat:@"index = %d", audioResponseItemIndex];
                                    NSArray *audioRecords = [pageRecord.record filteredArrayUsingPredicate:audioRecordPredicate];
                                    LEPageAudioRecord* audioRecord;
                                    if ([audioRecords count] > 0) {
                                        audioRecord = [audioRecords firstObject];
                                    } else {
                                        audioRecord = [[LEPageAudioRecord alloc] init];
                                        audioRecord.index = (int)audioResponseItemIndex;
                                        
                                        NSMutableArray* record = [NSMutableArray arrayWithArray:pageRecord.record];
                                        [record addObject:audioRecord];
                                        pageRecord.record = record;
                                    }
                                    
                                    NSString* filename = getFileName(audioResponseItem);
                                    if (![filename isEqualToString:audioRecord.mediaUrl]) {
                                        [audioResponseItems addObject:audioResponseItem];
                                        [audioResponseRecords addObject:audioRecord];
                                    }
                                }
                            }
                        }];
                    }
                }];
            }];
        }];
    }];
    
    
    //TODO
    //Below code no finished yet
    if ([audioResponseItems count] > 0) {
        __block int index = 0;
        
        void(^success)(NSString*);
        void(^failure)(NSString*);
        
        success = ^(NSString* key) {
            LEPageAudioRecord* audioRecord = [audioResponseRecords objectAtIndex:index];
            LECourseLessonLEIAudioResponse* audioResponse = [audioResponseItems objectAtIndex:index];
            audioRecord.mediaUrl = key;
            audioRecord.score = audioResponse.score;
            audioRecord.recordedCount = audioResponse.count;
            audioRecord.title = audioResponse.text;
            
            if (index < [audioResponseItems count] - 1) {
                index += 1;
                performUpload([audioResponseItems objectAtIndex:index], success, failure);
            } else {
                complete();
            }
        };
        
        failure = ^(NSString* error) {
            if (index < [audioResponseItems count] - 1) {
                index += 1;
                performUpload([audioResponseItems objectAtIndex:index], success, failure);
            } else {
                complete();
            }
        };
        
        performUpload([audioResponseItems objectAtIndex:index], success, failure);
        
    } else {
        complete();
    }
    
}


- (void)restoreCourses {
    NSArray *jsonArray = [NSArray arrayWithContentsOfFile:[self dataPath]];
    NSMutableArray* courses = [NSMutableArray arrayWithCapacity:[jsonArray count]];
    [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSError* error = nil;
        LECourse* course = [[LECourse alloc] initWithData:obj error:&error];
        //For any reason that download was not performanced succesfully
        //Revert back to original state
        if (course) {
            if (course.status >= LECourseStatusDownloadReady &&
                course.status <= LECourseStatusParsePaused) {
                course.status = LECourseStatusDownloadReady;
            }
            [courses addObject:course];
        }
    }];
    self.courses = courses;
}

- (void)persistentCourses {
    NSMutableArray* courseJsonArray = [NSMutableArray arrayWithCapacity:[self.courses count]];
    [self.courses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LECourse* course = obj;
        NSData* data = [course toJSONData];
        if (data) {
            [courseJsonArray addObject:data];
        }
    }];
    dispatch_queue_t persistentQueue = dispatch_queue_create("CourseServicePersistentQueue",NULL);
    dispatch_async(persistentQueue, ^{
        [courseJsonArray writeToFile:[self dataPath] atomically:NO];
    });
}

- (void)restoreRecords {
    NSArray *jsonArray = [NSArray arrayWithContentsOfFile:[self dataPath:@"records"]];
    NSMutableArray* records = [NSMutableArray arrayWithCapacity:[jsonArray count]];
    [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSError* error = nil;
        LECourseStudyRecord* record = [[LECourseStudyRecord alloc] initWithData:obj error:&error];
        if (record) {
            [records addObject:record];
        }
    }];
    self.records = records;
}

- (void)persistentRecords {
    NSDate* date = [[NSDate alloc] init];
    NSMutableArray* recordsJsonArray = [NSMutableArray arrayWithCapacity:[self.records count]];
    [self.records enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            LECourseStudyRecord* record = obj;
            NSData* data = [record toJSONData];
            [recordsJsonArray addObject:data];
    }];
    dispatch_queue_t persistentQueue = dispatch_queue_create("CourseServicePersistentQueue",NULL);
    dispatch_async(persistentQueue, ^{
        [recordsJsonArray writeToFile:[self dataPath:@"records"] atomically:NO];
    });
    NSLog(@"%f", [date timeIntervalSinceNow]);
}

- (void)persistent {
    [super persistent];
    [self persistentCourses];
    [self persistentRecords];
}

- (void)restore {
    [super restore];
    [self restoreRecords];
    [self restoreCourses];
}

//旧版本学习记录同步
- (void) uploadOldVersionStudyRecord
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    NSString* courseDBName = [NSString stringWithFormat:@"Courses_%@.sqlite", userId];
    NSString* coursesDBPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:courseDBName];
    if ([fileManager fileExistsAtPath:coursesDBPath]) {
        FMDatabase* db = [FMDatabase databaseWithPath:coursesDBPath];

        if (![db open]) {
            return;
        }
        
        NSString *kLearningsSQLQueryByCourseFormat = @"SELECT learning_lesson, learning_records FROM Learnings ORDER BY learning_lesson ASC";
        if (![db tableExists:@"Learnings"]) {
            [db close];
            return;
        }
        FMResultSet *resultSet = [db executeQuery:kLearningsSQLQueryByCourseFormat];
        NSMutableDictionary* learningLessonPage = [[NSMutableDictionary alloc] init];
        while ([resultSet next]) {
            NSNumber* learning_lesson = [resultSet objectForColumnIndex:0];
            NSString* learning_records = [resultSet objectForColumnIndex:1];
            [learningLessonPage setObject:learning_records forKey:learning_lesson];
        }
        if ([learningLessonPage count] <= 0) {
            [resultSet close];
            [db close];
            return;
        }
        if (![db tableExists:@"LessonSection"]) {
            [resultSet close];
            [db close];
            return;
        }
        resultSet = [db executeQuery:@"select courseID, lessonIndex, sectionIndex, score, studyTime, complete, record from LessonSection"];
        NSMutableArray* records = [[NSMutableArray alloc] init];
        NSMutableArray* allLessons = [NSMutableArray arrayWithArray:[learningLessonPage allKeys]];
        while ([resultSet next]) {
            LESycnStudyRecord* record = [[LESycnStudyRecord alloc] init];
            NSString* courseID = [resultSet objectForColumnIndex:0];
            NSNumber* lessonIndex = [resultSet objectForColumnIndex:1];
            NSNumber* sectionIndex = [resultSet objectForColumnIndex:2];
            NSNumber* score = [resultSet objectForColumnIndex:3];
            NSNumber* studyTime = [resultSet objectForColumnIndex:4];
            NSNumber* complete = [resultSet objectForColumnIndex:5];
            NSString* recordStr = [resultSet objectForColumnIndex:6];
            record.courseID = [courseID intValue];
            record.lessonID = lessonIndex.intValue;
            record.sectionID = lessonIndex.intValue;
            record.pageID = sectionIndex.intValue;
            record.score = score.intValue;
            record.studytime = studyTime.intValue;
            record.complete = complete.intValue;
            record.records = recordStr;
            if (![allLessons containsObject:lessonIndex]) {
                continue;
            }
            NSString* learningRecords = [learningLessonPage objectForKey:lessonIndex];
            NSMutableArray* learningPages = [NSMutableArray arrayWithArray:[learningRecords componentsSeparatedByString:@","]];
            if (![learningPages containsObject:[NSString stringWithFormat:@"%@",sectionIndex]]) {
                continue;
            }
            [records addObject:record];
        }
        [resultSet close];
        [db close];
        
        [self uploadStudyRecords:records success:^(LECourseService *service) {
            [fileManager removeItemAtPath:coursesDBPath error:nil];
        } failure:^(LECourseService *service, NSString *error) {
            
        }];
    }
    
}

@end