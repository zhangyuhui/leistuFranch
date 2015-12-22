//
//  WelcomeView.m
//  LeiTeacherClient
//
//  Created by Rambo on 15/7/25.
//  Copyright (c) 2015年 U-Learning. All rights reserved.
//

#import "LEWelcomeViewController.h"
#import "LEDefines.h"
#import "UIButton+UIButton_SetBgState.h"
#import "MKMessage.h"
@interface LEWelcomeViewController()<UIScrollViewDelegate>
{
    UIView *view1;
    UIView *view2;
    UIView *view3;
    UIView *view4;
}
@end
@implementation LEWelcomeViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    nav.backgroundColor = COLORBACKGROUD;
    [self.view addSubview:nav];
    scrollsView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , SCREEN_HEIGHT)];
    scrollsView.delegate = self;
    //设置背景颜色
    scrollsView.backgroundColor = [UIColor clearColor];
    //设置取消触摸
    scrollsView.canCancelContentTouches = NO;
    //设置滚动条类型
    scrollsView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    //是否自动裁切超出部分
    scrollsView.clipsToBounds = YES;
    //设置是否可以缩放
    scrollsView.scrollEnabled = YES;
    //设置是否可以进行画面切换
    scrollsView.pagingEnabled = YES;
    //设置在拖拽的时候是否锁定其在水平或者垂直的方向
    scrollsView.directionalLockEnabled = NO;
    //隐藏滚动条设置（水平、跟垂直方向）
    scrollsView.alwaysBounceHorizontal = NO;
    scrollsView.alwaysBounceVertical = NO;
    scrollsView.showsHorizontalScrollIndicator = NO;
    scrollsView.showsVerticalScrollIndicator = NO;
    scrollsView.clipsToBounds = YES;
    //    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-80, SCREEN_WIDTH, 40)];
    CGRect lsframe = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    view1 = [[UIView alloc]initWithFrame:lsframe];
    UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [view1 addSubview:image1];
    lsframe.origin.x = SCREEN_WIDTH;
    view2 = [[UIView alloc]initWithFrame:lsframe];
    UIImageView * image2= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [view2 addSubview:image2];
    
    
    lsframe.origin.x = SCREEN_WIDTH*2;
    view3 = [[UIView alloc]initWithFrame:lsframe];
    UIImageView * image3= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [view3 addSubview:image3];
    
    lsframe.origin.x = SCREEN_WIDTH*3;
    view4 = [[UIView alloc]initWithFrame:lsframe];
    UIImageView * image4= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [view4 addSubview:image4];
    if(IS_IPHONE_4_OR_LESS){
        image1.image = [UIImage imageNamed:@"welcome_page_4s_01"];
        image2.image = [UIImage imageNamed:@"welcome_page_4s_02"];
        image3.image = [UIImage imageNamed:@"welcome_page_4s_03"];
        image4.image = [UIImage imageNamed:@"welcome_page_4s_04"];

    }else if(IS_IPAD){
        image1.image = [UIImage imageNamed:@"welcome_page_ipad_01"];
        image2.image = [UIImage imageNamed:@"welcome_page_ipad_02"];
        image3.image = [UIImage imageNamed:@"welcome_page_ipad_03"];
        image4.image = [UIImage imageNamed:@"welcome_page_ipad_04"];

    }else
    {
        image1.image = [UIImage imageNamed:@"welcome_page_6P_01"];
        image2.image = [UIImage imageNamed:@"welcome_page_6P_02"];
        image3.image = [UIImage imageNamed:@"welcome_page_6P_03"];
        image4.image = [UIImage imageNamed:@"welcome_page_6P_04"];
    }
    
    
    UIButton *comeIn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT-100, 30, 30)];
    [comeIn addTarget:self action:@selector(comeInOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [comeIn setBackgroundImage:[UIImage imageNamed:@"welcome_page_enter_normal"] forState:UIControlStateNormal];
    [comeIn setBackgroundImage:[UIImage imageNamed:@"welcome_page_enter_click"] forState:UIControlStateHighlighted];
    [view4 addSubview:comeIn];
    [scrollsView addSubview:view1];
    [scrollsView addSubview:view2];
    [scrollsView addSubview:view3];
    [scrollsView addSubview:view4];
    [self.view addSubview:scrollsView];
    [scrollsView setContentSize:CGSizeMake(SCREEN_WIDTH*4, SCREEN_HEIGHT-20  )];
    
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, SCREEN_HEIGHT-100, SCREEN_WIDTH-200, 40)];
    //    pageControl .backgroundColor = [UIColor blackColor];
    
    //用来记录页数
    NSUInteger pages = 4;
    
    //设置页码控制器的响应方法
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    //设置总页数
    pageControl.numberOfPages = pages;
    //默认当前页为第一页
    pageControl.currentPage = 0;
    
    //为页码控制器设置标签
    pageControl.tag = 110;
    pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    pageControl.pageIndicatorTintColor = COLORLINE;
    pageControl.currentPageIndicatorTintColor = COLORMAIN;
    //设置滚动视图的位置
    //    pageControl.backgroundColor = [UIColor redColor];
    [self.view addSubview:pageControl];
}
-(void)comeInOnClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.loginBlock();
}
//改变页码的方法实现
- (void)changePage:(id)sender
{
    NSLog(@"指示器的当前索引值为:%d",pageControl.currentPage);
    //获取当前视图的页码
    CGRect rect = scrollsView.frame;
    //设置视图的横坐标，一幅图为320*460，横坐标一次增加或减少320像素
    rect.origin.x = pageControl.currentPage * scrollsView.frame.size.width;
    //设置视图纵坐标为0
    rect.origin.y = 0;
    //scrollView可视区域
    [scrollsView scrollRectToVisible:rect animated:YES];
}
#pragma mark-----UIScrollViewDelegate---------
//实现协议UIScrollViewDelegate的方法，必须实现的
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //获取当前视图的宽度
    CGFloat pageWith = scrollView.frame.size.width;
    //根据scrolView的左右滑动,对pageCotrol的当前指示器进行切换(设置currentPage)
    int page = floor((scrollView.contentOffset.x - pageWith/2)/pageWith)+1;
    //切换改变页码，小圆点
    pageControl.currentPage = page;
}
@end
