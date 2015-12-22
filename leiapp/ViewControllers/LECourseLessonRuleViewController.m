//
//  LECourseLessonRuleViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonRuleViewController.h"
#import "LECourseLessonRuleViewControllerPanelView.h"
#import "LECourseLessonRuleViewControllerCoverView.h"
#import "LECourseLessonRuleViewControllerProgressView.h"
#import "LECourseLessonRuleViewControllerPracticeView.h"

#define kPageTitle                      @"成绩计算方法"

#define kOuterPadding                   10

@interface LECourseLessonRuleViewController ()
@property (strong, nonatomic) IBOutlet LECourseLessonRuleViewControllerPanelView *courseScorePanelView;
@property (strong, nonatomic) IBOutlet LECourseLessonRuleViewControllerPanelView *lessonScorePanelView;
@property (strong, nonatomic) IBOutlet LECourseLessonRuleViewControllerPanelView *pageScorePanelView;
@property (strong, nonatomic) IBOutlet LECourseLessonRuleViewControllerCoverView *courseCoverView;
@property (strong, nonatomic) IBOutlet LECourseLessonRuleViewControllerProgressView *courseProgressView;
@property (strong, nonatomic) IBOutlet LECourseLessonRuleViewControllerPracticeView *coursePracticeView;
@property (strong, nonatomic) IBOutlet UILabel *pageHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *pageFooterLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (strong, nonatomic) LECourse* course;

@property (assign, nonatomic) CGFloat contentHeight;

//- (CGFloat)adjustDisplay;
- (void)setupDisplay;
- (CGFloat)setupContentConstraint:(UIView*)view;
- (CGFloat)setupLabelConstraint:(UILabel*)label;
@end

@implementation LECourseLessonRuleViewController

- (instancetype)initWithCourse:(LECourse*)course {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.course = course;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = kPageTitle;
    
    [self setupDisplay];
    
    [self setupLabelConstraint:self.pageHeaderLabel];
    [self setupLabelConstraint:self.pageFooterLabel];
    [self setupContentConstraint:self.contentView];
    
    self.contentHeight = 2000;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupDisplay {
    self.courseScorePanelView.title = @"课程成绩";
    self.courseScorePanelView.value = @"本课程所有单元的分数总和/单元综总数";
    
    self.courseCoverView.course = self.course;
    self.courseProgressView.course = self.course;
    
    self.lessonScorePanelView.title = @"单元成绩";
    self.lessonScorePanelView.value = @"本单元所有页面的分数总和/页面总数";
    
    self.pageScorePanelView.title = @"页面成绩";
    self.pageScorePanelView.value = @"练习页面: 练习分数(多次联系取末次分数)";
    
    self.pageHeaderLabel.text = @"注: 以下类型的页面,如果老师设置了录音评分及格线,达到及格分数显示为绿色,没有达到则为绿色,默认及分.";
    self.pageFooterLabel.text = @"无练习的页面: 只记录完成状态. 计算单元成绩时, 已完成的页面算100分, 未完成的页面算0分.";
}

- (CGFloat)setupContentConstraint:(UIView*)view {
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:rightConstraint];
    
    return 0;
}

- (CGFloat)setupLabelConstraint:(UILabel*)label {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat labelWidth = screenWidth - kOuterPadding*2.0;
    
    CGRect labelRect = [label.text boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:label.font}
                                                    context:nil];
    
    CGFloat labelHeight = labelRect.size.height;
    labelHeight += 5;  //TODO no idea why 5 should be added
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:label
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:0
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:0.0
                                                                         constant:labelHeight];
    
    [label addConstraint:heightConstraint];
    
    return labelHeight;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat contentHeight = self.pageFooterLabel.frame.origin.y + self.pageFooterLabel.frame.size.height + kOuterPadding;
    CGFloat contentWidth = self.contentScrollView.contentSize.width;
    [self.contentScrollView setContentSize:CGSizeMake(contentWidth, contentHeight)];
}

@end
