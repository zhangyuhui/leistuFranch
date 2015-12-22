//
//  LEBaseViewController.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/30/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseViewController.h"

#define kBaseViewControllerBarButtonWidth        44
#define kBaseViewControllerProxyViewPadding      20
#define kBaseViewControllerProxyButtonWidth      30
#define kBaseViewControllerProxyButtonHeight     30
#define kBaseViewControllerProxyButtonPaddingTop   5
#define kBaseViewControllerProxyButtonPaddingRight 5

@interface LEBaseViewController ()
@property (strong, nonatomic) UIView *indicatorOverlayView;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic) UIView *proxyOverlayView;
@property (strong, nonatomic) UIView *proxyView;
@property (strong, nonatomic) UIButton *proxyButton;

@end


@implementation LEBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addIndicatorView];
    if (!_canBack) {
        return;
    }
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    backButton.tintColor = [UIColor grayColor];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 5;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: negativeSpacer, backButton, nil]];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addIndicatorView {
    self.indicatorOverlayView = [[UIView alloc] init];
    self.indicatorOverlayView.backgroundColor = [UIColor clearColor];
    [self.indicatorOverlayView setTranslatesAutoresizingMaskIntoConstraints: NO];
    self.indicatorOverlayView.hidden = YES;
    [self.view addSubview:self.indicatorOverlayView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorOverlayView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorOverlayView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorOverlayView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorOverlayView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.color = [UIColor blackColor];
    [self.indicatorView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [self.indicatorOverlayView addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    self.indicatorView.hidesWhenStopped = YES;
    
    [self.indicatorOverlayView addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.indicatorOverlayView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0]];
    
    [self.indicatorOverlayView addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.indicatorOverlayView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0]];
    
}

#pragma mark - UIViewController IndicatorView

- (void)showIndicatorView {
    self.indicatorOverlayView.hidden = NO;
}

- (void)hideIndicatorView {
    self.indicatorOverlayView.hidden = YES;
}

- (BOOL)isIndicatorViewShown {
    return self.indicatorOverlayView.hidden == NO;
}

#pragma mark - UIViewController ProxyView

- (void)showProxyView:(UIView*)view {
    if ([self isProxyViewShown]) {
        return;
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.proxyOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.proxyOverlayView.backgroundColor = [UIColor blackColor];
    self.proxyOverlayView.alpha = 0.3;
    
    
    NSLayoutConstraint* leadingConstraint = [NSLayoutConstraint constraintWithItem:self.proxyOverlayView
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.navigationController.view
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1.0
                                                                          constant:0];
    
    NSLayoutConstraint* trailingConstraint = [NSLayoutConstraint constraintWithItem:self.proxyOverlayView
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.navigationController.view
                                                                         attribute:NSLayoutAttributeTrailing
                                                                        multiplier:1.0
                                                                          constant:0];
    
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:self.proxyOverlayView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.navigationController.view
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0
                                                                           constant:0];
    
    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:self.proxyOverlayView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.navigationController.view
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:0];
    
    [self.navigationController.view addSubview:self.proxyOverlayView];
    
    [self.navigationController.view addConstraint:leadingConstraint];
    [self.navigationController.view addConstraint:trailingConstraint];
    [self.navigationController.view addConstraint:topConstraint];
    [self.navigationController.view addConstraint:bottomConstraint];
    
    CGRect viewFrame = view.frame;
    CGFloat viewHeight = viewFrame.size.height;
    
    CGFloat viewWidth = screenRect.size.width - kBaseViewControllerProxyViewPadding*2.0;
    viewFrame.size.width = viewWidth;
    view.frame = viewFrame;
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint* viewWidthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0
                                                                         constant:viewWidth];
    
    NSLayoutConstraint* viewHeightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeHeight
                                                                      multiplier:0.0
                                                                        constant:viewHeight];
    
    [view addConstraint:viewWidthConstraint];
    [view addConstraint:viewHeightConstraint];
    
    [self.navigationController.view addSubview:view];
    
    NSLayoutConstraint* viewCenterYConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.navigationController.view
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:0.0];
    
    NSLayoutConstraint* viewLeadingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.navigationController.view
                                                                             attribute:NSLayoutAttributeLeading
                                                                            multiplier:1.0
                                                                              constant:kBaseViewControllerProxyViewPadding];
    
    NSLayoutConstraint* viewTrailingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                              attribute:NSLayoutAttributeTrailing
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.navigationController.view
                                                                              attribute:NSLayoutAttributeTrailing
                                                                             multiplier:1.0
                                                                               constant:-kBaseViewControllerProxyViewPadding];
    
    [self.navigationController.view addConstraint:viewLeadingConstraint];
    [self.navigationController.view addConstraint:viewTrailingConstraint];
    [self.navigationController.view addConstraint:viewCenterYConstraint];
    
    self.proxyView = view;
    
    CGFloat buttonX = viewFrame.size.width - kBaseViewControllerProxyButtonWidth - kBaseViewControllerProxyButtonPaddingRight;
    CGFloat buttonY = kBaseViewControllerProxyButtonPaddingTop;
    
    self.proxyButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, kBaseViewControllerProxyButtonWidth, kBaseViewControllerProxyButtonHeight)];
    [self.proxyButton setBackgroundImage:[UIImage imageNamed:@"courselesson_sectionpageview_proxy_view_close_normal"] forState:UIControlStateNormal];
    [self.proxyButton setBackgroundImage:[UIImage imageNamed:@"courselesson_sectionpageview_proxy_view_close_highlight"] forState:UIControlStateHighlighted];
    
    [self.proxyButton addTarget:self action:@selector(clickProxyCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLayoutConstraint* buttonTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.proxyButton
                                                                             attribute:NSLayoutAttributeTrailing
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.self.proxyView
                                                                             attribute:NSLayoutAttributeTrailing
                                                                            multiplier:1.0
                                                                              constant:-kBaseViewControllerProxyButtonPaddingRight];
    
    NSLayoutConstraint* buttonTopConstraint = [NSLayoutConstraint constraintWithItem:self.proxyButton
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.self.proxyView
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:kBaseViewControllerProxyButtonPaddingTop];
    
    [self.self.proxyView addSubview:self.proxyButton];

    [self.self.proxyView addConstraint:buttonTrailingConstraint];
    [self.self.proxyView addConstraint:buttonTopConstraint];
    
    CATransition *proxyViewTransition = [CATransition animation];
    [proxyViewTransition setDuration:0.2];
    [proxyViewTransition setType:kCATransitionMoveIn];
    [proxyViewTransition setSubtype:kCATransitionFromTop];
    [proxyViewTransition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[self.proxyView layer] addAnimation:proxyViewTransition forKey:@"proxyViewShow"];
}

