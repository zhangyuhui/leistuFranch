//
//  LECourseLessonSummarylViewControllerCell.m
//  leiappv2
//
//  Created by Yuhui Zhang on 11/9/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSummarylViewControllerCell.h"
#import "LEDefines.h"

@interface LECourseLessonSummarylViewControllerCell ()
@property (strong, nonatomic) IBOutlet UIView *statusView;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *lessonTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lessonDescriptionLabel;
@end

@implementation LECourseLessonSummarylViewControllerCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)courseLessonSummarylViewControllerCell {
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LECourseLessonSummarylViewControllerCell"
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];
}

- (void)setPageRecord:(LEPageRecord *)pageRecord{
//    _lessonSection = lessonSection;
    _pageRecord = pageRecord;
    
    self.statusView.layer.cornerRadius = 15;
    if (!_pageRecord || _pageRecord.duration == 0) {
        self.statusView.backgroundColor = UIColorFromRGB(0xe7e7e7);
        self.statusLabel.text = [NSString stringWithFormat:@"%d", self.lessonSection.index + 1];
    } else if (_pageRecord.isCompleted) {
        self.statusView.backgroundColor = UIColorFromRGB(0xa0da72);
        self.statusLabel.text = @"\u2713";
    } else {
        self.statusView.backgroundColor = UIColorFromRGB(0xfec87a);
        self.statusLabel.text = [NSString stringWithFormat:@"%d", self.lessonSection.index + 1];
    }
    int seconds = !_pageRecord ? 0 : _pageRecord.duration % 60;
    int minutes = !_pageRecord ? 0 : (_pageRecord.duration / 60) % 60;
    int hours = !_pageRecord ? 0 : _pageRecord.duration / 3600;
    int score = !_pageRecord ? 0 : _pageRecord.score;
    self.lessonTitleLabel.text = self.lessonSection.title;
    self.lessonDescriptionLabel.text = [NSString stringWithFormat:@"时间: %02d:%02d:%02d   成绩: %d分", hours, minutes, seconds, score];
}

@end
