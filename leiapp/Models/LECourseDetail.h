//
//  LECourseDetail.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "LECourseLesson.h"
#import "LECourseBookmark.h"
#import "LECourseGlossary.h"
#import "LECourseTestSection.h"

@interface LECourseDetail : JSONModel

@property (assign, nonatomic) int index;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString<Optional>* introduction;
@property (strong, nonatomic) NSString* objective;
@property (strong, nonatomic) NSString* cover;

@property (assign, nonatomic) float credit;
@property (assign, nonatomic) int validity;
@property (assign, nonatomic) int mintime;
@property (assign, nonatomic) int minratio;
@property (assign, nonatomic) int passmark;
@property (assign, nonatomic) int commentCount;
@property (assign, nonatomic) int percentage;
@property (assign, nonatomic) int score;

@property (assign, nonatomic) int historyLesson;

@property (strong, nonatomic) NSDate<Optional>*   createDate;
@property (strong, nonatomic) NSDate<Optional>*   expireDate;
@property (strong, nonatomic) NSDate<Optional>*   completeDate;

@property (strong, nonatomic) NSArray<LECourseLesson>*  lessons;
@property (strong, nonatomic) NSArray<LECourseBookmark, Optional>*  bookmarks;
@property (strong, nonatomic) NSArray<LECourseGlossary, Optional>*  glossaries;
@property (strong, nonatomic) NSArray<LECourseTestSection, Optional>*  tests;

@end
