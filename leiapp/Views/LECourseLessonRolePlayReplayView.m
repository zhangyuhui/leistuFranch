//
//  LECourseLessonRolePlayReplayView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/15/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonRolePlayReplayView.h"
#import "LECourseLessonSectionItemView.h"
#import "LEDotProgressView.h"
#import "LEDefines.h"
#import "NSString+Addition.h"

@interface LECourseLessonRolePlayReplayView ()
@property (nonatomic, strong) IBOutlet LEDotProgressView* progressView;
@property (nonatomic, strong) IBOutlet UIButton* profileButton;
@property (nonatomic, strong) IBOutlet UILabel* profileLabel;
@end

@implementation LECourseLessonRolePlayReplayView

- (void)viewDidLoad {
    self.progressView.progress = 0.5;
    
    self.profileButton.layer.cornerRadius = 35;
    self.profileButton.layer.borderColor = UIColorFromRGB(0xe8c395).CGColor;
    self.profileButton.layer.borderWidth = 2.0;
    self.profileButton.layer.masksToBounds = YES;
}

- (void)setDialog:(LECourseLessonLEIRolePlayDialog *)dialog {
    _dialog = dialog;
    self.audioPlayPath = [LECourseLessonSectionItemView pathForAsset:self.dialog.video];
    self.audioRecordPath = [LECourseLessonSectionItemView pathForAsset:self.dialog.record];
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

#pragma Audio Hooks

-(void)didAudioPlayStart {
    if ([self.delegate respondsToSelector:@selector(didReplayViewPlayStart)]) {
        [self.delegate didReplayViewPlayStart];
    }
}

-(void)didAudioPlayStopped {
    if ([self.delegate respondsToSelector:@selector(didReplayViewPlayFinish)]) {
        [self.delegate didReplayViewPlayFinish];
    }
}

-(void)didAudioPlayUpdate:(CGFloat)percentage remainingTime:(NSTimeInterval)remainingTime {
    self.progressView.progress = percentage;
}

-(void)didRecordPlayStart {
    if ([self.delegate respondsToSelector:@selector(didReplayViewPlayStart)]) {
        [self.delegate didReplayViewPlayStart];
    }
}

-(void)didRecordPlayStopped {
    if ([self.delegate respondsToSelector:@selector(didReplayViewPlayFinish)]) {
        [self.delegate didReplayViewPlayFinish];
    }
}

-(void)didRecordPlayUpdate:(CGFloat)percentage {
    self.progressView.progress = percentage;
}
@end
