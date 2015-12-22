//
//  LETabMenuView.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/31/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LETabMenuView.h"

@interface LETabMenuView ()
@property (strong, nonatomic) UIButton *currentButton;
@end

@implementation LETabMenuView
@synthesize delegate;
@synthesize leftMenuLabel = _leftMenuLabel;
@synthesize rightMenuLabel = _rightMenuLabel;
@synthesize middleMenuLabel = _middleMenuLabel;

- (void)didLoadView {
    self.currentButton = self.leftMenuButton;
}

-(void)setLeftMenuLabel:(NSString *)leftMenuLabel {
    _leftMenuLabel = leftMenuLabel;
    
    [self.leftMenuButton setTitle:leftMenuLabel forState:UIControlStateNormal];
    [self.leftMenuButton setTitle:leftMenuLabel forState:UIControlStateHighlighted];
    [self.leftMenuButton setTitle:leftMenuLabel forState:UIControlStateSelected];
}

-(void)setRightMenuLabel:(NSString *)rightMenuLabel {
    _rightMenuLabel = rightMenuLabel;
    
    [self.rightMenuButton setTitle:rightMenuLabel forState:UIControlStateNormal];
    [self.rightMenuButton setTitle:rightMenuLabel forState:UIControlStateHighlighted];
    [self.rightMenuButton setTitle:rightMenuLabel forState:UIControlStateSelected];
}

-(void)setMiddleMenuLabel:(NSString *)middleMenuLabel {
    _middleMenuLabel = middleMenuLabel;
    
    [self.middleMenuButton setTitle:middleMenuLabel forState:UIControlStateNormal];
    [self.middleMenuButton setTitle:middleMenuLabel forState:UIControlStateHighlighted];
    [self.middleMenuButton setTitle:middleMenuLabel forState:UIControlStateSelected];
}


-(IBAction)clickMenuButton:(id)sender {
    if (self.currentButton == sender) {
        return;
    }
    
    NSInteger from = self.currentButton.tag;
    self.currentButton.selected = NO;
    self.currentButton = sender;
    self.currentButton.selected = YES;
    
    if ([(id)self.delegate respondsToSelector:@selector(tabMenuView:willSelectTab:from:)]) {
        [self.delegate tabMenuView:self willSelectTab:self.currentButton.tag from:from];
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = self.underscoreView.frame;
        frame.origin.x = self.currentButton.frame.origin.x;
        self.underscoreView.frame = frame;
    } completion:^(BOOL finished) {
        if ([(id)self.delegate respondsToSelector:@selector(tabMenuView:didSelectTab:from:)]) {
            [self.delegate tabMenuView:self didSelectTab:self.currentButton.tag from:from];
        }
    }];
}
@end
