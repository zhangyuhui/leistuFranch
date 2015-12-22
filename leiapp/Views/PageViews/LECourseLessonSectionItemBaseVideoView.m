//
//  LECourseLessonSectionItemBaseVideoView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/5/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemBaseVideoView.h"
#import <MediaPlayer/MediaPlayer.h>

#define kProgressTimer 1.0

@interface LECourseLessonSectionItemBaseVideoView() 

@property (nonatomic, strong) MPMoviePlayerController* videoPlayer;
@property (nonatomic, strong) NSTimer* videoPlayerProgressTimer;

-(void)updateVideoPlayerProgress:(NSTimer *)timer;

@end

@implementation LECourseLessonSectionItemBaseVideoView


-(void)setSelected:(BOOL)selected{
    if (!selected  && ([self isVideoPlaying] || [self isVideoPaused])) {
        [self stopVideoPlay];
    }
    [super setSelected:selected];
}

-(BOOL)isVideoPlaying {
    return (self.videoPlayer && self.videoPlayer.playbackState == MPMoviePlaybackStatePlaying);
}

-(BOOL)isVideoPaused {
    return (self.videoPlayer && self.videoPlayer.playbackState == MPMoviePlaybackStatePaused);
}

-(void)startVideoPlay{
    if (!self.videoPlayer) {
        self.videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:self.videoPlayPath]];
        self.videoPlayer.scalingMode = MPMovieScalingModeAspectFit;
        self.videoPlayer.controlStyle = MPMovieControlStyleNone;
        self.videoPlayer.repeatMode = NO;
        //self.videoPlayer.useApplicationAudioSession = YES;
        self.videoPlayer.allowsAirPlay = NO;
        self.videoPlayer.movieSourceType = MPMovieSourceTypeFile;
        [self.videoPlayer.view setTranslatesAutoresizingMaskIntoConstraints:YES];
        self.videoPlayer.backgroundView.backgroundColor = [UIColor clearColor];
        self.videoPlayer.view.backgroundColor = [UIColor clearColor];
        for(UIView *view in self.videoPlayer.view.subviews) {
            view.backgroundColor = [UIColor clearColor];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieLoadStateDidChange:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:self.videoPlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.videoPlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieIsPreparedToPlayDidChange:)
                                                     name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                   object:self.videoPlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackStateDidChange:)
                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                   object:self.videoPlayer];
        
        [self.videoPlayer prepareToPlay];
        self.videoPlayerProgressTimer = [NSTimer scheduledTimerWithTimeInterval:kProgressTimer target:self selector:@selector(updateVideoPlayerProgress:) userInfo:nil repeats:YES];
        
        
        [self.videoPlayer play];
    }
}

-(void)stopVideoPlay{
    if (self.videoPlayer && self.videoPlayerProgressTimer) {
        [self.videoPlayerProgressTimer invalidate];
        self.videoPlayerProgressTimer = nil;
        [self.videoPlayer stop];
        self.videoPlayer = nil;
        [self willVideoPlayUnloaded:self.videoPlayer.view];
    }
}

-(void)pauseVideoPlay{
    if ([self isVideoPlaying]) {
        [self.videoPlayer pause];
        [self.videoPlayerProgressTimer invalidate];
        self.videoPlayerProgressTimer = nil;
    }
}

-(void)resumeVideoPlay{
    if ([self isVideoPaused]) {
        [self.videoPlayer play];
        self.videoPlayerProgressTimer = [NSTimer scheduledTimerWithTimeInterval:kProgressTimer target:self selector:@selector(updateVideoPlayerProgress:) userInfo:nil repeats:YES];
    }
}

-(void)updateVideoPlayerProgress:(NSTimer *)timer {
    CGFloat percentage = self.videoPlayer.currentPlaybackTime / self.videoPlayer.duration;
    if (percentage >= 0.95) {
        percentage = 1.0;
    }
    NSTimeInterval remainingTime = self.videoPlayer.duration - self.videoPlayer.currentPlaybackTime;
    [self didVideoPlayUpdate:percentage remainingTime:remainingTime];
}

-(void)didVideoPlayStart {};
-(void)didVideoPlayLoaded:(UIView*)view {};
-(void)willVideoPlayUnloaded:(UIView*)view {};
-(void)didVideoPlayStopped {};
-(void)didVideoPlayPaused {};
-(void)didVideoPlayResumed {};
-(void)didVideoPlayUpdate:(CGFloat)percentage remainingTime:(NSTimeInterval)remainingTime {};


#pragma mark Movie Notification Handlers
- (void) moviePlayBackDidFinish:(NSNotification*)notification{
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason integerValue]){
        case MPMovieFinishReasonPlaybackEnded: {
            [self stopVideoPlay];
            break;
        }
        case MPMovieFinishReasonPlaybackError: {
            [self stopVideoPlay];
            break;
        }
        case MPMovieFinishReasonUserExited: {
            [self stopVideoPlay];
            break;
        }
        default: {
            break;
        }
    }
}

- (void)movieLoadStateDidChange:(NSNotification *)notification {
    MPMoviePlayerController *player = notification.object;
    MPMovieLoadState loadState = player.loadState;
    if (loadState & MPMovieLoadStateUnknown){
    }
    if (loadState & MPMovieLoadStatePlayable){
    }
    if (loadState & MPMovieLoadStatePlaythroughOK){
    }
    if (loadState & MPMovieLoadStateStalled){
    }
}

- (void) moviePlayBackStateDidChange:(NSNotification*)notification{
    MPMoviePlayerController *player = notification.object;
    if (player.playbackState == MPMoviePlaybackStateStopped){
        self.selected = NO;
        [self didVideoPlayStopped];
    }else if (player.playbackState == MPMoviePlaybackStatePlaying){
        if (self.videoPlayer.currentPlaybackTime > 0) {
            [self didVideoPlayResumed];
        } else {
            self.selected = YES;
            [self didVideoPlayStart];
        }
    }else if (player.playbackState == MPMoviePlaybackStatePaused){
        [self didVideoPlayPaused];
    }else if (player.playbackState == MPMoviePlaybackStateInterrupted){
        [self stopVideoPlay];
    }
}

- (void) movieIsPreparedToPlayDidChange:(NSNotification*)notification{
    [self didVideoPlayLoaded:self.videoPlayer.view];
}

@end
