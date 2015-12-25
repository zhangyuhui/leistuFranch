//
//  LECourseLessonPracticeAnswerFooterView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 12/25/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonPracticeAnswerFooterView.h"
#import "LEPreferenceService.h"
#import "LEDefines.h"

@interface LECourseLessonPracticeAnswerFooterView ()
@property (strong, nonatomic) IBOutlet UILabel *answerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *answerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *answerLabelLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *answerLabelTrailingConstraint;
@end

@implementation LECourseLessonPracticeAnswerFooterView

- (void)viewDidLoad {
    self.containerView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.answerLabel.textColor = UIColorFromRGB(0x28912e);
}

- (void)setAnswers:(NSArray *)answers {
    _answers = answers;
    NSMutableString* answerDisplay = [[NSMutableString alloc] init];
    [self.answers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        NSString* answer = obj;
        if (idx > 0) {
            [answerDisplay appendString:@"\n"];
        }
        [answerDisplay appendString:answer];
    }];
    self.answerLabel.text = answerDisplay;
    
    CGFloat padding = [[LEPreferenceService sharedService] paddingSize];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat labelWidth = screenWidth - padding*2.0 - self.answerLabelLeadingConstraint.constant - self.answerLabelTrailingConstraint.constant;
    
    CGRect labelRect = [self.answerLabel.text boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:self.answerLabel.font} context:nil];
    
    CGFloat labelHeight = labelRect.size.height;
    
    self.answerLabelHeightConstraint.constant = labelHeight;
}

-(CGFloat)heightForView {
    return self.answerLabel.frame.origin.y + self.answerLabelHeightConstraint.constant + 10;
}

@end
