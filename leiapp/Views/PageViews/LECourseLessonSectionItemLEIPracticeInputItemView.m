//
//  LECourseLessonSectionItemLEIPracticeInputItemView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 12/24/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIPracticeInputItemView.h"
#import "LEDefines.h"

@interface LECourseLessonSectionItemLEIPracticeInputItemView () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@end

@implementation LECourseLessonSectionItemLEIPracticeInputItemView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.editable = YES;
    self.containerView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
}

-(void)setInput:(NSString *)input {
    _input = input;
    self.inputTextField.text = input;
}

-(void)setEditing:(BOOL)editing {
    [super setEditing:editing];
    if (editing) {
        [self.inputTextField becomeFirstResponder];
    } else {
        [self.inputTextField resignFirstResponder];
    }
}

-(CGFloat)heightForView {
    return 50;
}

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.layer.borderColor = UIColorFromRGB(0x38c6f7).CGColor;
    if (!self.editing) {
        self.editing = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.input = [textField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if (self.editing) {
        self.editing = NO;
    }
}

@end
