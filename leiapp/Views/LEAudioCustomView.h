//
//  LEAudioCustomView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/30/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECustomView.h"

@interface LEAudioCustomView : LECustomView
@property (nonatomic, strong) NSString* audioPlayPath;
@property (nonatomic, strong) NSString* audioRecordPath;
@property (nonatomic, strong) NSString* audioEvaluatePath;//评分录音文件路径
@property (nonatomic, strong) NSString* audioEvaluateScript;

@property (nonatomic, assign) int audioRecordDuration;
@property (nonatomic, assign) int audioRecordWarnDuration;
@property (nonatomic, assign) BOOL shouldAudioRecordSmartStop;
@property (nonatomic, assign) BOOL shouldAudioRecordWarnStop;

-(BOOL)isAudioPlaying;
-(BOOL)isAudioPaused;
-(void)startAudioPlay;
-(void)stopAudioPlay;
-(void)pauseAudioPlay;
-(void)resumeAudioPlay;

-(BOOL)isRecordPlaying;
-(BOOL)isRecordPlayPaused;
-(void)startRecordPlay;
-(void)stopRecordPlay;
-(void)pauseRecordPlay;
-(void)resumeRecordPlay;

-(BOOL)isAudioRecording;
-(void)startAudioRecord;
-(void)stopAudioRecord;
-(BOOL)hasAudioRecord;

-(BOOL)isAudioEvaluating;
-(void)startAudioEvaluate;
-(void)stopAudioEvaluate;
-(BOOL)hasAudioEvaluate;

-(void)didAudioPlayStart;
-(void)didAudioPlayStopped;
-(void)didAudioPlayPaused;
-(void)didAudioPlayResumed;
-(void)didAudioPlayUpdate:(CGFloat)percentage remainingTime:(NSTimeInterval)remainingTime;

-(void)didRecordPlayStart;
-(void)didRecordPlayStopped;
-(void)didRecordPlayPaused;
-(void)didRecordPlayResumed;
-(void)didRecordPlayUpdate:(CGFloat)percentage;

-(void)didAudioRecordStart;
-(void)didAudioRecordStopped;
-(void)didAudioRecordWarned;
-(void)didAudioRecordUpdate:(CGFloat)percentage;

-(void)didAudioEvaluateStart;
-(void)didAudioEvaluateStopped;
-(void)didAudioEvaluateUpdate:(CGFloat)percentage;
-(void)didAudioEvaluateScored:(CGFloat)score;
- (BOOL)canRecord;
@end
