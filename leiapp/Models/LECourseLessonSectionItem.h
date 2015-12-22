//
//  LELessonSectionItem.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"

typedef NS_ENUM(NSInteger, LECourseLessonSectionItemType) {
    LECourseLessonSectionItemTypeNoteText,
    LECourseLessonSectionItemTypePlainText,
    LECourseLessonSectionItemTypeThinkText,
    LECourseLessonSectionItemTypeExampleText,
    LECourseLessonSectionItemTypeDidYouKnowText,
    LECourseLessonSectionItemTypeRememberText,
    LECourseLessonSectionItemTypeImportantText,
    LECourseLessonSectionItemTypeImage,
    LECourseLessonSectionItemTypeVideo,
    LECourseLessonSectionItemTypePPT,
    
    LECourseLessonSectionItemTypeLEIPlainText,
    LECourseLessonSectionItemTypeLEIPlainImage,
    LECourseLessonSectionItemTypeLEIAudioResponse,
    LECourseLessonSectionItemTypeLEIAudio,
    LECourseLessonSectionItemTypeLEIVideo,
    LECourseLessonSectionItemTypeLEIPractice,
    LECourseLessonSectionItemTypeLEIRolePlay,
    LECourseLessonSectionItemTypeLEIAudioText,
    LECourseLessonSectionItemTypeLEIReading,
    
    LECourseLessonSectionItemTypeOptionTest,
    LECourseLessonSectionItemTypeStatementTest
};

@protocol LECourseLessonSectionItem
@end

@interface LECourseLessonSectionItem : JSONModel

@property (nonatomic, assign) LECourseLessonSectionItemType type;
@property (nonatomic) NSUInteger index;

- (instancetype)initWithType:(LECourseLessonSectionItemType)type;

@end
