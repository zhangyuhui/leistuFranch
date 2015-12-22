//
//  LECourseLessonSectionItemBaseAudioView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/4/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemView.h"

@interface LECourseLessonSectionItemBaseAudioView : LECourseLessonSectionItemView

@property (strong, nonatomic) NSString *audioPlayPath;

-(BOOL)isAudioPlaying;
-(BOOL)isAudioPaused;
-(void)startAudioPlay;
-(void)stopAudioPlay;
-(void)pauseAudioPlay;
-(void)resumeAudioPlay;

-(void)didAudioPlayStart;
-(void)didAudioPlayStopped;
-(void)didAudioPlayPaused;
-(void)didAudioPlayResumed;
-(void)didAudioPlayUpdate:(CGFloat)percentage remainingTime:(NSTimeInterval)remainingTime;

@end
