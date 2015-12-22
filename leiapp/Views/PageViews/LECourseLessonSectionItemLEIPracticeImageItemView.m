//
//  LECourseLessonSectionItemLEIPracticeImageItemView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/21/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIPracticeImageItemView.h"

@interface LECourseLessonSectionItemLEIPracticeImageItemView ()
@property (strong, nonatomic) IBOutlet UIImageView *radioImageView;
@property (strong, nonatomic) IBOutlet UIImageView *checkboxImageView;
@property (strong, nonatomic) IBOutlet UIImageView *answerImageView;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@end

@implementation LECourseLessonSectionItemLEIPracticeImageItemView
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

-(void)setImage:(NSString *)image {
    _image = image;
    self.coverImageView.image  = [UIImage imageWithContentsOfFile:self.image];
}

-(void)setIndex:(int)index {
    NSArray* labels = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I"];
    self.textLabel.text = [labels objectAtIndex:index];
    [super setIndex:index];
}

-(CGFloat)heightForView {
    return 160;
}
@end
