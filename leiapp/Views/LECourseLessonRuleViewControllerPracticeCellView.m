//
//  LECourseLessonRuleViewControllerPracticeCellView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/18/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonRuleViewControllerPracticeCellView.h"
#import "LEDefines.h"

@interface LECourseLessonRuleViewControllerPracticeCellView()
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UIView  *scoreView;
@property (strong, nonatomic) IBOutlet UILabel *scoreValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@end



@implementation LECourseLessonRuleViewControllerPracticeCellView

- (void)awakeFromNib {
    self.scoreView.layer.cornerRadius = 17.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setQuestion:(NSString *)question {
    _question = question;
    self.questionLabel.text = question;
}

- (void)setScore:(int)score {
    _score = score;
    self.scoreValueLabel.text = [NSString stringWithFormat:@"%d", score];
}

- (void)setTotal:(int)total {
    _total = total;
    self.progressLabel.text = [NSString stringWithFormat:@"%d/%d", self.count, self.total];
}

- (void)setCout:(int)count {
    _count = count;
    self.progressLabel.text = [NSString stringWithFormat:@"%d/%d", self.count, self.total];
}

- (void)setPass:(BOOL)pass {
    _pass = pass;
    self.scoreView.backgroundColor = pass ? UIColorFromRGB(0x1ebe4c) : UIColorFromRGB(0xfc393f);
}

+ (instancetype)courseLessonRuleViewControllerPracticeCellView {
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LECourseLessonRuleViewControllerPracticeCellView"
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];
}

@end
