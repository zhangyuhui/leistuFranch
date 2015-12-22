//
//  LEPasswordVerifyViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/26/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEPasswordVerifyViewController.h"
#import "LEDefines.h"
#import "LEAccountService.h"
#import <QuartzCore/QuartzCore.h>

#define kPageTitle  @"修改密码"

@interface LEPasswordVerifyViewController ()
@property (strong, nonatomic) IBOutlet UIView *updatedPasswordTextFieldView;
@property (strong, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *updatedPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *updatedPasswordConfirmTextField;

@property (strong, nonatomic) UIBarButtonItem *saveButton;
@end

@interface LEPasswordVerifyViewController ()

@end

@implementation LEPasswordVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = kPageTitle;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveButton:)];
    
    saveButton.tintColor = [UIColor grayColor];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 5;
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: negativeSpacer, saveButton, nil]];
    
    self.saveButton = saveButton;
    [self.saveButton setEnabled:NO];
    
    [self.oldPasswordTextField becomeFirstResponder];
}

- (void)clickSaveButton:(id)sender {
    NSString* oldPassword = self.oldPasswordTextField.text;
    NSString* updatedPassword = self.updatedPasswordTextField.text;
    NSString* updatedConfirmPassword = self.updatedPasswordConfirmTextField.text;
    //旧密码是否正确
    if (![oldPassword isEqualToString:UserDefault(nil, @"passwordname")]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改密码错误"
                                                        message:@"旧密码错误"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }else if (![updatedPassword isEqualToString:updatedConfirmPassword]) {
        [self shake:self.updatedPasswordTextField];
        [self shake:self.updatedPasswordConfirmTextField];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改密码错误"
                                                        message:@"新密码两次输入不匹配"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        
        NSString *regex = @"^[A-Za-z0-9]+$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if (![predicate evaluateWithObject:updatedPassword]) {
            [self shake:self.updatedPasswordTextField];
            [self shake:self.updatedPasswordConfirmTextField];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改密码错误"
                                                            message:@"新密码只由数字或者字母组成"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        } else if ([updatedPassword length] < 6) {
            [self shake:self.updatedPasswordTextField];
            [self shake:self.updatedPasswordConfirmTextField];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改密码错误"
                                                            message:@"新密码长度不能少于6位"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        } else if ([updatedPassword length] > 15) {
            [self shake:self.updatedPasswordTextField];
            [self shake:self.updatedPasswordConfirmTextField];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改密码错误"
                                                            message:@"新密码长度不能大于15位"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            [self showIndicatorView];
            [[LEAccountService sharedService] changePassword:oldPassword newPassword:updatedPassword success:^(LEAccountService *service) {
                [self hideIndicatorView];
                SHOWHUD(@"修改密码成功！");
                [self dismissViewControllerAnimated:YES completion:nil];
            } failure:^(LEAccountService *service, NSString *error) {
                [self hideIndicatorView];
                if (error != nil) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改密码错误"
                                                                    message:@"保存新密码错误"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
        
        
    }
}

- (IBAction)onInputChanged:(id)sender {
   NSString* oldPassword = self.oldPasswordTextField.text;
   NSString* updatedPassword = self.updatedPasswordTextField.text;
   NSString* updatedConfirmPassword = self.updatedPasswordConfirmTextField.text;
    
   if ([oldPassword length] > 0 && [updatedPassword length] > 0 && [updatedConfirmPassword length] > 0) {
       [self.saveButton setEnabled:YES];
   } else {
       [self.saveButton setEnabled:NO];
   }
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

@end
