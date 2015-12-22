//
//  GuideView.m
//  leiappv2
//
//  Created by Ulearning on 15/12/11.
//  Copyright © 2015年 Yuhui Zhang. All rights reserved.
//

#import "GuideView.h"
#import "LEDefines.h"
@implementation GuideView
//type 1:聊天 2：课程主页 3：单元页的pageControl 4：单元页的同步学习记录
-(id)initType:(int)type{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self) {
        
        NSString *imagename = [NSString stringWithFormat:@"user_guide_%@_0%d",[self phoneType],type];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:self.frame];
        imageview.image = [UIImage imageNamed:imagename];
        [self addSubview:imageview];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removefromsubView)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(NSString *)phoneType
{
    if (IS_IPHONE_6P) {
        return @"6P";
    }else if (IS_IPHONE_6) {
        return @"6";
    }else if (IS_IPHONE_5) {
        return @"5S";
    }else if (IS_IPHONE_4_OR_LESS) {
        return @"4S";
    }else {
        return @"IPAD";
    }
}
-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
-(void)removefromsubView{
    [self removeFromSuperview];
}
@end
