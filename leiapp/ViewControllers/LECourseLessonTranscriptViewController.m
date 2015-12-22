//
//  LECourseLessonTranscriptViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/5/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonTranscriptViewController.h"
#import "RTLabel.h"

#define kPageTitle                      @"听力原文"

@interface LECourseLessonTranscriptViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView* transcriptScrollView;
@property (strong, nonatomic) IBOutlet RTLabel* transcriptLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* transcriptLabelLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* transcriptLabelTrailngConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* transcriptLabelWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* transcriptLabelHeightConstraint;

@property (nonatomic, strong) NSString* transcript;

@end

@implementation LECourseLessonTranscriptViewController

- (instancetype)initWithTranscript:(NSString*)transcript {
    self = [super initWithNibName:nil bundle:nil];
    if (self){
        self.transcript = transcript;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = kPageTitle;
    
    self.transcriptLabel.textColor = [UIColor darkGrayColor];
    self.transcriptLabel.font = [UIFont systemFontOfSize:16.0];
    self.transcriptLabel.lineSpacing = 5;
    self.transcriptLabel.text = self.transcript;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat labelWidth = screenWidth - self.transcriptLabelLeadingConstraint.constant - self.transcriptLabelTrailngConstraint.constant;
    
    
    
    CGRect frame = self.transcriptLabel.frame;
    frame.size.width = labelWidth;
    self.transcriptLabel.frame = frame;
    
    CGSize labelSize = self.transcriptLabel.optimumSize;
    CGFloat labelHeight = labelSize.height;
    
    self.transcriptLabelWidthConstraint.constant = labelWidth;
    self.transcriptLabelHeightConstraint.constant = labelHeight;
    
    [self.transcriptScrollView setContentSize:CGSizeMake(labelWidth, labelHeight)];
}

//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    
//    
//    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidth = screenRect.size.width;
//    CGFloat labelWidth = screenWidth - self.transcriptLabelLeadingConstraint.constant - self.transcriptLabelTrailngConstraint.constant;
//    
//    CGFloat labelHeight = labelSize.height;
//    
//    //self.transcriptLabelWidthConstraint.constant = labelWidth;
//    self.transcriptLabelHeightConstraint.constant = labelHeight;
//    
//    [self.transcriptScrollView setContentSize:CGSizeMake(labelWidth, labelHeight)];
//}

@end
