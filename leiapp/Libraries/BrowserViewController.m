//
//  BrowserView.m
//  CEB
//
//  Created by Bing Zheng on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BrowserViewController.h"
#import "DDProgressView.h"
#import "AdditionalFunctions.h"
#import "MBProgressHUD.h"
#define HTTPS @"https"
#import "LEDefines.h"
#import "Resources.h"
@interface BrowserViewController ()<MBProgressHUDDelegate,UIGestureRecognizerDelegate,NSURLConnectionDelegate>
{
     MBProgressHUD*  hub;
    NSMutableData *kingData;
}
/**
 * Description: 加载功能栏
 * Input:
 * Output:
 * Return:
 * Others:
 */
- (void)loadToolBar;



@end

@implementation BrowserViewController

@synthesize url_;
@synthesize currenURL = _currenURL;

- (id)init
{
    self = [super init];
    if(self)
    {
        kingData = [[NSMutableData data] retain];
    }
    return self;
}

- (void)dealloc
{
    hub.delegate = nil;
    //[hub release];
    [webView_ removeFromSuperview];
    [webView_ release];
    
    [toolBar_ removeFromSuperview];
    [toolBar_ release];
    
    [_nextButton removeFromSuperview];
    [_nextButton release];
    
    [_previousButton removeFromSuperview];
    [_previousButton release];
    
    [_stopButton removeFromSuperview];
    [_stopButton release];
    
    [_reloadButton removeFromSuperview];
    [_reloadButton release];
    
    [_currenURL release];
    
    [url_ release];
    [super dealloc];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark - load view
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 20)];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    if (webView_ == nil)
    {
        webView_ = [[DRWebView alloc] init];
        
        webView_.delegate = self;
        webView_.scalesPageToFit = YES;
        //去掉webView的长按手势
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:nil];
        press.delegate = self;
        press.minimumPressDuration = .4;
        [webView_ addGestureRecognizer:press];
        [press release];
        
        [self.view addSubview:webView_];
        [self createLoadingView];
    }
    
    if(!toolBar_)
    {

    }
    //added by king 0718
    //no toolBar
//    [self loadToolBar];
    //
    if(_currenURL)
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:_currenURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        
        [webView_ loadRequest:request];
        //[webView_ stopLoading];
        //deleted by yfc on 2015[self freshLoadingView:YES];
    }


    NSArray *viewControllers = self.navigationController.viewControllers;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(5,2, 40, 40)];
//    [button setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
    
//    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button2 setImage:[UIImage imageNamed:@"newUI_main_home"] forState:UIControlStateNormal];
//    [button2 setFrame:CGRectMake(0,2, 40, 40)];
//    [button2 setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];

    if ([NSStringFromClass([self.navigationController class]) isEqualToString:@"DEMONavigationController"] ) {//由首页进入的
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        UIBarButtonItem *backItem0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
        backItem0.width = 10;
        self.navigationController.navigationItem.leftBarButtonItem = nil;
//        self.navigationItem.leftBarButtonItem = backItem;
//        self.navigationItem.leftBarButtonItems = @[backItem0,backItem];
//        [self.navigationItem addLeftBarButtonItem:backItem];
        self.navigationItem.leftBarButtonItem = backItem;
        [backItem release];
        [backItem0 release];
//        [button2 addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
//        UIBarButtonItem *homeItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                                                                   target:nil action:nil];
//        homeItem2.width = 10;
//        self.navigationController.navigationItem.rightBarButtonItem = nil;
////        self.navigationItem.rightBarButtonItems = @[homeItem, homeItem2];
////        [self.navigationItem addRightBarButtonItem: homeItem];
//        self.navigationItem.rightBarButtonItem = homeItem;
//        [homeItem release];
//        [homeItem2 release];
    }
    else{
        
    
    if (viewControllers.count > 1 ) {
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationController.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = backItem;
//        [self.navigationItem addLeftBarButtonItem:backItem];
        [backItem release];
    }else if(viewControllers.count==1){
        //else if(viewControllers.count==1 && self.isBackButton ){
        //added by king 0718
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        //[button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationController.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = backItem;
//        [self.navigationItem addLeftBarButtonItem:backItem];
        [backItem release];
        
        //added by king 0718 导航栏右侧添加home按钮
//        [button2 addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
//        self.navigationController.navigationItem.rightBarButtonItem = nil;
//        self.navigationItem.rightBarButtonItem = homeItem;
////        [self.navigationItem addRightBarButtonItem: homeItem];
//        [homeItem release];
        
        
        //
        
    }

    }
    [self.navigationController.navigationBar setBackgroundImage:[[Resources sharedResources] getTopBarImage] forBarMetrics:UIBarMetricsDefault];

    //添加标题view
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.font = [UIFont boldSystemFontOfSize:20];//23
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"";
    //label.adjustsFontSizeToFitWidth = YES;
    self.titleLabel = label;
    
    [label release];
    self.navigationItem.titleView = _titleLabel;
    self.titleLabel.text= self.title;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;

}

