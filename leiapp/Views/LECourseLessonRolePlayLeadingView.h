//
//  LECourseLessonRolePlayLeadingView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/11/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEAudioCustomView.h"
#import "LECourseLessonLEIRolePlayDialog.h"

@class LECourseLessonRolePlayLeadingView;

@protocol LECourseLessonRolePlayLeadingViewDelegate <NSObject>
@optional
- (void)didLeadingViewRecordStart;
- (void)didLeadingViewRecordFinish;
@end

@interface LECourseLessonRolePlayLeadingView : LEAudioCustomView

@property (strong, nonatomic) LECourseLessonLEIRolePlayDialog* dialog;
@property (strong, nonatomic) NSString* image;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) int script;

@property (assign, nonatomic) id<LECourseLessonRolePlayLeadingViewDelegate> delegate;

- (CGFloat)heightForView;

@end
