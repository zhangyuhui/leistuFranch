//
//  LECourseLessonSectionItemLEIPracticeItemView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/5/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIPracticeItemView.h"
#import "LEDefines.h"

@implementation LECourseLessonSectionItemLEIPracticeItemView

- (void)viewDidLoad {
    _checked = NO;
    _editable = NO;
    _editing = NO;
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = UIColorFromRGB(0xe3e3e3).CGColor;
}

-(void)setChecked:(BOOL)checked {
    if (_checked != checked) {
        _checked = checked;
        if (_checked) {
            self.containerView.backgroundColor = UIColorFromRGB(0xe9f9ff);
            self.layer.borderWidth = 1.0;
            self.layer.borderColor = UIColorFromRGB(0x3cb2db).CGColor;
        } else {
            self.containerView.backgroundColor = [UIColor whiteColor];
            self.layer.borderWidth = 1.0;
            self.layer.borderColor = UIColorFromRGB(0xe3e3e3).CGColor;
        }
    }
}

-(void)setAnswer:(LECourseLessonSectionItemLEIPracticeAnswer)answer {
    if (_answer != answer) {
        _answer = answer;
        switch (answer) {
            case LECourseLessonSectionItemLEIPracticeAnswerCorrect: {
                self.containerView.backgroundColor = UIColorFromRGB(0xe3f5e9);
                self.layer.borderWidth = 1.0;
                self.layer.borderColor = UIColorFromRGB(0x28912e).CGColor;
                }
                break;
            case LECourseLessonSectionItemLEIPracticeAnswerWrong: {
                self.containerView.backgroundColor = UIColorFromRGB(0xf6eeee);
                self.layer.borderWidth = 1.0;
                self.layer.borderColor = UIColorFromRGB(0xd13339).CGColor;
                }
                break;
            default: {
                self.containerView.backgroundColor = [UIColor whiteColor];
                self.layer.borderWidth = 1.0;
                self.layer.borderColor = UIColorFromRGB(0xe3e3e3).CGColor;
                }
                break;
                
        }
    }
}

-(CGFloat)heightForView;{
    return 0;
}

@end