///529.把webview等的frame放在viewappear里赋值。suchuyang
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    webView_.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, self.view.frame.size.height - 30);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//-(void)dismissAction{
//    [self dismissViewControllerAnimated:NO completion:nil];
//    [self.navigationController popViewControllerAnimated:NO];
//}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createLoadingView
{
    
    UIWindow* v = [UIApplication sharedApplication].keyWindow;
    hub = [[MBProgressHUD alloc] initWithView:v];
    hub.delegate = self;
    //hub.removeFromSuperViewOnHide = YES;
    hub.labelText = @"加载中...";
    [v addSubview:hub];
//    SHOWHUD(@"加载中。。。");
   //deleted by yfc on 2015 [self freshLoadingView:YES];
    //这个地方得注意一下，设置hub 的frame的view 必须和 要添加hub 的view 一致，不然他妈的崩溃的一塌糊涂。
}

-(void)freshLoadingView:(BOOL)b
{
    if (b) {
        [hub show:YES];
        [hub hide:YES afterDelay:10];
    }
    else{
        //[hub removeFromSuperview];
        [hub hide:YES];
    }

}

/**
 * Description: 加载功能栏
 * Input:
 * Output:
 * Return:
 * Others:
 */
- (void)loadToolBar
{
    float toolY = self.view.frame.size.height - 30-44-20;
    ///529.toolbar需要做ios6适配。suchuyang
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version >=7.0)
    {
        
    }
    else
    {
        toolY = self.view.frame.size.height - 30;
    }
    
    toolBar_ = [[UIView alloc] initWithFrame:CGRectMake(0.0, toolY, 320.0, 30.0)];
    toolBar_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topicColor.png"]];
    
    //webView images
    UIImage *stopImg = [[Resources sharedResources] loadImagePathForResource:@"stopButton" ofType:@"png"];
    UIImage *nextImg = [[Resources sharedResources] loadImagePathForResource:@"nextButtonWeb" ofType:@"png"];
    UIImage *previousdImg = [[Resources sharedResources] loadImagePathForResource:@"previousButton" ofType:@"png"];
    UIImage *reloadImg = [[Resources sharedResources] loadImagePathForResource:@"reloadButton" ofType:@"png"];
    
    //功能按钮
    _stopButton = [[UIButton alloc]initWithFrame:CGRectMake(44.0, 3.0, 24.0, 24.0)];
    [_stopButton setImage:stopImg forState:UIControlStateNormal];
    [_stopButton addTarget:self action:@selector(stopWebView:) forControlEvents:UIControlEventTouchUpInside];
    
    _previousButton = [[UIButton alloc]initWithFrame:CGRectMake(112.0, 3.0, 24.0, 24.0)];
    [_previousButton setImage:previousdImg forState:UIControlStateNormal];
    [_previousButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    _nextButton = [[UIButton alloc]initWithFrame:CGRectMake(180.0, 3.0, 24.0, 24.0)];
    [_nextButton setImage:nextImg forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchUpInside];
    
    _reloadButton = [[UIButton alloc]initWithFrame:CGRectMake(248.0, 3.0, 24.0, 24.0)];
    [_reloadButton setImage:reloadImg forState:UIControlStateNormal];
    [_reloadButton addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar_ addSubview:_stopButton];
    [toolBar_ addSubview:_previousButton];
    [toolBar_ addSubview:_nextButton];
    [toolBar_ addSubview:_reloadButton];
    
    [self.view addSubview:toolBar_];
    
}

- (void)exitBrowser:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)homeAction:(id)sender
//{
//    [self.navigationController popToRootViewControllerAnimated:NO];
//	
////	LightPoleAppDelegate *appDelegate = (LightPoleAppDelegate *)[[UIApplication sharedApplication]delegate];
////	[appDelegate bringViewToFront:toPageOfLogedMenu isBack:YES];
//}
#pragma mark - UIGestureDelegate
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
//        return NO;
//    }
//    return YES;
//}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}
#pragma mark - webView actions

- (void)back:(id)sender
{
    if (webView_.canGoBack)
    {
        [webView_ goBack];
    }
}

- (void)reload:(id)sender
{
    [webView_ reload];
    [self freshLoadingView:YES];
}

- (void)forward:(id)sender
{
    if (webView_.canGoForward)
    {
        [webView_ goForward];
    }
}

- (void)stopWebView:(id)sender
{
	[webView_ stopLoading];
}

