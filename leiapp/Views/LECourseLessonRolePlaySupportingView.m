//
//  LECourseLessonRolePlaySupportingView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/14/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonRolePlaySupportingView.h"
#import "LEVideoControlView.h"
#import "LEDotProgressView.h"
#import "LECourseLessonSectionItemView.h"
#import "LEConversionView.h"
#import "LECourseLessonSectionItemView.h"
#import "LEDefines.h"
#import "NSString+Addition.h"

@interface LECourseLessonRolePlaySupportingView () <LEVideoControlViewDelegate>
@property (nonatomic, strong) IBOutlet UIView* statusView;
@property (nonatomic, strong) IBOutlet LEDotProgressView* progressView;
@property (nonatomic, strong) IBOutlet LEConversionView* conversionView;
@property (strong, nonatomic) IBOutlet LEVideoControlView* controllView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint* conversionViewLeadingConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* conversionViewTrailingConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* conversionViewHeightConstraint;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint* statusViewTopConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* statusViewHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* statusViewSpacingConstraint;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint* controlViewHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* controlViewSpacingConstraint;
@end

@implementation LECourseLessonRolePlaySupportingView

- (void)viewDidLoad {
    self.progressView.progress = 0.5;
    self.conversionView.text = @"";
    
    CGFloat viewHeight = [self checkConversionHeight];
    self.conversionViewHeightConstraint.constant = viewHeight;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat viewWidth = screenRect.size.width - self.conversionViewLeadingConstraint.constant - self.conversionViewTrailingConstraint.constant;
    self.conversionView.arrowPostion = viewWidth - 60;
}

- (void)setDialog:(LECourseLessonLEIRolePlayDialog *)dialog {
    _dialog = dialog;
    if (self.script >= [self.dialog.helpscripts count]) {
        self.conversionView.text = @"";
    } else {
        self.conversionView.text = [self.dialog.helpscripts objectAtIndex:self.script];
    }
    self.videoPlayPath = [LECourseLessonSectionItemView pathForAsset:self.dialog.video];
    self.controllView.delegate = self;
    
    self.controllView.image = [self coverImage];
    
    CGFloat viewHeight = [self checkConversionHeight];
    self.conversionViewHeightConstraint.constant = viewHeight;
}

- (CGFloat)checkConversionHeight {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat viewWidth = screenRect.size.width - self.conversionViewLeadingConstraint.constant - self.conversionViewTrailingConstraint.constant;
    return [self.conversionView heightForViewWidth:viewWidth];
}

- (CGFloat)heightForView {
    CGFloat viewHeight = [self checkConversionHeight];
    return self.statusViewTopConstraint.constant + self.statusViewHeightConstraint.constant + self.statusViewSpacingConstraint.constant + viewHeight + self.controlViewHeightConstraint.constant + self.controlViewSpacingConstraint.constant + 10;
}

//- (IBAction)clickProfileButton:(id)sender {
//    //    if ([self isAudioPlaying]) {
//    //        [self pauseAudioPlay];
//    //    } else if ([self isAudioPaused]){
//    //        [self resumeAudioPlay];
//    //    } else {
//    //        [self startAudioPlay];
//    //    }
//    if ([self hasAudioRecord] && ![self isAudioRecording]) {
//        if ([self isRecordPlaying]) {
//            [self pauseRecordPlay];
//        } else if ([self isRecordPlayPaused]){
//            [self resumeRecordPlay];
//        } else {
//            [self startRecordPlay];
//        }
//    } else {
//        if ([self isAudioRecording]) {
//            [self stopAudioRecord];
//        } else {
//            [self startAudioRecord];
//        }
//    }
//}

#pragma mark - Video Hooks

-(void)didVideoPlayLoaded:(UIView*)view {
    [self.controllView showVideoView:view];
    if (self.statusView.hidden == YES) {
        self.progressView.progress = 0;
        self.statusView.hidden = NO;
    }
}

-(void)didVideoPlayStart {
    //[self.controllView hidePlayButton];
    if ([self.delegate respondsToSelector:@selector(didSuportingViewPlayStart)]) {
        [self.delegate didSuportingViewPlayStart];
    }
}

-(void)willVideoPlayUnloaded:(UIView*)view {
    [self.controllView hideVideoView:view];
}

-(void)didVideoPlayStopped {
    //[self.controllView showPlayButton];
    if (self.statusView.hidden == NO) {
        self.statusView.hidden = YES;
    }
    if ([self.delegate respondsToSelector:@selector(didSuportingViewPlayFinish)]) {
        [self.delegate didSuportingViewPlayFinish];
    }
}

-(void)didVideoPlayPaused {
    //[self.controllView showPlayButton];
}

-(void)didVideoPlayResumed {
    [self.controllView hidePlayButton];
}

-(void)didVideoPlayUpdate:(CGFloat)percentage remainingTime:(NSTimeInterval)remainingTime {
    self.progressView.progress = percentage;
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
