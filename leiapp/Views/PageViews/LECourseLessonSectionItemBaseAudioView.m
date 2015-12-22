//
//  LECourseLessonSectionItemBaseAudioView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/4/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemBaseAudioView.h"
#import "LEConstants.h"
#import "NSString+Addition.h"
#import <AVFoundation/AVFoundation.h>

@interface LECourseLessonSectionItemBaseAudioView() <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer* audioPlayer;
@property (nonatomic, assign) NSTimeInterval audioPlayerCurrentTime;
@property (nonatomic, strong) NSTimer* audioPlayerProgressTimer;

-(void)updateAudioPlayerProgress:(NSTimer *)timer;

@end

@implementation LECourseLessonSectionItemBaseAudioView

-(void)setSelected:(BOOL)selected{
    if (!selected  && ([self isAudioPlaying] || [self isAudioPaused])) {
        [self stopAudioPlay];
    }
    [super setSelected:selected];
}

-(BOOL)isAudioPlaying {
    return (self.audioPlayer && self.audioPlayer.isPlaying);
}

-(BOOL)isAudioPaused {
    return (self.audioPlayer && !self.audioPlayer.isPlaying);
}

-(void)startAudioPlay{
    if (!self.audioPlayer) {
        NSError* error;
        NSURL* url = [NSURL fileURLWithPath:self.audioPlayPath];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.audioPlayer.delegate=self;
        self.audioPlayer.volume= 0.5;
        self.audioPlayerCurrentTime = 0;
        [self.audioPlayer prepareToPlay];
        self.audioPlayerProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateAudioPlayerProgress:) userInfo:nil repeats:YES];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [self.audioPlayer play];
        
        self.selected = YES;
        [self didAudioPlayStart];
    }
}

-(void)stopAudioPlay{
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
        [self.audioPlayerProgressTimer invalidate];
        self.audioPlayerProgressTimer = nil;
        self.audioPlayerCurrentTime = 0;
        self.selected = NO;
        [self didAudioPlayStopped];
    }
}

-(void)pauseAudioPlay{
    if ([self isAudioPlaying]) {
        [self.audioPlayer pause];
        [self.audioPlayerProgressTimer invalidate];
        self.audioPlayerProgressTimer = nil;
        [self didAudioPlayPaused];
    }
}

-(void)resumeAudioPlay{
    if ([self isAudioPaused]) {
        [self.audioPlayer play];
        self.audioPlayerProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateAudioPlayerProgress:) userInfo:nil repeats:YES];
        [self didAudioPlayResumed];
    }
}

-(void)updateAudioPlayerProgress:(NSTimer *)timer {
    if (self.audioPlayerCurrentTime < self.audioPlayer.currentTime) {
        self.audioPlayerCurrentTime = self.audioPlayer.currentTime;
    } else {
        self.audioPlayerCurrentTime = self.audioPlayer.duration;
    }
    if (self.audioPlayerCurrentTime > self.audioPlayer.duration) {
        self.audioPlayerCurrentTime = self.audioPlayer.duration;
    }
    CGFloat percentage = self.audioPlayerCurrentTime / self.audioPlayer.duration;
    if (percentage >= 0.95) {
        percentage = 1.0;
    }
    NSTimeInterval remainingTime = self.audioPlayer.duration - self.audioPlayerCurrentTime;
    [self didAudioPlayUpdate:percentage remainingTime:remainingTime];
}

-(void)didAudioPlayStart {};
-(void)didAudioPlayStopped {};
-(void)didAudioPlayPaused {};
-(void)didAudioPlayResumed {};
-(void)didAudioPlayUpdate:(CGFloat)percentage remainingTime:(NSTimeInterval)remainingTime {};


#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopAudioPlay];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [self stopAudioPlay];
}

@end



