//
//  LEMainViewControlerCellViewTableViewCell.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/1/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECourse.h"

@class LEMainViewControlerCellViewTableViewCell;

@protocol LEMainViewControlerCellViewTableViewCellDelegate <NSObject>
@optional
- (void)mainViewControlerCellViewTableViewCell:(LEMainViewControlerCellViewTableViewCell*)cellView downloadCourse:(LECourse*)course;
- (void)mainViewControlerCellViewTableViewCell:(LEMainViewControlerCellViewTableViewCell*)cellView studyCourse:(LECourse*)course;
@end

@interface LEMainViewControlerCellViewTableViewCell : UITableViewCell

@property (strong, nonatomic) LECourse* course;
@property (assign, nonatomic) BOOL scrolling;
@property (assign, nonatomic) id<LEMainViewControlerCellViewTableViewCellDelegate> delegate;

+ (instancetype)mainViewControlerCellViewTableViewCell;

@end
