//
//  LELoginViewController.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/27/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEBaseViewController.h"

@interface LELoginViewController : LEBaseViewController

@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) IBOutlet UIButton *passwordButton;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxtField;

-(IBAction)clickSignUp:(id)sender;
-(IBAction)clickSignIn:(id)sender;
-(IBAction)clickForgetPassword:(id)sender;

@end
