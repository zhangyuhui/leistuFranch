//
//  LELessonLEIRolePlayDialog.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"

@protocol LECourseLessonLEIRolePlayDialog
@end

@interface LECourseLessonLEIRolePlayDialog : JSONModel

@property (nonatomic, strong) NSString* video;
@property (nonatomic, strong) NSString<Optional>* record;
@property (nonatomic, strong) NSString* transcript;
@property (nonatomic, strong) NSArray* helpscripts;
@property (nonatomic) int speaker;
@property (nonatomic) int duration;

@end
