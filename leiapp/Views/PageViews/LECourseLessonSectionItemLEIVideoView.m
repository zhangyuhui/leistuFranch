//
//  LECourseLessonSectionItemLEIVideoView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/5/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIVideoView.h"
#import "LEVideoControlView.h"
#import <AVFoundation/AVFoundation.h>
#import "LEDefines.h"
#import "LEConstants.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIButton+UIButton_SetBgState.h"
#import "NSString+Addition.h"

#define VIEW_HEIGHT 245

@interface LECourseLessonSectionItemLEIVideoView () <LEVideoControlViewDelegate>

@property (strong, nonatomic) IBOutlet LEVideoControlView* controllView;
@property (strong, nonatomic) IBOutlet UIButton *scriptButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scriptButtonHeightConstraint;

@end

@implementation LECourseLessonSectionItemLEIVideoView

- (instancetype)initWithLEIVideoItem:(LECourseLessonLEIVideoItem*)item {
    self = [super initWithItem:item];
    if (self){
        
    }
    return self;
}

- (void)didSetupSubViews {
    LECourseLessonLEIVideoItem* item = (LECourseLessonLEIVideoItem*)self.item;
    self.videoPlayPath = [LECourseLessonSectionItemView pathForAsset:item.video];
    self.controllView.delegate = self;
    self.controllView.cover = [LECourseLessonSectionItemView pathForAsset:item.cover];
    
    if (![NSString stringIsNilOrEmpty: item.transcript]) {
        self.scriptButton.layer.cornerRadius = 15;
        self.scriptButton.layer.borderWidth = 1;
        self.scriptButton.layer.borderColor = UIColorFromRGB(0xe3e3e3).CGColor;
        [self.scriptButton setBackgroundColor:COLORWHITESELECT forState:UIControlStateHighlighted];
    } else {
        self.scriptButton.hidden = YES;
    }
}

- (CGFloat)heightForItem {
    return self.scriptButton.hidden ? (VIEW_HEIGHT - self.scriptButtonHeightConstraint.constant) : VIEW_HEIGHT;
}

- (IBAction)clickScriptButton:(id)sender {
    LECourseLessonLEIVideoItem* item = (LECourseLessonLEIVideoItem*)self.item;
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:item.transcript, @"transcript", nil];
    [notification postNotificationName:kLENotificationCourseStudyShowTranscript object:nil userInfo:userInfo];
}

#pragma mark - Video Player Hooks
-(void)didVideoPlayLoaded:(UIView*)view {
    [self.controllView showVideoView:view];
}

-(void)didVideoPlayStart {
    [self.controllView hidePlayButton];
}

-(void)willVideoPlayUnloaded:(UIView*)view {
    [self.controllView hideVideoView:view];
}

-(void)didVideoPlayStopped {
    [self.controllView showPlayButton];
}

-(void)didVideoPlayPaused {
    [self.controllView showPlayButton];
}

-(void)didVideoPlayResumed {
    [self.controllView hidePlayButton];
}

#pragma mark - LEVideoControlViewDelegate
- (void)controlView:(LEVideoControlView*)controlView didClickPlayButton:(UIButton*)button {
    if ([self isVideoPlaying]) {
        [self pauseVideoPlay];
    } else if ([self isVideoPaused]){
        [self resumeVideoPlay];
    } else {
        [self startVideoPlay];
    }
}

- (void)controlView:(LEVideoControlView*)controlView didTapCanvasView:(UIView*)canvas {
    if ([self isVideoPlaying]) {
        [self pauseVideoPlay];
    }
}
@end
