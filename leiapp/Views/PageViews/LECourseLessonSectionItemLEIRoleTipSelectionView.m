//
//  LECourseLessonSectionItemLEIRoleTipSelectionView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/10/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIRoleTipSelectionView.h"
#import "LEDefines.h"
#import "UIImage+ImageWithColor.h"

@interface LECourseLessonSectionItemLEIRoleTipSelectionView ()
@property (strong, nonatomic) IBOutlet UIButton* fullTipButton;
@property (strong, nonatomic) IBOutlet UIButton* partialTipButton;
@property (strong, nonatomic) IBOutlet UIButton* noneTipButton;
@end

@implementation LECourseLessonSectionItemLEIRoleTipSelectionView

- (void)viewDidLoad {
    [self setupButton:self.fullTipButton];
    [self setupButton:self.partialTipButton];
    [self setupButton:self.noneTipButton];
}

- (void)setupButton:(UIButton*)button {
    UIImage *image= [UIImage imageWithColor:UIColorFromRGB(0xf7f7f7)];
    UIImage *imageHighlight = [UIImage imageWithColor:UIColorFromRGB(0xd7d7d7)];
    
    button.layer.borderColor = UIColorFromRGB(0xd7d7d7).CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 5;
    button.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:imageHighlight forState:UIControlStateHighlighted];
}

- (void)setType:(LERoleTipType)type {
    if (_type != type) {
        _type = type;
        switch (self.type) {
            case LERoleTipTypeFull:
                self.fullTipButton.highlighted = YES;
                self.partialTipButton.highlighted = NO;
                self.noneTipButton.highlighted = NO;
                break;
            case LERoleTipTypePartial:
                self.fullTipButton.highlighted = NO;
                self.partialTipButton.highlighted = YES;
                self.noneTipButton.highlighted = NO;
                break;
            case LERoleTipTypeNone:
                self.fullTipButton.highlighted = NO;
                self.partialTipButton.highlighted = NO;
                self.noneTipButton.highlighted = YES;
                break;
            default:
                break;
        }
    }
}

- (IBAction)clickRoleButton: (id)sender {
    if (sender == self.fullTipButton) {
        self.type = LERoleTipTypeFull;
    }else if (sender == self.partialTipButton) {
        self.type = LERoleTipTypePartial;
    }else if (sender == self.noneTipButton) {
        self.type = LERoleTipTypeNone;
    }
}

@end
