//
//  LEBaseViewController.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/30/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UIViewControllerIndicatorView)
- (void)showIndicatorView;
- (void)hideIndicatorView;
- (BOOL)isIndicatorViewShown;

- (void)showProxyView:(UIView*)view;
- (void)hideProxyView;
- (BOOL)isProxyViewShown;

- (void)setRightBarButtonItems:(NSArray*)buttons;
- (void)setLeftBarButtonItems:(NSArray*)buttons;
@end

@interface LEBaseViewController : UIViewController
@property (nonatomic , assign)BOOL canBack;

- (void)presentViewController:(UIViewController *)viewController animated: (BOOL)animated completion:(void (^)(void))completion;
-(void)back;
@end
