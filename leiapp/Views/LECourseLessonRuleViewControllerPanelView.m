//
//  LECourseLessonRuleViewControllerPanelView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonRuleViewControllerPanelView.h"

@interface LECourseLessonRuleViewControllerPanelView ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@end

@implementation LECourseLessonRuleViewControllerPanelView

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setValue:(NSString *)value {
    _value = value;
    self.valueLabel.text = value;
}
@end
