//
//  LECourseLessonDetailViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/15/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Addition.h"
#import "LEConstants.h"

#define kPageTitle                      @"课程详情"

#define kAuthorDisplayDefault           @"暂无作者信息"
#define kCopyrightDisplayDefault        @"暂无课程版权信息"
#define kIntroductionDisplayDefault     @"暂无课程简介信息"

#define kOuterPadding                   10


@interface LECourseLessonDetailViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (strong, nonatomic) IBOutlet UILabel *introductionLabel;
@property (strong, nonatomic) IBOutlet UIView *introductionView;

@property (strong, nonatomic) LECourse *course;

@property (assign, nonatomic) CGFloat contentHeight;

- (CGFloat)adjustDisplay;
- (void)updateDisplay;

@end

@implementation LECourseLessonDetailViewController

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
    
    [self updateDisplay];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:rightConstraint];
    
    CGFloat contentHeight = [self adjustDisplay];
    CGFloat introductionViewHeight = contentHeight - self.introductionView.frame.origin.y;
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.introductionView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:0
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:0.0
                                                                         constant:introductionViewHeight];
    [self.introductionView addConstraint:heightConstraint];
    
    self.contentHeight = contentHeight;
    
    
}

- (CGFloat)adjustDisplay {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat labelWidth = screenWidth - (kOuterPadding + kOuterPadding)*2.0;
    CGRect labelRect = [self.introductionLabel.text boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName:self.introductionLabel.font} context:nil];
    
    CGFloat labelHeight = labelRect.size.height;
    labelHeight += 5;  //TODO no idea why 5 should be added

    CGFloat viewHeight = labelHeight + kOuterPadding + self.introductionLabel.frame.origin.y;
    CGFloat contentHeight = viewHeight + self.introductionView.frame.origin.y;
    CGFloat scrollHeight = self.contentScrollView.frame.size.height;
    
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.introductionLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:0
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:0.0
                                                                         constant:labelHeight];
    
    [self.introductionLabel addConstraint:heightConstraint];
    
    if (contentHeight < scrollHeight) {
        contentHeight = scrollHeight;
    }
    
    return contentHeight;
}

- (void)updateDisplay {
    self.nameLabel.text = self.course.title;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.course.cover]
                           placeholderImage:[UIImage imageNamed:kLEImageCoverPlaceholder]];
    
    self.authorLabel.text = [NSString stringWithPlaceholder:self.course.author placeholder:kAuthorDisplayDefault];
    self.copyrightLabel.text = [NSString stringWithPlaceholder:self.course.copyright placeholder:kCopyrightDisplayDefault];
    self.introductionLabel.text = [NSString stringWithPlaceholder:self.course.introduction placeholder:kIntroductionDisplayDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.contentScrollView setContentSize:CGSizeMake(self.contentScrollView.contentSize.width, self.contentHeight + kOuterPadding)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
