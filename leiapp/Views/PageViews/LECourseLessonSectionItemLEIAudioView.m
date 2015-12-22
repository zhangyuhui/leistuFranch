//
//  LECourseLessonSectionItemLEIAudioView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/2/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIAudioView.h"
#import "LECourseLessonSectionItemView.h"
#import "LEAudioControlView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LEConstants.h"
#import "NSString+Addition.h"
#import <AVFoundation/AVFoundation.h>

#define kScriptButtonWidthConst 40

@interface LECourseLessonSectionItemLEIAudioView()

@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet LEAudioControlView* audioControlView;
@property (strong, nonatomic) IBOutlet UIButton *scriptButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *coverImageViewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *coverImageViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *audioControlHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scriptButtonWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *transcripViewLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *transcripViewTrailingConstraint;

@end

@implementation LECourseLessonSectionItemLEIAudioView

- (instancetype)initWithLEIAudioItem:(LECourseLessonLEIAudioItem*)item {
    self = [super initWithItem:item];
    if (self){
        
    }
    return self;
}

- (void)didSetupSubViews {
    self.scriptButton.layer.cornerRadius = 10;
    self.scriptButton.layer.borderWidth = 1;
    self.scriptButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    LECourseLessonLEIAudioItem* item = (LECourseLessonLEIAudioItem*)self.item;
    
    self.audioPlayPath = [LECourseLessonSectionItemView pathForAsset:item.audio];
    
    if (item.cover) {
        self.coverImageView.image = [UIImage imageWithContentsOfFile:[LECourseLessonSectionItemView pathForAsset:item.cover]];
    } else {
        self.coverImageViewHeightConstraint.constant = 0.0;
        self.coverImageView.hidden = YES;
    }
    
    [self.audioControlView.playButton addTarget:self action:@selector(clickAudioPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([NSString stringIsNilOrEmpty:item.transcript]) {
        self.scriptButton.hidden = YES;
        self.scriptButtonWidthConstraint.constant = 0.0;
    }
    
    [self.audioControlView.playButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)willDestroySubViews {
    [self.audioControlView.playButton removeObserver:self forKeyPath:@"selected"];
}

- (CGFloat)heightForItem {
    return self.coverImageViewTopConstraint.constant + self.coverImageViewHeightConstraint.constant + self.audioControlHeightConstraint.constant + 5;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake([self widthForItem], [self heightForItem]);
}

-(IBAction)clickAudioPlayButton:(id)sender {
    if ([self isAudioPlaying]) {
        [self pauseAudioPlay];
    } else if ([self isAudioPaused]) {
        [self resumeAudioPlay];
    } else {
        [self startAudioPlay];
    }
}

-(IBAction)clickTranscriptButton:(id)sender {
    LECourseLessonLEIAudioItem* item = (LECourseLessonLEIAudioItem*)self.item;
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:item.transcript, @"transcript", nil];
    [notification postNotificationName:kLENotificationCourseStudyShowTranscript object:nil userInfo:userInfo];
}

-(void)didAudioPlayStart {
    self.audioControlView.playButton.selected = YES;
}

-(void)didAudioPlayStopped {
    self.audioControlView.playButton.selected = NO;
}

-(void)didAudioPlayPaused {
    self.audioControlView.playButton.selected = NO;
}

-(void)didAudioPlayResumed {
    self.audioControlView.playButton.selected = YES;
}

-(void)didAudioPlayUpdate:(CGFloat)percentage remainingTime:(NSTimeInterval)remainingTime {
    int hours = remainingTime/60;
    int minutes = remainingTime - hours*60;
    self.audioControlView.progressView.progress = percentage;
    self.audioControlView.durationLabel.text = [NSString stringWithFormat:@"-%02d:%02d", hours, minutes];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"selected"]) {
        if (self.audioControlView.playButton.selected) {
            [self.audioControlView.playButton setBackgroundImage:[UIImage imageNamed:@"courselesson_sectionpageview_audio_pause_normal"] forState:UIControlStateNormal];
        } else {
            [self.audioControlView.playButton setBackgroundImage:[UIImage imageNamed:@"courselesson_sectionpageview_audio_play_normal"] forState:UIControlStateNormal];
        }
    }
}

@end
