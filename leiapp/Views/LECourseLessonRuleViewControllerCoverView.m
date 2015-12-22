//
//  LECourseLessonRuleViewControllerCoverView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonRuleViewControllerCoverView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LEConstants.h"

@interface LECourseLessonRuleViewControllerCoverView ()

@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;

@property (strong, nonatomic) IBOutlet UIView *labelView;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *expirationLabel;

@property (strong, nonatomic) IBOutlet UILabel *topSampleLabel;
@property (strong, nonatomic) IBOutlet UILabel *bottomSampleLabel;

- (void)setupDisplay:(LECourse*)course;

@end

@implementation LECourseLessonRuleViewControllerCoverView

- (void)viewDidLoad {
    #define RADIANS(degrees) ((degrees * M_PI) / 180.0)
    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-20.0));
    self.topSampleLabel.transform = transform;
    self.bottomSampleLabel.transform = transform;
}

- (void)setCourse:(LECourse *)course {
    if (_course != course) {
        _course = course;
        [self setupDisplay:course];
    }
}

- (void)setupDisplay:(LECourse*)course {
    self.nameLabel.text = _course.title;
    self.expirationLabel.text = [NSString stringWithFormat:@"到期时间:%@", course.limit];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:course.cover]
                           placeholderImage:[UIImage imageNamed:kLEImageCoverPlaceholder]];
}

- (void)updateStatus:(LECourse*)course {
    self.progressLabel.text = @"--";
    self.durationLabel.text = @"--";
    self.scoreLabel.text = @"--";
}

@end
