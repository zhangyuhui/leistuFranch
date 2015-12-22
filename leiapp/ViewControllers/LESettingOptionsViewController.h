//
//  LESettingOptionsViewController.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseModalViewController.h"

@class LESettingOptionsViewController;

@protocol LESettingOptionsViewControllerDelegate <NSObject>
- (void)confirmOptionValueEdit:(int)optionValue;
@end

@interface LESettingOptionsViewController : LEBaseModalViewController
-(instancetype)initWIthOptions:(NSArray*)optionLabes optionsValues:(NSArray*)optionsValues optionValue:(int)optionValue;

@property (assign, nonatomic) id<LESettingOptionsViewControllerDelegate> delegate;
@end
