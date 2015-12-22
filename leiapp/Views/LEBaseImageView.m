//
//  LETransitionImageView.m
//  leiapp
//
//  Created by Yuhui Zhang on 9/2/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseImageView.h"

@implementation LEBaseImageView

- (void)setImage:(UIImage *)image {
    [super setImage:image];
    
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [animation setDuration:0.5];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:animation forKey:@"setImage"];
}

@end
