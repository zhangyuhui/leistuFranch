//
//  LECourseLessonSectionItemLEIPracticeOptionItemView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/5/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIPracticeOptionItemView.h"
#import "LEPreferenceService.h"
#import "LEDefines.h"

#define kItemViewSpacing 15

@interface LECourseLessonSectionItemLEIPracticeOptionItemView ()
@property (strong, nonatomic) IBOutlet UIImageView *radioImageView;
@property (strong, nonatomic) IBOutlet UIImageView *checkboxImageView;
@property (strong, nonatomic) IBOutlet UIImageView *answerImageView;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textLabelLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textLabelTrailingConstraint;
@end

@implementation LECourseLessonSectionItemLEIPracticeOptionItemView

-(void)setChecked:(BOOL)checked {
    [super setChecked:checked];
    self.textLabel.highlighted = checked;
    if (self.multiple) {
        self.checkboxImageView.highlighted = checked;
    } else {
        self.radioImageView.highlighted = checked;
    }
}

-(void)setMultiple:(BOOL)multiple{
    if (multiple) {
        self.checkboxImageView.hidden = NO;
        self.radioImageView.hidden = YES;
    } else {
        self.checkboxImageView.hidden = YES;
        self.radioImageView.hidden = NO;
    }
    [super setMultiple:multiple];
}

-(void)setAnswer:(LECourseLessonSectionItemLEIPracticeAnswer)answer {
    if (answer == LECourseLessonSectionItemLEIPracticeAnswerCorrect ||
        answer == LECourseLessonSectionItemLEIPracticeAnswerWrong ||
        answer == LECourseLessonSectionItemLEIPracticeAnswerMiss) {
        self.checkboxImageView.hidden = YES;
        self.radioImageView.hidden = YES;
        self.answerImageView.hidden = NO;
    }
    if (answer == LECourseLessonSectionItemLEIPracticeAnswerCorrect){
        [self.answerImageView setImage:[UIImage imageNamed:@"courselesson_sectionpageview_checkbox_correct"]];
    }
    if (answer == LECourseLessonSectionItemLEIPracticeAnswerWrong){
        [self.answerImageView setImage:[UIImage imageNamed:@"courselesson_sectionpageview_checkbox_wrong"]];
    }
    if (answer == LECourseLessonSectionItemLEIPracticeAnswerMiss){
        [self.answerImageView setImage:[UIImage imageNamed:@"courselesson_sectionpageview_checkbox_missed"]];
    }
    [super setAnswer:answer];
}

-(void)setOption:(NSString *)option {
    _option = option;
    self.textLabel.text = option;
    
    CGFloat padding = [[LEPreferenceService sharedService] paddingSize];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat labelWidth = screenWidth - padding*2.0 - self.textLabelLeadingConstraint.constant - self.textLabelTrailingConstraint.constant;
    
    CGRect labelRect = [self.textLabel.text boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:self.textLabel.font} context:nil];
    
    CGFloat labelHeight = labelRect.size.height;
    
    self.textLabelHeightConstraint.constant = labelHeight;
}

-(CGFloat)heightForView {
    return self.textLabelHeightConstraint.constant + kItemViewSpacing*2.0;
}
@end
