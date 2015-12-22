//
//  CourseProcessViewController.m
//  LeiTeacherClient
//
//  Created by Rambo on 15/7/8.
//  Copyright (c) 2015年 U-Learning. All rights reserved.
//

#import "CourseProcessViewController.h"
#import "MKMessage.h"
#import "CustomURLCache.h"
#import "LEDefines.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIButton+UIButton_SetBgState.h"
//#import "ChatViewController.h"

@interface CourseProcessViewController ()
{
    MBProgressHUD *hud;
    UIView *viewnav;
    UIView *errorView;
}
//播放器视图控制器
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerViewController;

@end

@implementation CourseProcessViewController
- (id)init{
    if (self = [super init]) {
//        CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
//                                                                     diskCapacity:200 * 1024 * 1024
//                                                                         diskPath:nil
//                                                                        cacheTime:0];
//        [CustomURLCache setSharedURLCache:urlCache];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化进度条
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(clickbackButton:)];
    backButton.tintColor = [UIColor grayColor];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 5;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: negativeSpacer, backButton, nil]];

    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(popSelfView) name:NOTIFY_WEBFINISH object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(presentMedia:) name:NOTIFY_PRESENTMEDIA object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(presentMessageChatView:) name:NOTIFY_MESSAGECHATVIEW object:nil];

    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
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
//    CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
//                                                                 diskCapacity:200 * 1024 * 1024
//                                                                     diskPath:nil
//                                                                    cacheTime:0];
//    [CustomURLCache setSharedURLCache:urlCache];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)clickbackButton:(id)sender
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else
        [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)presentMessageChatView:(NSNotification*)notification
{
    [viewnav removeFromSuperview];
//    ChatViewController *chatController = notification.object;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBar"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController pushViewController:chatController animated:YES];
    
}
-(void)presentMedia:(NSNotification*)notification
{
    self.moviePlayerViewController = notification.object;
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
}
-(void)back:(id)sender
{
    [viewnav removeFromSuperview];
    [[CustomURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.startPage]]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)popSelfView
{
    [viewnav removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{    errorView.hidden=YES;

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
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [hud removeFromSuperview];
    if (!errorView) {
        errorView = [[UIView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:errorView];
    }
    errorView.hidden=NO;
    UIImageView *imageViews = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_tip2"]];
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
}
-(void)refreshself
{
    errorView.hidden=YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.startPage]];
    [self.webView loadRequest:request];
}
-(void)backButtonOnClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
