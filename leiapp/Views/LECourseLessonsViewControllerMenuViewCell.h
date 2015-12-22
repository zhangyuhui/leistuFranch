//
//  LECourseLessonsViewControllerMenuViewCell.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/15/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LECourseLessonsViewControllerMenuViewCell : UITableViewCell

@property (strong, nonatomic) UIImage *menuImage;
@property (strong, nonatomic) NSString *menuText;

+ (instancetype)courseLessonsViewControllerMenuViewCell;

@end
