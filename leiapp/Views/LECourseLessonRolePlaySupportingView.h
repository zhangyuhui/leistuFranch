//
//  LECourseLessonRolePlaySupportingView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/14/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEVideoCustomView.h"
#import "LECourseLessonLEIRolePlayDialog.h"

@class LECourseLessonRolePlaySupportingView;

@protocol LECourseLessonRolePlaySupportingViewDelegate <NSObject>
@optional
- (void)didSuportingViewPlayStart;
- (void)didSuportingViewPlayFinish;
@end

@interface LECourseLessonRolePlaySupportingView : LEVideoCustomView

@property (strong, nonatomic) LECourseLessonLEIRolePlayDialog* dialog;
@property (assign, nonatomic) int script;

@property (assign, nonatomic) id<LECourseLessonRolePlaySupportingViewDelegate> delegate;

- (CGFloat)heightForView;

@end
