//
//  LECourseLessonRolePlayViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/11/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonRolePlayViewController.h"
#import "LECourseLessonRolePlayLeadingView.h"
#import "LECourseLessonRolePlaySupportingView.h"
#import "LEPreferenceService.h"
#import "LECourseLessonRolePlayReplayView.h"
#import "LECourseLessonSectionItemView.h"
#import "RTLabel.h"
#import "LEConstants.h"
#define kAniamtionDuration 0.8

@interface LECourseLessonRolePlayViewController () <LECourseLessonRolePlayLeadingViewDelegate, LECourseLessonRolePlaySupportingViewDelegate, LECourseLessonRolePlayReplayViewDelegate>
@property (nonatomic, strong) IBOutlet LECourseLessonRolePlayLeadingView* audioView;
@property (nonatomic, strong) IBOutlet LECourseLessonRolePlaySupportingView* videoView;
@property (nonatomic, strong) IBOutlet RTLabel* scriptsLabel;
@property (nonatomic, strong) IBOutlet UILabel* startLabel;
@property (nonatomic, strong) IBOutlet UIView* buttonView;
@property (nonatomic, strong) IBOutlet UIButton* replayButton;
@property (nonatomic, strong) IBOutlet UIButton* quiteButton;
@property (nonatomic, strong) IBOutlet UIView* replayView;
@property (nonatomic, strong) IBOutlet LECourseLessonRolePlayReplayView* replayAudioView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* audioViewHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* videoViewHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* scriptsLabelHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* scriptsLabelLeadingConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* scriptsLabelTrailingConstraint;

@property (nonatomic, strong) LECourseLessonLEIRolePlayItem* rolePlayItem;
@property (nonatomic, assign) int rolePlayStep;
@property (nonatomic, assign) BOOL roleReplaying;
@property (nonatomic, assign) int startLabelNumber;
@property (nonatomic, strong) NSTimer* startLabelSetupTimer;
@property (nonatomic, strong) NSTimer* startLabelUpdateTimer;

@property (nonatomic, assign) BOOL destroyingPage;
@end

@implementation LECourseLessonRolePlayViewController

- (instancetype)initWithLEIRolePlayItem:(LECourseLessonLEIRolePlayItem*)item {
    self = [super initWithNibName:nil bundle:nil];
    if (self){
        _rolePlayItem = item;
        _rolePlayStep = 0;
        _roleReplaying = NO;
        _destroyingPage = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickCancelButton) name:kLENotificationApplicationWillResignActive object:nil];
    self.audioView.delegate = self;
    self.videoView.delegate = self;
    self.replayAudioView.delegate = self;
    
    self.scriptsLabel.font = [UIFont systemFontOfSize:18];
    self.scriptsLabel.textColor = [UIColor darkGrayColor];
    
    self.replayButton.layer.cornerRadius = 20;
    self.quiteButton.layer.cornerRadius = 20;
    
    
    self.startLabelSetupTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(setupStartLabelDislay:) userInfo:nil repeats:NO];
}

- (void)updateScriptsDisplay {
    NSMutableString* scripts = [[NSMutableString alloc] init];
    for(int i=0; i<= self.rolePlayStep; i++) {
        LECourseLessonLEIRolePlayDialog* dialog = [self.rolePlayItem.speakerDialogs objectAtIndex:i];
        NSString* name = [self.rolePlayItem.speakerNames objectAtIndex:i%2];
        NSString* transcript = dialog.transcript;
        [scripts appendString:[NSString stringWithFormat:@"<b>%@:</b> %@<br>", name, transcript]];
    }
    
    self.scriptsLabel.text = scripts;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat labelWidth = screenWidth - self.scriptsLabelLeadingConstraint.constant - self.scriptsLabelTrailingConstraint.constant;
    
    CGRect labelRect = [self.scriptsLabel.text boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:self.scriptsLabel.font} context:nil];
    
    CGFloat labelHeight = labelRect.size.height;
    self.scriptsLabelHeightConstraint.constant = labelHeight;
}

-(void)setupStartLabelDislay:(NSTimer *)timer {
    self.startLabelSetupTimer = nil;
    self.startLabelNumber = 3;
    self.startLabel.text = @"Ready?";
    self.startLabel.alpha = 0.0;
    [UIView animateWithDuration:1.5 animations:^{
        self.startLabel.alpha = 1.0;
    }];
    self.startLabelUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateStartLabelDislay:) userInfo:nil repeats:YES];
}

