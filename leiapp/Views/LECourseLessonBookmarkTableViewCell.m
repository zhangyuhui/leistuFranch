//
//  LECourseLessonBookmarkTableViewCell.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/20/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonBookmarkTableViewCell.h"
#import "LECourseLesson.h"
#import "LECourseLessonSection.h"

@interface LECourseLessonBookmarkTableViewCell ()

@end


@implementation LECourseLessonBookmarkTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)courseLessonBookmarkTableViewCell {
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LECourseLessonBookmarkTableViewCell"
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];
    
}

@end
