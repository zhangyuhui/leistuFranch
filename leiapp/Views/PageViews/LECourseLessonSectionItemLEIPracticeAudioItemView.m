//
//  LECourseLessonSectionItemLEIPracticeAudioItemView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/21/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIPracticeAudioItemView.h"
#import "LEProgressImageButton.h"
#import "LEDefines.h"
@interface LECourseLessonSectionItemLEIPracticeAudioItemView ()
@property (strong, nonatomic) IBOutlet UIImageView *radioImageView;
@property (strong, nonatomic) IBOutlet UIImageView *checkboxImageView;
@property (strong, nonatomic) IBOutlet UIImageView *answerImageView;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet LEProgressImageButton *audioImageButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *audioPlayViewHeightConstraint;
@end

@implementation LECourseLessonSectionItemLEIPracticeAudioItemView

- (void)viewDidLoad {
    self.audioImageButton.image = [UIImage imageNamed:@"courselesson_sectionpageview_record_play_normal"];
    self.audioImageButton.highlightedImage = [UIImage imageNamed:@"courselesson_sectionpageview_record_pause_highlight"];
    [self.audioImageButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = COLORWHITESELECT.CGColor;
    _playing = NO;
}

- (void)willRemoveSubview:(UIView *)subview {
    [self.audioImageButton removeObserver:self forKeyPath:@"selected"];
    [super willRemoveSubview:subview];
}

-(void)setChecked:(BOOL)checked {
    [super setChecked:checked];
    self.textLabel.highlighted = checked;
    if (self.multiple) {
        self.checkboxImageView.highlighted = checked;
    } else {
        self.radioImageView.highlighted = checked;
    }
}

-(void)setMultiple:(BOOL)multiple{
    if (multiple) {
        self.checkboxImageView.hidden = NO;
        self.radioImageView.hidden = YES;
    } else {
        self.checkboxImageView.hidden = YES;
        self.radioImageView.hidden = NO;
    }
    [super setMultiple:multiple];
}

-(void)setAnswer:(LECourseLessonSectionItemLEIPracticeAnswer)answer {
    if (answer == LECourseLessonSectionItemLEIPracticeAnswerCorrect ||
        answer == LECourseLessonSectionItemLEIPracticeAnswerWrong ||
        answer == LECourseLessonSectionItemLEIPracticeAnswerMiss) {
        self.checkboxImageView.hidden = YES;
        self.radioImageView.hidden = YES;
        self.answerImageView.hidden = NO;
    }
    if (answer == LECourseLessonSectionItemLEIPracticeAnswerCorrect){
        [self.answerImageView setImage:[UIImage imageNamed:@"courselesson_sectionpageview_checkbox_correct"]];
    }
    if (answer == LECourseLessonSectionItemLEIPracticeAnswerWrong){
        [self.answerImageView setImage:[UIImage imageNamed:@"courselesson_sectionpageview_checkbox_wrong"]];
    }
    if (answer == LECourseLessonSectionItemLEIPracticeAnswerMiss){
        [self.answerImageView setImage:[UIImage imageNamed:@"courselesson_sectionpageview_checkbox_missed"]];
    }
    [super setAnswer:answer];
}

-(void)setAudio:(NSString *)audio {
    _audio = audio;
    self.audioPlayPath = self.audio;
}

-(CGFloat)heightForView {
    return self.audioPlayViewHeightConstraint.constant;
}


#pragma mark LEAudioCustomView Hooks
-(void)didAudioPlayStart {
    self.playing = YES;
}

-(void)didAudioPlayStopped {
    self.audioImageButton.selected = NO;
    self.playing = NO;
}

-(void)didAudioPlayUpdate:(CGFloat)percentage remainingTime:(NSTimeInterval)remainingTime{
    
}

# pragma mark Observers
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"selected"]) {
        if (self.audioImageButton.selected) {
            [self startAudioPlay];
        } else {
            [self stopAudioPlay];
        }
    }
}

@end
