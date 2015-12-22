//
//  LEAudioControlView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/4/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECustomView.h"

@interface LEAudioControlView : LECustomView

@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;

@end
