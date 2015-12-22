//
//  LEConversionView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/11/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEConversionView.h"
#import "LEConversionBackgroundView.h"

@interface LEConversionView()
@property (strong, nonatomic) IBOutlet LEConversionBackgroundView* backgroundView;
@property (strong, nonatomic) IBOutlet UILabel* textLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* textLabelLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* textLabelTrailingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* textLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* textLabelTopConstraint;
@end

@implementation LEConversionView

- (void)viewDidLoad {
    self.backgroundColor = [UIColor clearColor];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textLabel.text = text;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.textLabel.textColor = self.textColor;
}

- (void)setFilledColor:(UIColor *)filledColor {
    _filledColor = filledColor;
    self.backgroundView.filledColor = self.filledColor;
}

- (void)setArrowPostion:(CGFloat)arrowPostion {
    _arrowPostion = arrowPostion;
    self.backgroundView.arrowPosition = arrowPostion;
}

- (CGFloat)heightForViewWidth:(CGFloat)width {
    CGFloat labelWidth = width - self.textLabelLeadingConstraint.constant - self.textLabelTrailingConstraint.constant;
    
    CGRect labelRect = [self.text boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.textLabel.font} context:nil];
    
    return labelRect.size.height + self.textLabelTopConstraint.constant + 20;
    
}
@end
