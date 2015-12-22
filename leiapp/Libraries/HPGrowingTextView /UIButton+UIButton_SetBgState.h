//
//  UIButton+UIButton_SetBgState.h
//  LeiTeacherClient
//
//  Created by Rambo on 15/7/16.
//  Copyright (c) 2015年 U-Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UIButton_SetBgState)
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
+ (UIImage *)imageWithColor:(UIColor *)color ;
@end