-(void)updateStartLabelDislay:(NSTimer *)timer {
    if (self.startLabelNumber <= 0) {
        [self.startLabelUpdateTimer invalidate];
        self.startLabelUpdateTimer = nil;
        [UIView animateWithDuration:0.5 animations:^{
            self.startLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.startLabel.hidden = YES;
            self.startLabel.alpha = 1.0;
            [self setupRolePlayViews];
        }];
    } else {
        self.startLabel.text = [NSString stringWithFormat:@"%d", self.startLabelNumber];
        self.startLabel.alpha = 0.0;
        [UIView animateWithDuration:1.0 animations:^{
            self.startLabel.alpha = 1.0;
        }];
        self.startLabelNumber -= 1;
    }
}

-(void)setupRolePlayViews {
    if  (self.rolePlayItem.speaker == 0) {
        self.audioView.script = self.rolePlayItem.selection;
        self.audioView.dialog = [self.rolePlayItem.speakerDialogs objectAtIndex:self.rolePlayStep];
        self.audioView.image = [self.rolePlayItem.speakerImages objectAtIndex:self.rolePlayItem.speaker];
        self.audioView.name = [self.rolePlayItem.speakerNames objectAtIndex:self.rolePlayItem.speaker];
        CGFloat audioViewHeight = [self.audioView heightForView];
        self.audioViewHeightConstraint.constant = audioViewHeight;
        
        self.audioView.alpha = 0.0;
        self.audioView.hidden = NO;
        [UIView animateWithDuration:kAniamtionDuration animations:^{
            self.audioView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.audioView startAudioRecord];
        }];
    } else {
        self.videoView.script = self.rolePlayItem.selection;
        self.videoView.dialog = [self.rolePlayItem.speakerDialogs objectAtIndex:self.rolePlayStep];
        CGFloat videoViewHeight = [self.videoView heightForView];
        self.videoViewHeightConstraint.constant = videoViewHeight;
        
        self.videoView.alpha = 0.0;
        self.videoView.hidden = NO;
        [UIView animateWithDuration:kAniamtionDuration animations:^{
            self.videoView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.videoView startVideoPlay];
        }];
    }
}

-(void)updateRolePlayViews {
    if (!self.destroyingPage) {
        [self updateScriptsDisplay];
        self.rolePlayStep += 1;
        if (self.rolePlayStep >= [self.rolePlayItem.speakerDialogs count]) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.buttonView.alpha = 0.0;
                self.buttonView.hidden = NO;
                [UIView animateWithDuration:kAniamtionDuration animations:^{
                    self.buttonView.alpha = 1.0;
                    self.scriptsLabel.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 70 - self.scriptsLabel.frame.origin.y);
                }];
            });
        } else {
            if  (self.rolePlayItem.speaker == (self.rolePlayStep % 2)) {
                self.audioView.script = self.rolePlayItem.selection;
                self.audioView.dialog = [self.rolePlayItem.speakerDialogs objectAtIndex:self.rolePlayStep];
                self.audioView.image = [self.rolePlayItem.speakerImages objectAtIndex:self.rolePlayItem.speaker];
                self.audioView.name = [self.rolePlayItem.speakerNames objectAtIndex:self.rolePlayItem.speaker];
                CGFloat audioViewHeight = [self.audioView heightForView];
                self.audioViewHeightConstraint.constant = audioViewHeight;
                
                self.audioView.alpha = 0.0;
                self.audioView.hidden = NO;
                [UIView animateWithDuration:kAniamtionDuration animations:^{
                    self.audioView.alpha = 1.0;
                } completion:^(BOOL finished) {
                    [self.audioView startAudioRecord];
                }];
            } else {
                self.videoView.script = self.rolePlayItem.selection;
                self.videoView.dialog = [self.rolePlayItem.speakerDialogs objectAtIndex:self.rolePlayStep];
                CGFloat videoViewHeight = [self.videoView heightForView];
                self.videoViewHeightConstraint.constant = videoViewHeight;
                
                self.videoView.alpha = 0.0;
                self.videoView.hidden = NO;
                [UIView animateWithDuration:kAniamtionDuration animations:^{
                    self.videoView.alpha = 1.0;
                } completion:^(BOOL finished) {
                    [self.videoView startVideoPlay];
                }];
            }
        }
    }
}

