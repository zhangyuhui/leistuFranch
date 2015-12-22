//
//  LESettingViewTableViewCell.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/22/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LESettingViewTableViewCell;

@protocol LESettingViewTableViewCellDelegate <NSObject>
@optional
- (void)settingViewTableViewCell:(LESettingViewTableViewCell*)settingViewTableViewCell didSwitchValueChanged:(BOOL)value ;
@end

@interface LESettingViewTableViewCell : UITableViewCell
@property (strong, nonatomic) UIImage *settingIconImage;
@property (strong, nonatomic) NSString *settingTitle;
@property (strong, nonatomic) NSString *settingSelection;
@property (assign, nonatomic) BOOL settingSwitch;

@property (assign, nonatomic) id<LESettingViewTableViewCellDelegate> delegate;

+ (instancetype)settingViewTableViewCell;
@end
