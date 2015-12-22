//
//  LEPraciceCheckerView.m
//  leiappv2
//
//  Created by Ulearning on 15/12/2.
//  Copyright © 2015年 Yuhui Zhang. All rights reserved.
//

#import "LEPraciceCheckerView.h"
#import "LEDefines.h"
@implementation LEPraciceCheckerView
//黄色是1  红色是0
-(id)initWithType:(int)type Delegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = COLORMAIN;
        _delegate = delegate;
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(50*ScreenWidth/320, (SCREEN_HEIGHT/2-155), 220*ScreenWidth/320 , 305*ScreenWidth/320)];
        contentView.backgroundColor = COLORBACKGROUD;
        CGRect lsframe =contentView.frame;
        lsframe.origin.x = 0;
        lsframe.origin.y = 0;
        lsframe.size.height = 50*ScreenWidth/320;
        UILabel *titlelabel = [[UILabel alloc]initWithFrame:lsframe];
        titlelabel.text = @"页面还没学完";
        titlelabel.textAlignment = NSTextAlignmentCenter;
        titlelabel.font = [UIFont systemFontOfSize:20];
        titlelabel.textColor = COLORTITEL;
        lsframe.origin.y +=lsframe.size.height;
        lsframe.size.height = 155*ScreenWidth/320;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:lsframe];
        imageView.image = type?[UIImage imageNamed:@"tip_undone_orange"]:[UIImage imageNamed:@"tip_undone_red"];
//        imageView.contentMode=UIViewContentModeCenter;
        lsframe.origin.y +=lsframe.size.height;
        lsframe.size.height = 48*ScreenWidth/320;
        UIButton * button1 = [[UIButton alloc]initWithFrame:lsframe];
        [button1 setTitle:@"艾玛~回去学" forState:UIControlStateNormal];
        [button1 setTitle:@"艾玛~回去学" forState:UIControlStateHighlighted];
        [button1 setTitleColor:COLORTITEL forState:UIControlStateNormal];
        [button1 setTitleColor:COLORWHITESELECT forState:UIControlStateHighlighted];
        [button1 addTarget:self action:@selector(buttonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button1.tag = 1;
        lsframe.origin.y +=lsframe.size.height;
        lsframe.size.height = 1;
        UILabel *labelline = [[UILabel alloc]initWithFrame:lsframe];
        labelline.backgroundColor = COLORLINE;
        lsframe.origin.y +=lsframe.size.height;
        lsframe.size.height = 48*ScreenWidth/320;
        UIButton * button2 = [[UIButton alloc]initWithFrame:lsframe];
        [button2 setTitle:@"我要离开" forState:UIControlStateNormal];
        [button2 setTitle:@"我要离开" forState:UIControlStateHighlighted];
        [button2 setTitleColor:COLORTITEL forState:UIControlStateNormal];
        [button2 setTitleColor:COLORWHITESELECT forState:UIControlStateHighlighted];
        [button2 addTarget:self action:@selector(buttonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button2.tag = 2;
        [contentView addSubview:titlelabel];
        [contentView addSubview:imageView];
        [contentView addSubview:button1];
        [contentView addSubview:button2];
        [contentView addSubview:labelline];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
        [self addSubview:contentView];
        contentView.layer.cornerRadius = 5;
        contentView.clipsToBounds = YES;
    }
    
    return self;
}
-(void)show{
//    UIViewController *vc = (UIViewController *)_delegate;
//    [vc.view addSubview:self];
    UIWindow *  window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
-(void)buttonOnClicked:(id)sender{
    if (_delegate&&[_delegate respondsToSelector:@selector(alertView: clickedButtonAtIndex:)]) {
        [_delegate alertView:self clickedButtonAtIndex:[sender tag]];
    }
    [self removeFromSuperview];
}

@end
