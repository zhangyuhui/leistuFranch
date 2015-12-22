//
//  SetExplanViewController.h
//  LeiTeacherClient
//
//  Created by Rambo on 15/7/13.
//  Copyright (c) 2015年 U-Learning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
@interface SetExplanViewController : UIViewController<HPGrowingTextViewDelegate> {
    UIView *containerView;
    HPGrowingTextView *textView;
}
@property (strong, nonatomic)  UIButton *commitButton;

@end
