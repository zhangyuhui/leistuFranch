//
//  MoreServiceViewController.m
//  CEBCredit_3.04
//
//  Created by David King on 14-7-18.
//
//

#import "MoreServiceViewController.h"
//#import "TabButton.h"
//#import "ActiviesViewController.h"
//#import "CalendarViewController.h"
#import "LEDefines.h"
@interface MoreServiceViewController ()

@end

@implementation MoreServiceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title = @"更多服务";
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.myBackAndHomeButtonAndFrame =NO;
    
    webView_.scalesPageToFit = self.scaleFit;
    webView_.scrollView.bounces = NO;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navgationBar"] forBarMetrics:UIBarMetricsDefault];
    //((UIScrollView *)self->webView_).bounces = NO;
    
    if (self.noShowHomeBtn) {
        return;
    }
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal];
    [button2 setFrame:CGRectMake(2,2, 40, 40)];
    [button2 setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 5)];
    [button2 addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationController.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = homeItem;
    self.navigationController.navigationItem.leftBarButtonItem= homeItem;
//    [self.navigationItem addRightBarButtonItem: homeItem];
//    self.navigationItem.leftBarButtonItem
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //added by yfc on 20150427
    if ( self.myBackAndHomeButtonAndFrame != YES){
    
        webView_.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, self.view.frame.size.height);
        if (self.titleLabel.text) {
            self.title = self.titleLabel.text;
        }
        else{
            NSString * title = [webView_ stringByEvaluatingJavaScriptFromString:@"document.title"];
            self.titleLabel.text = title;
            self.title = self.titleLabel.text;
        }
    
    
    }else{
        if (IOS7_OR_LATER) {
            webView_.frame = CGRectMake(0.0, 20.0, SCREEN_WIDTH, self.view.frame.size.height -44-20);

        }

    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissAction{
    [self.navigationController setNavigationBarHidden:NO];
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        
//        [APPLICATION.mobileViewController clearPageBuffer];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    CAAnimation *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.7;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ((CATransition *)transition).type = kCATransitionFade;
    ((CATransition *)transition).subtype = kCATransitionMoveIn;
//    APPLICATION.window.rootViewController = APPLICATION.frostedViewController;
//    [APPLICATION.window.layer addAnimation:transition forKey:nil];

}

-(void)backAction
{
    if (webView_.canGoBack) {
        [webView_ goBack];
    }else if(self.popTag){
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
//        CATransition *animation = [CATransition animation];
//        animation.duration = 0.15;
//        animation.timingFunction = UIViewAnimationCurveEaseInOut;
//        animation.type = kCATransitionPush;
//        animation.subtype = kCATransitionFromLeft;
//        [self.view.window.layer addAnimation:animation forKey:nil];
        [self dismissModalViewControllerAnimated:NO];
        if (self.view.window) {
            
            [self.navigationController popViewControllerAnimated:NO];
        }
        
    }
}
//added by yfc on 20150427
-(void)setMineBackAndHomeButtonAndFrame{
    //added by yfc on 20150427开始//
    [self.view setBackgroundColor:[UIColor blackColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    float toolY = self.view.frame.size.height - 44;
    //529网页和底部导航条的frame也要根据系统来设置suchuyang
    if (IOS7_OR_LATER)
    {
        [webView_ setFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20-44)];
    }
    else
    {
        [webView_ setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20 - 40)];
        toolY = self.view.frame.size.height;
    }
    toolY = webView_.frame.origin.y + webView_.frame.size.height;
//    //added by yfc on 20150427结束//
//    
    CGFloat width =  SCREEN_WIDTH ;//2.0;//原值80
    
    UIScrollView*  tabBarView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, toolY, SCREEN_WIDTH, 44)];
    [tabBarView setContentSize:CGSizeMake(width, 44)];
    [tabBarView setBackgroundColor:getColorFromHex(@"#727071")];
    [self.view addSubview:tabBarView];
//
    UIButton* zhBack  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320/2, 44)];
     [zhBack setImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal];
    [zhBack setTitle:@"" forState:UIControlStateNormal];
    [zhBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    //[zhBack setTitle:@"返回"  forState:UIControlStateNormal];
    [tabBarView addSubview:zhBack];
//
//    UIButton* zhHome  = [[UIButton alloc] initWithFrame:CGRectMake(320/2, 0, 320/2, 44)];
//    [zhHome.iconView setImage:[UIImage imageNamed:@"newUI_main_home.png"]];
//    [zhHome setTextTitle:@"首页"];
//    [zhHome addTarget:self action:@selector(homeAction) forControlEvents:UIControlEventTouchUpInside];
//    //[zhHome setTitle:@"首页" forState:UIControlStateNormal];
//    [tabBarView addSubview:zhHome];
//
//    CGFloat lineY=44/4.0, x =width;
//
//    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(x/2 , lineY, 1,44/2.0)];
//        [lable setBackgroundColor:getColorFromHex(@"#9d9d9d")];
//        [tabBarView addSubview:lable];
//        [lable release];
//    
//
}
/**
 *  执行后退操作。
 *  added by yfc on 20150427 下面的返回按钮
 *  @param btn
 */
-(void)backAction:(UIButton*)btn
{
    [self.navigationController setNavigationBarHidden:NO];
    if (webView_.canGoBack) {
        [webView_ goBack];
    }

}
//added by yfc on 20150427
-(void)homeAction
{
    [self dismissModalViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
