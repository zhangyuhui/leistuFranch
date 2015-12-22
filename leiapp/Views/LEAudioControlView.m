//
//  LEAudioControlView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/4/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEAudioControlView.h"

@interface LEAudioControlView()

@property (strong, nonatomic) IBOutlet UIView *progressBackground;

@end


@implementation LEAudioControlView

- (void)viewDidLoad {
    self.playButton.layer.cornerRadius = 18;
    self.playButton.layer.borderWidth = 1;
    self.playButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.progressBackground.layer.cornerRadius = 10;
    self.progressBackground.layer.borderWidth = 1;
    self.progressBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
}
@end
