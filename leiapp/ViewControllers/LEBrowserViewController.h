//
//  LEBrowserViewController.h
//  leiappv2
//
//  Created by Ulearning on 15/11/17.
//  Copyright © 2015年 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface LEBrowserViewController : UIViewController<UIWebViewDelegate>
{
    MBProgressHUD *hud;
    UIView *viewnav;
    UIView *errorView;
}
@property (nonatomic , strong)NSString *url;
@property (nonatomic , strong)UIWebView *webView;
@end
