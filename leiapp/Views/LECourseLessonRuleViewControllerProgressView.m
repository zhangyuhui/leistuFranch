//
//  LECourseLessonRuleViewControllerProgressView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonRuleViewControllerProgressView.h"
#import "MCPercentageDoughnutView.h"
#import "LEDefines.h"

@interface LECourseLessonRuleViewControllerProgressView ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet MCPercentageDoughnutView *studyScoreView;
@property (strong, nonatomic) IBOutlet MCPercentageDoughnutView *studyPercentageView;
@property (strong, nonatomic) IBOutlet UILabel *studyDurationLabel;
@property (strong, nonatomic) IBOutlet UILabel *studyPercentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *studyScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *topSampleLabel;
@property (strong, nonatomic) IBOutlet UILabel *bottomSampleLabel;

- (void)setupDisplay;

@end

@implementation LECourseLessonRuleViewControllerProgressView

- (void)viewDidLoad {
    //self.layer.cornerRadius = 10;
    //self.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    //self.layer.borderWidth = 1;
    
    self.studyScoreView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.studyScoreView.layer.borderWidth = 1;
    self.studyScoreView.showTextLabel = NO;
    self.studyScoreView.unfillColor = [UIColor clearColor];
    self.studyScoreView.fillColor = UIColorFromRGB(0xf3c780);
    self.studyScoreView.percentage = 0.34;
    self.studyScoreView.linePercentage = 0.1;
    
    
    self.studyPercentageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.studyPercentageView.layer.borderWidth = 1;
    self.studyPercentageView.showTextLabel = NO;
    self.studyPercentageView.unfillColor = [UIColor clearColor];
    self.studyPercentageView.fillColor = UIColorFromRGB(0xf3c780);
    self.studyPercentageView.percentage = 0.2;
    self.studyPercentageView.linePercentage = 0.1;
    
    #define RADIANS(degrees) ((degrees * M_PI) / 180.0)
    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-20.0));
    self.topSampleLabel.transform = transform;
    self.bottomSampleLabel.transform = transform;
}


- (void)setupDisplay {
    LECourseLesson* lesson = [self.course.detail.lessons firstObject];
    self.titleLabel.text = lesson.title;
}

- (void)setCourse:(LECourse *)course {
    if (_course != course) {
        _course = course;
        [self setupDisplay];
    }
}

@end
