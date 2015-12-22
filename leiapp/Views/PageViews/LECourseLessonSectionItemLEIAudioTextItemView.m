//
//  LECourseLessonSectionItemLEIAudioTextItemView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/4/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIAudioTextItemView.h"
#import "LECourseLessonSectionItemView.h"
#import "LEAudioControlView.h"
#import "RTLabel.h"
#import "NSString+Addition.h"

@interface LECourseLessonSectionItemLEIAudioTextItemView()

@property (strong, nonatomic) IBOutlet LEAudioControlView* audioControlView;
@property (strong, nonatomic) IBOutlet RTLabel *audioTextLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *controlHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraint;

@end

@implementation LECourseLessonSectionItemLEIAudioTextItemView

- (void)viewDidLoad {
    [self.audioControlView.playButton addTarget:self action:@selector(clickAudioPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.audioControlView.playButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillUnLoad {
    [self.audioControlView.playButton removeObserver:self forKeyPath:@"selected"];
}

- (void)setAudioText:(LECourseLessonLEIAudioText *)audioText {
    _audioText = audioText;
    
    self.audioPlayPath = [LECourseLessonSectionItemView pathForAsset:self.audioText.audio];
    self.audioTextLabel.textColor = [UIColor lightGrayColor];
    self.audioTextLabel.font = [UIFont italicSystemFontOfSize:16];
    self.audioTextLabel.text = [self.audioText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat labelWidth = screenWidth - self.leadingConstraint.constant - self.trailingConstraint.constant;
    
    CGRect labelFrame = self.audioTextLabel.frame;
    labelFrame.size.width = labelWidth;
    self.audioTextLabel.frame = labelFrame;
    
    CGSize labelSize = [self.audioTextLabel optimumSize];
    
    CGFloat labelHeight = labelSize.height;
    
    self.labelHeightConstraint.constant = labelHeight;
    
}

- (CGFloat)heightForView {
    return self.labelHeightConstraint.constant + self.labelTopConstraint.constant + self.controlHeightConstraint.constant + 10;
}

-(void)clickAudioPlayButton:(id)sender {
    if ([self isAudioPlaying]) {
        [self pauseAudioPlay];
    } else if ([self isAudioPaused]) {
        [self resumeAudioPlay];
    } else {
        [self startAudioPlay];
    }
}

- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
        if (!selected && ([self isAudioPaused] || [self isAudioPlaying])) {
            [self stopAudioPlay];
        }
    }
}

-(void)didAudioPlayStart {
    self.audioControlView.playButton.selected = YES;
    self.selected = YES;
}

-(void)didAudioPlayStopped {
    self.audioControlView.playButton.selected = NO;
    self.selected = NO;
    [self didAudioPlayUpdate:0.0 remainingTime:0];
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
    if (remainingTime > hours*60 + minutes && minutes == 0) {
        minutes = 1;
    }
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

