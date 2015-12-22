//
//  LECourseLessonRolePlayLeadingView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/11/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonRolePlayLeadingView.h"
#import "LEDotProgressView.h"
#import "LECourseLessonSectionItemView.h"
#import "LEConversionView.h"
#import "LECourseLessonSectionItemView.h"
#import "LEDefines.h"
#import "NSString+Addition.h"

@interface LECourseLessonRolePlayLeadingView ()
@property (nonatomic, strong) IBOutlet UIView* statusView;
@property (nonatomic, strong) IBOutlet LEDotProgressView* progressView;
@property (nonatomic, strong) IBOutlet UILabel* statusLabel;
@property (nonatomic, strong) IBOutlet UIView* indicatorView;
@property (nonatomic, strong) IBOutlet LEConversionView* conversionView;
@property (nonatomic, strong) IBOutlet UIButton* profileButton;
@property (nonatomic, strong) IBOutlet UILabel* profileLabel;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint* conversionViewLeadingConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* conversionViewTrailingConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* conversionViewHeightConstraint;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint* statusViewTopConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* statusViewHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* statusViewSpacingConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* profileViewHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* profileViewSpacingConstraint;
@end

@implementation LECourseLessonRolePlayLeadingView

- (void)viewDidLoad {
    self.progressView.progress = 0.5;
    self.conversionView.text = @"";
    
    self.profileButton.layer.cornerRadius = 25;
    self.profileButton.layer.borderColor = UIColorFromRGB(0xe8c395).CGColor;
    self.profileButton.layer.borderWidth = 2.0;
    
    self.profileButton.layer.masksToBounds = YES;
    
    CGFloat viewHeight = [self checkConversionHeight];
    self.conversionViewHeightConstraint.constant = viewHeight;
}

- (void)setDialog:(LECourseLessonLEIRolePlayDialog *)dialog {
    _dialog = dialog;
    if (self.script >= [self.dialog.helpscripts count]) {
        self.conversionView.text = @"";
    } else {
        self.conversionView.text = [self.dialog.helpscripts objectAtIndex:self.script];
    }
    self.audioPlayPath = [LECourseLessonSectionItemView pathForAsset:self.dialog.video];
    if (!self.dialog.record || [self.dialog.record isEmptyOrWhitespace]) {
        self.dialog.record = [LECourseLessonSectionItemView generateAudioPath];
    }
    self.audioRecordPath = [LECourseLessonSectionItemView pathForAsset:self.dialog.record];
    self.audioRecordDuration = self.dialog.duration;
    
    CGFloat viewHeight = [self checkConversionHeight];
    self.conversionViewHeightConstraint.constant = viewHeight;
}

- (void)setImage:(NSString *)image {
    _image = image;
    
    UIImage* object = [UIImage imageWithContentsOfFile:[LECourseLessonSectionItemView pathForAsset:image]];
    [self.profileButton setBackgroundImage:object forState:UIControlStateNormal];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.profileLabel.text = name;
}

- (CGFloat)checkConversionHeight {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat viewWidth = screenRect.size.width - self.conversionViewLeadingConstraint.constant - self.conversionViewTrailingConstraint.constant;
    return [self.conversionView heightForViewWidth:viewWidth];
}

- (CGFloat)heightForView {
    CGFloat viewHeight = [self checkConversionHeight];
    return self.statusViewTopConstraint.constant + self.statusViewHeightConstraint.constant + self.statusViewSpacingConstraint.constant + viewHeight + self.profileViewHeightConstraint.constant + self.profileViewSpacingConstraint.constant + 10;
}

- (IBAction)clickProfileButton:(id)sender {
//    if ([self isAudioPlaying]) {
//        [self pauseAudioPlay];
//    } else if ([self isAudioPaused]){
//        [self resumeAudioPlay];
//    } else {
//        [self startAudioPlay];
//    }
    if ([self hasAudioRecord] && ![self isAudioRecording]) {
        if ([self isRecordPlaying]) {
            [self pauseRecordPlay];
        } else if ([self isRecordPlayPaused]){
            [self resumeRecordPlay];
        } else {
           [self startRecordPlay];
        }
    } else {
        if ([self isAudioRecording]) {
            [self stopAudioRecord];
        } else {
            [self startAudioRecord];
        }
    }
}

#pragma Audio Hooks

-(void)didAudioPlayStart {
    if (self.statusView.hidden == YES) {
        self.statusLabel.text = @"播放中";
        self.progressView.progress = 0;
        self.statusView.hidden = NO;
    }
}

-(void)didAudioPlayStopped {
    if (self.statusView.hidden == NO) {
        self.statusView.hidden = YES;
    }
}

-(void)didAudioPlayPaused {
    self.statusLabel.text = @"暂停中";
}

-(void)didAudioPlayResumed {
    self.statusLabel.text = @"播放中";
}

-(void)didAudioPlayUpdate:(CGFloat)percentage remainingTime:(NSTimeInterval)remainingTime {
    self.progressView.progress = percentage;
}

-(void)didRecordPlayStart {
    if (self.statusView.hidden == YES) {
        self.statusLabel.text = @"播放中";
        self.progressView.progress = 0;
        self.statusView.hidden = NO;
    }
}

-(void)didRecordPlayStopped {
    if (self.statusView.hidden == NO) {
        self.statusView.hidden = YES;
    }
}

-(void)didRecordPlayPaused {
    self.statusLabel.text = @"暂停中";
}

-(void)didRecordPlayResumed {
    self.statusLabel.text = @"播放中";
}

-(void)didRecordPlayUpdate:(CGFloat)percentage {
    self.progressView.progress = percentage;
}

-(void)didAudioRecordStart {
    if (self.statusView.hidden == YES) {
        self.statusLabel.text = @"录音中";
        self.progressView.progress = 0;
        self.statusView.hidden = NO;
        if ([self.delegate respondsToSelector:@selector(didLeadingViewRecordStart)]) {
            [self.delegate didLeadingViewRecordStart];
        }
    }
}

-(void)didAudioRecordStopped {
    if (self.statusView.hidden == NO) {
        self.statusView.hidden = YES;
        [self.statusLabel.layer removeAllAnimations];
        [self.indicatorView.layer removeAllAnimations];
        [self.statusLabel setAlpha:1.0];
        [self.indicatorView setAlpha:1.0];
        if ([self.delegate respondsToSelector:@selector(didLeadingViewRecordFinish)]) {
            [self.delegate didLeadingViewRecordFinish];
        }
    }
}

- (void)didAudioRecordWarned {
    [UIView animateWithDuration:0.5 delay:0.0
                        options:(UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse)
                     animations:^{
                         [self.statusLabel setAlpha:0.2];
                         [self.indicatorView setAlpha:0.2];
                     }
                     completion:nil];
}

-(void)didAudioRecordUpdate:(CGFloat)percentage {
    self.progressView.progress = percentage;
}

@end
