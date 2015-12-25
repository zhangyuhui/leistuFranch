//
//  LECourseLessonSectionItemLEIPracticeInputItemView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 12/24/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIPracticeInputItemView.h"

@interface LECourseLessonSectionItemLEIPracticeInputItemView ()
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@end

@implementation LECourseLessonSectionItemLEIPracticeInputItemView

-(void)setInput:(NSString *)input {
    _input = input;
    self.inputTextField.text = input;
}

-(CGFloat)heightForView {
    return 60;
}

@end
