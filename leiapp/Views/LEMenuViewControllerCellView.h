//
//  LEMenuViewControllerCellView.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/30/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEMenuViewControllerCellView : UITableViewCell

+ (instancetype)menuViewControllerCellView;

@property (strong, nonatomic) IBOutlet UIImageView *menuImageView;
@property (strong, nonatomic) IBOutlet UILabel *menuLabel;

@end
