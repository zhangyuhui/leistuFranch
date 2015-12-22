//
//  LESettingViewTableViewCell.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/22/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LESettingViewTableViewCell.h"

@interface LESettingViewTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *settingIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *settingTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *settingSelectionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *settingActionImageView;
@property (strong, nonatomic) IBOutlet UISwitch *settingSwitchView;
@end


@implementation LESettingViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    [self.settingSwitchView addTarget:self action:@selector(onSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];

}

+ (instancetype)settingViewTableViewCell {
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LESettingViewTableViewCell"
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];
    
}

- (void)setSettingIconImage:(UIImage *)settingIconImage {
    _settingIconImage = settingIconImage;
    self.settingIconImageView.image = settingIconImage;
}

- (void)setSettingSelection:(NSString *)settingSelection {
    _settingSelection = settingSelection;
    self.settingSelectionLabel.text = settingSelection;
    self.settingActionImageView.hidden = YES;
    self.settingSwitchView.hidden = YES;
    self.settingSelectionLabel.hidden = NO;
}

- (void)setSettingSwitch:(BOOL)settingSwitch {
    _settingSwitch = settingSwitch;
    self.settingSwitchView.on = settingSwitch;
    self.settingActionImageView.hidden = YES;
    self.settingSelectionLabel.hidden = YES;
    self.settingSwitchView.hidden = NO;
}

- (void)setSettingTitle:(NSString *)settingTitle {
    _settingTitle = settingTitle;
    _settingTitleLabel.text = settingTitle;
}

- (void)onSwitchValueChanged:(id)sender  {
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingViewTableViewCell:didSwitchValueChanged:)]) {
        BOOL on = [sender isOn];
        [self.delegate settingViewTableViewCell:self didSwitchValueChanged:on];
    }
}

@end