- (void)setupeRoleReplayView {
    self.rolePlayStep = 0;
    self.replayAudioView.dialog = [self.rolePlayItem.speakerDialogs objectAtIndex:self.rolePlayStep];
    self.replayAudioView.image = [self.rolePlayItem.speakerImages objectAtIndex:self.rolePlayItem.speaker];
    self.replayAudioView.name = [self.rolePlayItem.speakerNames objectAtIndex:self.rolePlayItem.speaker];
}

- (void)startRoleReplayView {
    if  (self.rolePlayItem.speaker == (self.rolePlayStep % 2)) {
        [self.replayAudioView startRecordPlay];
    } else {
        [self.replayAudioView startAudioPlay];
    }
}

- (void)updateRoleReplayView {
    if (!self.destroyingPage) {
        self.rolePlayStep += 1;
        if (self.rolePlayStep >= [self.rolePlayItem.speakerDialogs count]) {
            self.replayButton.alpha = 0.0;
            self.replayButton.hidden = NO;
            [UIView animateWithDuration:kAniamtionDuration animations:^{
                self.replayButton.alpha = 1.0;
                self.replayView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.replayView.hidden = YES;
                self.replayView.alpha = 1.0;
            }];
        } else {
            int speaker = self.rolePlayStep % 2;
            self.replayAudioView.dialog = [self.rolePlayItem.speakerDialogs objectAtIndex:self.rolePlayStep];
            self.replayAudioView.image = [self.rolePlayItem.speakerImages objectAtIndex:speaker];
            self.replayAudioView.name = [self.rolePlayItem.speakerNames objectAtIndex:speaker];
            
            if  (self.rolePlayItem.speaker == (self.rolePlayStep % 2)) {
                [self.replayAudioView startRecordPlay];
            } else {
                [self.replayAudioView startAudioPlay];
            }
        }
    }
}

#pragma mark LECourseLessonRolePlayLeadingViewDelegate
- (void)didLeadingViewRecordStart {
    
}

- (void)didLeadingViewRecordFinish {
    if (!self.destroyingPage) {
        [self updateRolePlayViews];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.audioView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.audioView.hidden = YES;
            self.audioView.alpha = 1.0;
        }];
    }
}

#pragma mark LECourseLessonRolePlaySupportingViewDelegate
- (void)didSuportingViewPlayStart {
    
}

- (void)didSuportingViewPlayFinish {
    if (!self.destroyingPage) {
        [self updateRolePlayViews];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.videoView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.videoView.hidden = YES;
            self.videoView.alpha = 1.0;
        }];
    }
}

#pragma mark LECourseLessonRolePlayReplayViewDelegate
- (void)didReplayViewPlayStart {
    
}

- (void)didReplayViewPlayFinish {
    if (!self.destroyingPage) {
        [self updateRoleReplayView];
    }
}

#pragma mark Actions
- (IBAction)clickReplayButton:(id)sender {
    self.rolePlayStep = 0;
    [self setupeRoleReplayView];
    
    self.replayView.alpha = 0.0;
    self.replayView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.replayButton.alpha = 0.0;
        self.replayView.alpha = 1.0;
        self.scriptsLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.replayButton.hidden = YES;
        self.replayButton.alpha = 1.0;
        self.replayAudioView.alpha = 1.0;
        self.scriptsLabel.hidden = YES;
        self.scriptsLabel.alpha = 1.0;
        [self startRoleReplayView];
    }];
}

- (IBAction)clickRetryButton:(id)sender {
    [self clickCancelButton];
}

- (void)clickCancelButton {
    self.destroyingPage = YES;
    [self.audioView stopRecordPlay];
    [self.audioView stopAudioRecord];
    [self.videoView stopVideoPlay];
    [self.replayAudioView stopAudioPlay];
    
    [self.rolePlayItem.speakerDialogs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *  stop) {
        LECourseLessonLEIRolePlayDialog* dialog = obj;
        [LECourseLessonSectionItemView destroyAssetPath:dialog.record];
        dialog.record = nil;
    }];
    
    
    if (self.startLabelSetupTimer) {
        [self.startLabelSetupTimer invalidate];
        self.startLabelSetupTimer = nil;
    }
    if (self.startLabelUpdateTimer) {
        [self.startLabelUpdateTimer invalidate];
        self.startLabelUpdateTimer = nil;
    }
    [super clickCancelButton];
}


@end
