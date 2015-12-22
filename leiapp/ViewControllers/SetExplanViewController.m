//
//  SetExplanViewController.m
//  LeiTeacherClient
//
//  Created by Rambo on 15/7/13.
//  Copyright (c) 2015年 U-Learning. All rights reserved.
//

#import "SetExplanViewController.h"
#import "LEDefines.h"
#import "LEHttpRequestOperation.h"
#import "UIButton+UIButton_SetBgState.h"
#import "MBProgressHUD+Add.h"
#import "LEConstants.h"

@implementation SetExplanViewController

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"意见反馈";
    [self aloadView];
    UITapGestureRecognizer * aingleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnKeyBoard:)];
    aingleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:aingleRecognizer];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)aloadView {
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 66, SCREEN_WIDTH, 200)];
    //    [self.commitButton setBackgroundColor:COLORMAIN];
    //    [self.commitButton setBackgroundColor:COLORMAIN forState:UIControlStateNormal];
    //    [self.commitButton setBackgroundColor:COLORRED forState:UIControlStateHighlighted];
    //    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //
    //    [self.commitButton setTitle:@"提交" forState:UIControlStateNormal];
    self.commitButton = [[UIButton alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT-55-64, SCREEN_WIDTH-30, 40)];
    self.commitButton.layer.cornerRadius=5;
    [self.commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commitButton setBackgroundColor:COLORMAIN forState:UIControlStateNormal];
    [self.commitButton setBackgroundColor:COLORBUTTON_SELECT forState:UIControlStateHighlighted];
    [self.commitButton addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.commitButton];
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 3, SCREEN_WIDTH, 200)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    textView.minNumberOfLines = 2;
    textView.maxNumberOfLines = 12;
    textView.returnKeyType = UIReturnKeyGo; //just as an example
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"感谢您选择交互英语。您的每一句反馈，我们都会认真聆听并改进。";
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.cornerRadius =5;
    textView.layer.borderWidth = .5;
    [self.view addSubview:containerView];
    textView.autoresizingMask = UIViewAutoresizingNone;
    // view hierachy
    [containerView addSubview:textView];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingNone;
}
-(void)resignTextView
{
    [textView resignFirstResponder];
}
-(void)returnKeyBoard:(id)sender
{
    [textView resignFirstResponder];
}
- (void)commit:(id)sender {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    LEHttpRequestOperation* requestOperation = [[LEHttpRequestOperation alloc]init];
    [requestOperation requestByPost:@"/feeds/feedback" parameters:[NSDictionary dictionaryWithObjectsAndKeys:userId,@"userid",[NSString stringWithFormat:@"%@",textView.text],@"content",version,@"versionCode", nil] options:nil success:^(LEHttpRequestOperation *operation, id response) {
        SHOWHUD(@"反馈成功");
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(LEHttpRequestOperation *operation, NSError *error) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