- (void)hideProxyView {
    if ([self isProxyViewShown]) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGPoint center = self.proxyView.center;
        center.y += screenRect.size.height*1.5;
        [UIView animateWithDuration:0.3 animations:^{
            self.proxyView.center = center;
        } completion:^(BOOL finished) {
            [self.proxyView removeFromSuperview];
            [self.proxyOverlayView removeFromSuperview];
            [self.proxyButton removeFromSuperview];
            self.proxyView = nil;
            self.proxyOverlayView = nil;
            self.proxyButton = nil;
        }];
    }
}

- (BOOL)isProxyViewShown {
    return self.proxyView != nil;
}

- (void)setRightBarButtonItems:(NSArray*)buttons {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = [buttons count] * kBaseViewControllerBarButtonWidth;
    CGFloat height = kBaseViewControllerBarButtonWidth;
    UIView* barButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton* button = obj;
        [button setFrame:CGRectMake(x + idx*kBaseViewControllerBarButtonWidth, y, kBaseViewControllerBarButtonWidth, kBaseViewControllerBarButtonWidth)];
        [barButtonView addSubview:obj];
    }];
    
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButtonView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -14;
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: negativeSpacer, barButtonItem, nil]];
}

- (void)setLeftBarButtonItems:(NSArray*)buttons {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = [buttons count] * kBaseViewControllerBarButtonWidth;
    CGFloat height = kBaseViewControllerBarButtonWidth;
    UIView* barButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton* button = obj;
        [button setFrame:CGRectMake(x + idx*kBaseViewControllerBarButtonWidth, y, kBaseViewControllerBarButtonWidth, kBaseViewControllerBarButtonWidth)];
        [barButtonView addSubview:obj];
    }];
    
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButtonView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -14;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: negativeSpacer, barButtonItem, nil]];
}

- (void)presentViewController:(UIViewController *)viewController animated: (BOOL)animated completion:(void (^)(void))completion {
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor darkGrayColor], NSForegroundColorAttributeName,
                                                           [UIFont systemFontOfSize:20.0], NSFontAttributeName, nil]];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentViewController:navController animated:animated completion:completion];
}

- (void)clickProxyCloseButton: (id)sender {
    [self hideProxyView];
}

@end
