//
//  User.h
//  JKBaseModel
//
//  Created by zx_04 on 15/6/24.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"
#import "LEPageAudioRecord.h"

@interface LESycnStudyRecord : JKDBModel

@property (nonatomic, assign)   int                        id;

@property (nonatomic, assign)   int                        courseID;

@property (nonatomic, assign)   int                        lessonID;

@property (nonatomic, assign)   int                        sectionID;

@property (nonatomic, assign)   int                        pageID;

@property (nonatomic, assign)   int                        studytime;

@property (nonatomic, assign)   int                        complete;

@property (nonatomic, assign)   int                        score;

@property (nonatomic,   copy)   NSString *                 records;
@property (strong, nonatomic) NSArray<LEPageAudioRecord, Optional>* record;
-(NSArray *)recordToArray;
+(NSArray *)getAllCourses;
@end
