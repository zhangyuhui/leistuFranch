//
//  LELoginViewController.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/27/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LELoginViewController.h"
#import "CourseProcessViewController.h"
#import "LEConstants.h"
#import "LEDefines.h"
#import "LEAccountService.h"
#import "LEMainViewController.h"
#import "NSString+Addition.h"
#import "LECourseService.h"
#import "LEBrowserViewController.h"
#import "UIButton+UIButton_SetBgState.h"
#warning 修改成外网的
#define kLoginViewControllerSignUp           @"http://m.longmanenglish.cn/views/jsp/account/register.jsp?isMobile=true"
#define kLoginViewControllerResetPassword    @"http://www.longmanenglish.cn/mobile/forgotpassword.html"

@interface LELoginViewController ()

-(void)shake:(UIView *)view;
-(void)openUrl:(NSString*)url;

-(void)gotoNext;
@end

@implementation LELoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.navigationController.viewControllers = [NSArray arrayWithObject:self];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 5;
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: negativeSpacer, nil]];
    [[self.signUpButton layer] setBorderWidth:1.0f];
    [[self.signUpButton layer] setBorderColor:UIColorFromRGB(kLEColorSignUpButton).CGColor];
    [self.signInButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.signInButton setTitle:@"登录" forState:UIControlStateHighlighted];
//    self.signInButton.backgroundColor = COLORMAIN;
//    [self.signInButton setHighlighted:YES];
    [self.signInButton setSelected:NO];
//    [self.signInButton setBackgroundColor:COLORBUTTON_SELECT forState:UIControlStateHighlighted];
    [self.signInButton setBackgroundColor:COLORMAIN forState:UIControlStateNormal];
    [self.signInButton setBackgroundColor:COLORBUTTON_SELECT forState:UIControlStateSelected];
//    [self.signInButton setBackgroundColor:COLORBUTTON_SELECT forState:UIControlStateSelected];
//    [self.signInButton setBackgroundColor:COLORBUTTON_SELECT forState:UIControlStateSelected|UIControlStateHighlighted];

    [self.signInButton addTarget:self action:@selector(changebuttoncolor) forControlEvents:UIControlEventTouchDown];
    [self.signInButton addTarget:self action:@selector(changebuttoncolored) forControlEvents:UIControlEventTouchUpOutside];
    [self.signInButton addTarget:self action:@selector(changebuttoncolored) forControlEvents:UIControlEventTouchUpOutside];
    [self.signInButton addTarget:self action:@selector(changebuttoncolored) forControlEvents:UIControlEventTouchCancel];
    self.usernameTextField.text = @"fangbinbin";
    self.passwordTxtField.text = @"wenhua";
}
-(void)changebuttoncolor{
    [self.signInButton setSelected:YES];
}
-(void)changebuttoncolored{
    [self.signInButton setSelected:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)shake:(UIView *)view {
    const int MAX_SHAKES = 6;
    const CGFloat SHAKE_DURATION = 0.08;
    const CGFloat SHAKE_TRANSFORM = 10;
    
    CGFloat direction = 1;
    
    for (int i = 0; i <= MAX_SHAKES; i++) {
        [UIView animateWithDuration:SHAKE_DURATION
                              delay:SHAKE_DURATION * i
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             if (i >= MAX_SHAKES) {
                                 view.transform = CGAffineTransformIdentity;
                             } else {
                                 view.transform = CGAffineTransformMakeTranslation(SHAKE_TRANSFORM * direction, 0);
                             }
                         } completion:nil];
        
        direction *= -1;
    }
}

-(IBAction)clickSignUp:(id)sender {
    LEBrowserViewController *browserView =[[LEBrowserViewController alloc] init];
    browserView.title = @"注册";
    browserView.url = kLoginViewControllerSignUp;
    [self presentViewController:browserView animated:YES completion:nil];
//    [self.navigationController pushViewController:browserView animated:YES];
}

-(IBAction)clickSignIn:(id)sender {
    [self.signInButton setSelected:NO];
    NSString* username = self.usernameTextField.text;
    UserDefault(self.usernameTextField.text, @"loginname");
    UserDefault(self.passwordTxtField.text, @"passwordname");

    NSString* password = self.passwordTxtField.text;
    BOOL isValidate = true;
    
    if ([password isEmptyOrWhitespace]) {
        isValidate = false;
        [self shake:self.passwordTxtField];
        [self.passwordTxtField becomeFirstResponder];
    }
    
    if ([username isEmptyOrWhitespace]) {
        isValidate = false;
        [self shake:self.usernameTextField];
        [self.usernameTextField becomeFirstResponder];
    }
   
    if (isValidate) {
        [self.view endEditing:NO];
        [self showIndicatorView];
        [[LEAccountService sharedService] loginUser:username password:password success:^(LEAccountService *service, LEAccount *account) {
//            LECourseService* courseService = [LECourseService sharedService];
//            if (courseService.courses == nil || [courseService.courses count] == 0) {
//                [[LECourseService sharedService] getStudyCoursesAndRecords:^(LECourseService *service, NSArray *courses, NSArray *records) {
//                    [self hideIndicatorView];
//                    [self gotoNext];
//                } failure:^(LECourseService *service, NSString *error) {
//                    [self hideIndicatorView];
//                    if (error != nil) {
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取课程错误"
//                                                                        message:@"获取课程以及学习记录错误"
//                                                                       delegate:self
//                                                              cancelButtonTitle:@"确定"
//                                                              otherButtonTitles:nil];
//                        [alert show];
//                    }
//                }];
//            } else {
//                [self hideIndicatorView];
//                [self gotoNext];
//            }
            [self hideIndicatorView];
            [self gotoNext];
        } failure:^(LEAccountService *service, NSString *error) {
            [self hideIndicatorView];
            
            if (error != nil) {
                [self.usernameTextField becomeFirstResponder];
                [self shake:self.usernameTextField];
                [self shake:self.passwordTxtField];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录错误"
                                                                message:@"用户名或密码错误"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            }

        }];
    }
}

-(IBAction)clickForgetPassword:(id)sender {
    CourseProcessViewController *browserView =[[CourseProcessViewController alloc] init];
    browserView.title = @"忘记密码";
    browserView.startPage = [NSString stringWithFormat:kLoginViewControllerResetPassword];
    [self presentViewController:browserView animated:YES completion:nil];
}


-(void)openUrl:(NSString*)url {
    LEBrowserViewController *browserView =[[LEBrowserViewController alloc] init];
    browserView.title = @"常见问题";
    browserView.url = url;
    [self.navigationController pushViewController:browserView animated:YES];
}


-(void)gotoNext {
    LEMainViewController* mainViewController = [[LEMainViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:mainViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
