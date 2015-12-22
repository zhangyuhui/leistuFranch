//
//  LEBaseModalViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/5/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseModalViewController.h"

@interface LEBaseModalViewController ()

@end

@implementation LEBaseModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setImage:[UIImage imageNamed:@"navigation_cancel_normal"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"navigation_cancel_highlight"] forState:UIControlStateHighlighted];
    [cancelButton setImage:[UIImage imageNamed:@"navigation_cancel_highlight"] forState:UIControlStateSelected];
    
    [self setLeftBarButtonItems:[NSArray arrayWithObject:cancelButton]];
    
}

-(void)clickCancelButton {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
