//
//  LECourseLessonBookmarkTableViewCell.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/20/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECourseGlossary.h"

@interface LECourseLessonBookmarkTableViewCell : UITableViewCell

+ (instancetype)courseLessonBookmarkTableViewCell;

@property (strong, nonatomic) IBOutlet UILabel *bookmarkTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *bookmarkDescriptonLabel;
@property (strong, nonatomic) IBOutlet UILabel *bookmarkTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *bookmarkDateLabel;
@end
