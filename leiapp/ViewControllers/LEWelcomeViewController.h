//
//  WelcomeView.h
//  LeiTeacherClient
//
//  Created by Rambo on 15/7/25.
//  Copyright (c) 2015年 U-Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Login)();//重新定义了一个名字
@interface LEWelcomeViewController : UIViewController
{
    UIScrollView *scrollsView;
    UIPageControl *pageControl;
}
@property (nonatomic, strong)Login loginBlock;
@end
