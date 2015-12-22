//
//  HomeWorkViewController.m
//  LeiTeacherClient
//
//  Created by Rambo on 15/8/12.
//  Copyright (c) 2015年 U-Learning. All rights reserved.
//

#import "HomeWorkViewController.h"
#import "MKMessage.h"
#import "CustomURLCache.h"
#import "LEDefines.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIButton+UIButton_SetBgState.h"
#import "MBProgressHUD+Add.h"
@interface HomeWorkViewController ()
{
    MBProgressHUD *hud;
    UIView *viewnav;
    UIView *errorView;
}
//播放器视图控制器
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerViewController;

@end

@implementation HomeWorkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLORMAIN;
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(popSelfView) name:NOTIFY_WEBFINISH object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(presentMedia:) name:NOTIFY_PRESENTMEDIA object:nil];

    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    UIWindow *  window=[UIApplication sharedApplication].keyWindow;
    viewnav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    viewnav.backgroundColor = COLORMAIN;
    [window addSubview:viewnav];
    // 手势方向
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    // 响应的手指数
    swipeRecognizer.numberOfTouchesRequired = 2;
    
    // 添加手势
    [[self view] addGestureRecognizer:swipeRecognizer];
    //    SHOWHUD(@"双指右划可以返回");
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 20)];
    navBar.backgroundColor = COLORMAIN;
    [self.webView addSubview:navBar];
    [self.view addSubview:navBar];
//    self.webView.delegate= self;
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.webView.backgroundColor = COLORMAIN;
    //    CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
    //                                                                 diskCapacity:200 * 1024 * 1024
    //                                                                     diskPath:nil
    //                                                                    cacheTime:0];
    //    [CustomURLCache setSharedURLCache:urlCache];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)presentMedia:(NSNotification*)notification
{
    [viewnav removeFromSuperview];
    self.moviePlayerViewController = notification.object;
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
}
-(void)back:(id)sender
{
    [viewnav removeFromSuperview];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(f1) userInfo:nil repeats:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)f1{
    [[CustomURLCache sharedURLCache] removeAllCachedResponses];

}
-(void)popSelfView
{
    [viewnav removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    errorView.hidden=YES;
    NSLog(@"webViewDidStartLoad");
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide =YES;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"loading";
    [hud hide:YES afterDelay:.1];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [hud removeFromSuperview];
    errorView.hidden=YES;
    NSLog(@"webViewDidFinishLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [hud removeFromSuperview];
    NSLog(@"error->>%@",error.description);
    if (!errorView) {
        errorView = [[UIView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:errorView];
    }
    errorView.hidden=NO;
    UIImageView *imageViews = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"default_05_without-line"]];
    CGRect lsframe = CGRectMake(SCREEN_WIDTH/4-10, (SCREEN_HEIGHT-SCREEN_WIDTH)*0.618, SCREEN_WIDTH/2.0+20, SCREEN_WIDTH/2.0+40);
    imageViews.frame = lsframe;
    [errorView addSubview:imageViews];
    lsframe.origin.y += lsframe.size.height;
    lsframe.size.height=40;
    UILabel *label = [[UILabel alloc]initWithFrame:lsframe];
    label.textColor = COLORTITEL;
    label.font = FONTTABLELABEL;
    label.text = @"断网了... 请检查手机网络噻~";
    label.textAlignment=NSTextAlignmentCenter;
    label.lineBreakMode=NSLineBreakByCharWrapping;
    label.numberOfLines=2;
    label.tag=20;
    [errorView addSubview:label];
    lsframe.origin.y +=lsframe.size.height+10;
    lsframe.size.height= 30;
    UIButton *refresh = [[UIButton alloc]initWithFrame:lsframe];
    [refresh setTitle:@"刷新页面" forState:UIControlStateNormal];
    [refresh setBackgroundColor:COLORMAIN forState:UIControlStateNormal];
    [refresh setBackgroundColor:COLORBUTTON_SELECT forState:UIControlStateHighlighted];
    [refresh addTarget:self action:@selector(refreshself) forControlEvents:UIControlEventTouchUpInside];
    [errorView addSubview:refresh];
    UIView * headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    headView.backgroundColor=[UIColor colorWithRed:56/255.0 green:198/255.0 blue:247/255.0 alpha:1];
    [errorView addSubview:headView];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 28, SCREEN_WIDTH, 30)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = @"作业";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    UIButton *backbutton = [[UIButton alloc]initWithFrame:CGRectMake(10, 25 , 50, 40)];
    [backbutton setImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal];
    [backbutton setImage:[UIImage imageNamed:@"nav_back_click"] forState:UIControlStateHighlighted];
    
    [backbutton addTarget:self action:@selector(backButtonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:titleLabel];
    [headView addSubview:backbutton];
}
-(void)refreshself
{
    errorView.hidden=YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.startPage]];
    [self.webView loadRequest:request];
}
-(void)backButtonOnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
