//
//  UIButton+UIButton_SetBgState.m
//  LeiTeacherClient
//
//  Created by Rambo on 15/7/16.
//  Copyright (c) 2015年 U-Learning. All rights reserved.
//

#import "UIButton+UIButton_SetBgState.h"

@implementation UIButton (UIButton_SetBgState)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    self.clipsToBounds = YES;
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
