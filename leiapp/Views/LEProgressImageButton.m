//
//  LEProgressImageButton.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEProgressImageButton.h"
#import "MCPercentageDoughnutView.h"
#import "LEDefines.h"

@interface LEProgressImageButton()
@property (strong, nonatomic) IBOutlet MCPercentageDoughnutView *doughnutView;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@end

@implementation LEProgressImageButton

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.doughnutView.percentage = _progress;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self.imageButton setImage:_image forState:UIControlStateNormal];
}

- (void)setHighlightedImage:(UIImage *)highlightedImage {
    _highlightedImage = highlightedImage;
    //[self.imageButton setImage:_highlightedImage forState:UIControlStateHighlighted];
    [self.imageButton setImage:_highlightedImage forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
        
        [UIView transitionWithView:self.imageButton
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{ self.imageButton.selected = selected; }
                        completion:nil];
        
        if (!selected) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
                self.doughnutView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.doughnutView.animationEnabled = NO;
                self.doughnutView.percentage = 0.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    self.doughnutView.alpha = 1.0;
                    self.doughnutView.animationEnabled = YES;
                });
            }];
        }
    }
}

- (void)setDisabled:(BOOL)disabled {
    if (_disabled != disabled) {
        _disabled = disabled;
        [UIView transitionWithView:self.imageButton
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{ self.imageButton.enabled = !_disabled; }
                        completion:nil];
    }
}

- (void)viewDidLoad {
    self.doughnutView.percentage = 0;
    self.doughnutView.showTextLabel = NO;
    self.doughnutView.unfillColor = [UIColor clearColor];
    self.doughnutView.fillColor = UIColorFromRGB(0x37d162);
}

- (IBAction)clickImageButton:(id)sender {
    self.selected = !self.selected;
}

@end
