//
//  LECourseLessonSectionItemBaseVideoView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/5/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemView.h"

@interface LECourseLessonSectionItemBaseVideoView : LECourseLessonSectionItemView
@property (nonatomic, strong) NSString* videoPlayPath;

-(BOOL)isVideoPlaying;
-(BOOL)isVideoPaused;
-(void)startVideoPlay;
-(void)stopVideoPlay;
-(void)pauseVideoPlay;
-(void)resumeVideoPlay;

-(void)didVideoPlayLoaded:(UIView*)view;
-(void)didVideoPlayStart;
-(void)willVideoPlayUnloaded:(UIView*)view;
-(void)didVideoPlayStopped;
-(void)didVideoPlayPaused;
-(void)didVideoPlayResumed;
-(void)didVideoPlayUpdate:(CGFloat)percentage remainingTime:(NSTimeInterval)remainingTime;


@end
