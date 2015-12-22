//
//  LELessonRecord.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "LESectionRecord.h"

@protocol LELessonRecord
@end

@interface LELessonRecord : JSONModel

@property (assign, nonatomic) int lessonId;
@property (strong, nonatomic) NSArray<LESectionRecord>* sections;

@end
