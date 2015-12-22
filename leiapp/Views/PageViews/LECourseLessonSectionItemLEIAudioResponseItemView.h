//
//  LECourseLessonSectionItemLEIAudioResponseItemView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEAudioCustomView.h"
#import "LECourseLessonLEIAudioResponse.h"
#import "LEPageAudioRecord.h"
//static int height,heightExpanded;
@interface LECourseLessonSectionItemLEIAudioResponseItemView: LEAudioCustomView
@property (nonatomic, strong) LECourseLessonLEIAudioResponse* response;
@property (nonatomic, strong) LEPageAudioRecord* audioRecord;
@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, strong) NSDictionary * pathdic;
@property (nonatomic, strong) IBOutlet UIView *scoreView;
@property (nonatomic, assign) int viewHeight;
@property (nonatomic, assign) int viewHeightExpanded;
- (void)reset;

- (CGFloat)heightForReponse: (BOOL)expanded;
@end
