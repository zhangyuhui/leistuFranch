//
//  LEStudyRecord.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "LELessonRecord.h"
#import "LECourseBookmark.h"
#import "LECourseNote.h"

@interface LECourseStudyRecord : JSONModel

@property (assign, nonatomic) int courseId;
@property (strong, nonatomic) NSArray<LELessonRecord, Optional>* lessons;
@property (strong, nonatomic) NSArray<LECourseNote, Optional>* notes;
@property (strong, nonatomic) NSArray<LECourseBookmark, Optional>* bookmarks;

@end
