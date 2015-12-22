//
//  LEVideoControlView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/10/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECustomView.h"

@class LEVideoControlView;

@protocol LEVideoControlViewDelegate <NSObject>
@optional
- (void)controlView:(LEVideoControlView*)controlView didClickPlayButton:(UIButton*)button;
- (void)controlView:(LEVideoControlView*)controlView didTapCanvasView:(UIView*)canvas;
@end

@interface LEVideoControlView : LECustomView
@property (assign, nonatomic) id<LEVideoControlViewDelegate> delegate;
@property (strong, nonatomic) NSString *cover;
@property (strong, nonatomic) UIImage *image;

- (void)showPlayButton;
- (void)hidePlayButton;

- (void)showVideoView:(UIView*)view;
- (void)hideVideoView:(UIView*)view;
@end
