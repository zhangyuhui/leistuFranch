//
//  LEPraciceCheckerView.h
//  leiappv2
//
//  Created by Ulearning on 15/12/2.
//  Copyright © 2015年 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LEPraciceCheckerView;
@protocol LEPraciceCheckerViewDelegate
- (void)alertView:(LEPraciceCheckerView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
@interface LEPraciceCheckerView : UIView
{
    
}
@property (nonatomic ,strong) NSObject <LEPraciceCheckerViewDelegate>*delegate;
-(id)initWithType:(int)type Delegate:(id)delegate;
- (void)show;
@end
