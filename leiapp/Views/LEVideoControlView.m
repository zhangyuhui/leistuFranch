//
//  LEVideoControlView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/10/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEVideoControlView.h"
#import "LEDefines.h"

@interface LEVideoControlView ()

@property (strong, nonatomic) IBOutlet UIView *videoCanvasView;
@property (strong, nonatomic) IBOutlet UIImageView *videoCoverView;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *videoCanvasViewLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *videoCanvasViewTrailingConstraint;
@end

@implementation LEVideoControlView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playButton.hidden = !self.userInteractionEnabled;
}

- (void)setCover:(NSString *)cover {
    _cover = cover;
    self.videoCoverView.image = [UIImage imageWithContentsOfFile:self.cover];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.videoCoverView.image = image;
}

- (IBAction)clickPlayButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(controlView:didClickPlayButton:)]) {
        [self.delegate controlView:self didClickPlayButton:self.playButton];
    }
}

- (void)showPlayButton {
    self.playButton.alpha = 0.0;
    self.playButton.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.playButton.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

- (void)hidePlayButton {
    [UIView animateWithDuration:0.3 animations:^{
        self.playButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.playButton.hidden = YES;
        self.playButton.alpha = 1.0;
    }];
}

- (void)showVideoView:(UIView*)view {
    CGRect frame = self.videoCanvasView.frame;
    view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self.videoCanvasView addSubview:view];
    [UIView animateWithDuration:0.3 animations:^{
        self.videoCanvasView.alpha = 1.0;
        self.videoCoverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.videoCoverView.hidden = YES;
        self.videoCoverView.alpha = 1.0;
    }];
}

- (void)hideVideoView:(UIView*)view {
    self.videoCoverView.alpha = 0.0;
    self.videoCoverView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.videoCoverView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

#pragma mark - Gesture Recognizer
- (IBAction)tapVideoCanvasView:(UIGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(controlView:didTapCanvasView:)]) {
        [self.delegate controlView:self didTapCanvasView:self.containerView];
    }
}
@end