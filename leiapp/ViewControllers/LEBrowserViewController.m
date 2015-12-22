//
//  LEBrowserViewController.m
//  leiappv2
//
//  Created by Ulearning on 15/11/17.
//  Copyright © 2015年 Yuhui Zhang. All rights reserved.
//

#import "LEBrowserViewController.h"
#import "LEDefines.h"
#import "LEAppDelegate.h"
#import "LEAccountService.h"
#import "UIButton+UIButton_SetBgState.h"
@implementation LEBrowserViewController
-(void)viewDidLoad
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
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT )];
    _webView.delegate = self;
    [self.view addSubview:_webView];
//    _url = @"http://192.168.0.220:8086/test.html";
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}
-(void)clickbackButton:(id)sender
{
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        if ([self.navigationController.viewControllers count]>1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else
            [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)back{
    if ([self.childViewControllers count]>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
        [self dismissViewControllerAnimated:YES completion:nil];}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestString = [[request URL] absoluteString];
    //格式需和前端商议，保持一致
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"leiapp"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"goBackClient"])
        {
            [self back];
        }else if([(NSString *)[components objectAtIndex:1] isEqualToString:@"onActivateCourseOK"]){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshMainView" object:nil];
            [self back];
        }else if([(NSString *)[components objectAtIndex:1] isEqualToString:@"joinClass"]){
            if ([components count]>2)
                [self joinClass:[components objectAtIndex:2]];
        }else if([(NSString *)[components objectAtIndex:1] isEqualToString:@"login"]){
            [self loginUserName:nil PassWord:nil IsMD5:YES];
        }
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"checkLogin"]){
            LEAccountService* accountService = [LEAccountService sharedService];
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"javascript:checkLoginCallBack(%d)",accountService.account?1:0]];
            
        }
        return NO;
    }
    return YES;
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
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [self.webView loadRequest:request];
}

//加班回掉
//json：{flag:1, classID:xxx, status:1, err_msg:xxx}
//flag=1 加班成功，如果err_msg非空提示err_msg，否则提示加班成功
//flag!=1 加班失败，提示err_msg
-(void) joinClass:(NSString*) json{
    [self clickbackButton:nil];
}

-(void) loginUserName:(NSString *)username PassWord:(NSString *)password IsMD5:(BOOL)isMd5{
    [self back];
}

-(void) onActivateCourseOK{
    [self clickbackButton:nil];
}
//离开web页面
-(void) goBackClient{
    [self clickbackButton:nil];
}

@end
