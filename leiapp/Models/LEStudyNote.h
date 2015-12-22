//
//  LEStudyNote.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"

@interface LEStudyNote : JSONModel

@property (assign, nonatomic) int courseId;
@property (assign, nonatomic) int lessonId;
@property (assign, nonatomic) int sectionId;
@property (assign, nonatomic) int pageId;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSDate<Optional>* date;

@end
