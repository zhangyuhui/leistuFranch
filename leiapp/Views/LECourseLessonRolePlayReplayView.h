//
//  LECourseLessonRolePlayReplayView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/15/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEAudioCustomView.h"
#import "LECourseLessonLEIRolePlayDialog.h"

@class LECourseLessonRolePlayReplayViewView;

@protocol LECourseLessonRolePlayReplayViewDelegate <NSObject>
@optional
- (void)didReplayViewPlayStart;
- (void)didReplayViewPlayFinish;
@end

@interface LECourseLessonRolePlayReplayView : LEAudioCustomView

@property (strong, nonatomic) LECourseLessonLEIRolePlayDialog* dialog;
@property (strong, nonatomic) NSString* image;
@property (strong, nonatomic) NSString* name;

@property (assign, nonatomic) id<LECourseLessonRolePlayReplayViewDelegate> delegate;

@end

