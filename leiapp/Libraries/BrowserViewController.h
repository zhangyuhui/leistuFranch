//
//  BrowserView.h
//  AirChina
//
//  Created by Bing Zheng on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define INDICATOR_TAG 51
#import "DRWebView.h"
//#import "BaseViewController.h"
@interface BrowserViewController :UIViewController  <UIWebViewDelegate>
{
    //浏览器
    DRWebView                   *webView_;

    //功能栏
    UIView                      *toolBar_;
    
    //功能按钮
    UIButton                    *_stopButton;
	UIButton                    *_previousButton;
	UIButton                    *_nextButton;
    UIButton                    *_reloadButton;
    
    //当前的url
    NSURL *_currenURL;
    //这个是当请求https时用到记录上次请求的。
    NSURLRequest* originRequest;
}

@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,assign,getter =isAuthed)BOOL authed;

@property (nonatomic, retain) UILabel *url_;
@property (nonatomic, retain) NSURL *currenURL;

- (void)loadUrl:(NSString *)url;
- (void)loadURLof:(NSURL *)url;

- (void)reflashButtonState;
-(void)freshLoadingView:(BOOL)b;

@end
