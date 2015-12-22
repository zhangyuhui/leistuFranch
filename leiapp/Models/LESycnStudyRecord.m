//
//  User.m
//  JKBaseModel
//
//  Created by zx_04 on 15/6/24.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import "LESycnStudyRecord.h"
#import "JKDBHelper.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "LECourseService.h"
@interface LESycnStudyRecord ()
@property(nonatomic, strong) NSArray<LESycnStudyRecord*>* syncRecords;

@end

@implementation LESycnStudyRecord

-(NSArray *)recordToArray{
    if (self.record) {
        NSString *recordString;
        SBJsonWriter *jsonWriter = [SBJsonWriter new];
        NSMutableArray *array = [NSMutableArray array];
        for (LEPageAudioRecord * audioRecord in self.record) {
            [array addObject:[audioRecord toDictionary]];
        }
        recordString = [jsonWriter stringWithObject:array];
        return @[@{@"lessons":@[@{@"sections":@[@{@"pages":@[@{@"pageID":[NSNumber numberWithInt:self.pageID] , @"score": [NSNumber numberWithInt:self.score], @"studyTime": [NSNumber numberWithInt:self.studytime],@"complete":[NSNumber numberWithInt:self.complete],@"record":recordString}],@"sectionID":[NSNumber numberWithInt:self.sectionID]}],@"lessonID":[NSNumber numberWithInt:self.lessonID]}],@"courseID":[NSNumber numberWithInt:self.courseID]}];
    }
    return @[@{@"lessons":@[@{@"sections":@[@{@"pages":@[@{@"pageID":[NSNumber numberWithInt:self.pageID] , @"score": [NSNumber numberWithInt:self.score], @"studyTime": [NSNumber numberWithInt:self.studytime],@"complete":[NSNumber numberWithInt:self.complete]}],@"sectionID":[NSNumber numberWithInt:self.sectionID]}],@"lessonID":[NSNumber numberWithInt:self.lessonID]}],@"courseID":[NSNumber numberWithInt:self.courseID]}];
}
+(NSArray*)getAllCourses{
    NSArray *arr = [self findAll];
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
        NSArray * dblessons = [self findByCourseID:courseID.intValue];
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
            NSArray * dbsections = [self findByCourseID:courseID.intValue LessonID:lessonID.intValue];
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
                NSArray * dbpages = [self findByCourseID:courseID.intValue LessonID:lessonID.intValue SectionID:sectionID.intValue];
                NSMutableDictionary * pageIDDic = [NSMutableDictionary dictionary];
                for (LESycnStudyRecord *record in dbpages) {
                    [pageIDDic setObject:[NSNumber numberWithInt:record.pageID] forKey:[NSNumber numberWithInt:record.pageID]];
                }
                NSArray *pagesIDArray = [pageIDDic allKeys];
                NSMutableArray *pages = [NSMutableArray arrayWithCapacity:[pagesIDArray count]];
                for (NSNumber * pageID in pagesIDArray) {
                    //第四层 获取page所有属性 添加到 page 遍历结束把page添加到pages
                    NSMutableDictionary *pagedic = [NSMutableDictionary dictionary];
                    NSArray * dbpages = [self findByCourseID:courseID.intValue LessonID:lessonID.intValue SectionID:sectionID.intValue PageID:pageID.intValue];
                    if ([dbpages count]==0) {
                        break;
                    }
                    LESycnStudyRecord *record = [dbpages objectAtIndex:0];
                    [pagedic setObject:pageID forKey:@"pageID"];
                    [pagedic setObject:[NSNumber numberWithInt:record.studytime] forKey:@"studyTime"];
                    [pagedic setObject:[NSNumber numberWithInt:record.complete] forKey:@"complete"];
                    [pagedic setObject:[NSNumber numberWithInt:record.score] forKey:@"score"];
                    if (record.records.length>10) {
                        [pagedic setObject:record.records forKey:@"record"];
//                        SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
//                        NSArray *recordArray = [jsonParser objectWithString:record.records];
//                        NSMutableArray<LEPageAudioRecord>*array = [NSMutableArray<LEPageAudioRecord> array];
//                        for (NSDictionary* dic in recordArray) {
//                            LEPageAudioRecord *audiorecord = [[LEPageAudioRecord alloc]initWithDictionary:dic error:nil];
//                            [array addObject:audiorecord];
//                        }
//                        [[LECourseService sharedService]performRecordFileUpload:array complete:^{
//                            NSLog(@"上传单个文件成功");
//                        }];
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
- (BOOL)save
{
    if ([self.record count]>0) {
        SBJsonWriter *jsonWriter = [SBJsonWriter new];
        NSMutableArray *array = [NSMutableArray array];
        for (LEPageAudioRecord * audioRecord in self.record) {
            [array addObject:[audioRecord toDictionary]];
        }
        self.records = [jsonWriter stringWithObject:array];
//        self.record = nil;
    }
//    else
//        self.record = nil;
    return [super save];
}
@end
