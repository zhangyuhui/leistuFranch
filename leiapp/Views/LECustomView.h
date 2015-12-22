//
//  LECustomView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/17/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LECustomView : UIView
@property (nonatomic, strong) UIView *containerView;

- (void)viewDidLoad;
- (void)viewWillUnLoad;
@end
