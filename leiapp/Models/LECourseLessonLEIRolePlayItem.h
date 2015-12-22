//
//  LELessonLEIRolePlayItem.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItem.h"
#import "LECourseLessonLEIRolePlayDialog.h"

@protocol LECourseLessonLEIRolePlayItem
@end

@interface LECourseLessonLEIRolePlayItem : LECourseLessonSectionItem

@property (nonatomic, strong) NSString* video;
@property (nonatomic, strong) NSString* cover;
@property (nonatomic, strong) NSArray* speakerNames;
@property (nonatomic, strong) NSArray* speakerImages;
@property (nonatomic, strong) NSArray<LECourseLessonLEIRolePlayDialog>* speakerDialogs;
@property (nonatomic) int speaker;
@property (nonatomic) int selection;


@end