- (void)loadUrl:(NSString *)url
{
    if (webView_)
    {
        url = [url stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        [webView_ loadRequest:request];
    }
}

- (void)loadURLof:(NSURL *)url
{
    self.currenURL = url;
}

- (void)reflashButtonState
{
    if (webView_.canGoBack)
    {
        _previousButton.enabled = YES;
    }
    else
    {
        _previousButton.enabled = NO;
    }
    
    if (webView_.canGoForward)
    {
        _nextButton.enabled = YES;
    }
    else
    {
        _nextButton.enabled = NO;
    }
}



#pragma mark - UIWebViewDelegate


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //added by gaohaitao on 20150422添加通知 网页跳转时缤纷优惠的更多tabButton收起

    [[NSNotificationCenter defaultCenter]postNotificationName:@"moreTabButtonDis" object:nil];
    
    webView_.scrollView.delegate=(id)self;
    [self reflashButtonState];
    [self freshLoadingView:YES];
    NSURL *theUrl = [request URL];
    NSString* scheme = [[request URL] scheme];
    //NSLog(@"scheme = %@",scheme);
    //判断是不是https
    if ([scheme isEqualToString:HTTPS]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        
        //edit by yfc on 20150505如果是visa的这个javascript就不做处理
        if([[NSString stringWithFormat:@"%@",theUrl] isEqualToString:@"https://secure.checkout.visa.com/resources/html/cookie_health/cookie_ready.html?parentUrl=http://ebcm.cebbank.com:8080" ] ){
            return YES;
        }

        if (!self.isAuthed) {
            originRequest = request;
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [webView stopLoading];
            
            [conn release];//added by king0820
            return NO;
        }
    }
    
    //当js拨打电话
//    if (([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) && [[theUrl description] rangeOfString:@"tel"].length > 0)
//    {
//        [[UIApplication sharedApplication]openURL:theUrl];
//        
//    }
    
     return YES;
}

#pragma mark-gaohaitao scrollViewDelegate 在这添加方法，当网页滚动时，moreTabButton移除
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //added by gaohaitao on 20150423 添加通知 网页跳转时缤纷优惠的更多tabButton收起
    [[NSNotificationCenter defaultCenter]postNotificationName:@"moreTabButtonDis" object:nil];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    /*!
     *  http://10.1.130.35:8080/ceb/test_a?flag=travel_info
     */
    
    NSString * title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    /**
     *  added by king0826
     *  为每一次web请求添加title
     */

    if (!self.titleLabel.text  ||  [self.titleLabel.text isEqual:@""]) {
        self.titleLabel.text = title;
    }
    
    [self reflashButtonState];
    [self freshLoadingView:NO];
    
    
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    //added by yfc on 20150505
    [self reflashButtonState];
    
    //当webView加载一个URL未完成就立即加载另一个URL时候，会回调didFailLoadWithError方法
    if ([error code] != NSURLErrorCancelled) {
        [webView loadHTMLString:@"加载失败，请稍后重试" baseURL:nil];
        webView.scalesPageToFit = NO;
        [self freshLoadingView:NO];
    }else{
        //[self freshLoadingView:YES];
    }
}


#pragma mark ================= NSURLConnectionDelegate <NSObject>

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{

    return YES;
}
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{

    if ([challenge previousFailureCount]== 0) {
        _authed = YES;

        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
    else
    {
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }

}

// Deprecated authentication delegates.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod
            isEqualToString:NSURLAuthenticationMethodServerTrust];

    return YES;
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{


    //    if (([challenge.protectionSpace.authenticationMethod
    //          isEqualToString:NSURLAuthenticationMethodServerTrust])) {
    //        if ([challenge.protectionSpace.host isEqualToString:@"111.200.87.69:8443/ccard"]) {
    //            NSURLCredential *credential = [NSURLCredential credentialForTrust:
    //                                           challenge.protectionSpace.serverTrust];
    //            [challenge.sender useCredential:credential
    //                 forAuthenticationChallenge:challenge];
    //        }
    //    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];

}



#pragma mark ================= NSURLConnectionDataDelegate <NSURLConnectionDelegate>

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{

    return request;

}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

    self.authed = YES;
    //webview 重新加载请求。
    [webView_ loadRequest:originRequest];
    //[connection cancel];//added by king0729
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [kingData appendData:data];
    
    NSLog(@"html data ? = %@", [[NSString alloc]initWithData:kingData encoding:NSUTF8StringEncoding]);
}

#pragma mark - 
#pragma mark =================MBProgressHUDDelegate==================

///**
// * Called after the HUD was fully hidden from the screen.
// */
//- (void)hudWasHidden:(MBProgressHUD *)progress
//{
//
//    //[progress removeFromSuperview];
//}

@end
