//
//  LEMenuViewControllerCellView.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/30/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEMenuViewControllerCellView.h"

@implementation LEMenuViewControllerCellView
@synthesize menuImageView;
@synthesize menuLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)menuViewControllerCellView {
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LEMenuViewControllerCellView"
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];
}

@end
