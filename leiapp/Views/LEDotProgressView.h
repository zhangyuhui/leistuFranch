//
//  LEDotProgressView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/11/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEDotProgressView : UIView
@property (assign, nonatomic) CGFloat progress;
@property (strong, nonatomic) UIColor *filledColor;
@property (strong, nonatomic) UIColor *unfilledColor;
@end
