//
//  LECourseLessonSectionItemLEIPracticeNoteItemView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 12/25/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIPracticeNoteItemView.h"
#import "LEDefines.h"
#import "HPGrowingTextView.h"

@interface LECourseLessonSectionItemLEIPracticeNoteItemView () <HPGrowingTextViewDelegate>
@property (strong, nonatomic) IBOutlet HPGrowingTextView *noteTextField;
@end

@implementation LECourseLessonSectionItemLEIPracticeNoteItemView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.editable = YES;
    self.containerView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    
    self.noteTextField.isScrollable = YES;
    self.noteTextField.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.noteTextField.font = [UIFont systemFontOfSize:14.0f];
    self.noteTextField.delegate = self;
    self.noteTextField.backgroundColor = [UIColor clearColor];
    self.noteTextField.placeholder = @"请输入内容(不超过500字)";
}

-(void)setNote:(NSString *)note {
    _note = note;
    self.noteTextField.text = note;
}

-(void)setEditing:(BOOL)editing {
    [super setEditing:editing];
    if (editing) {
        [self.noteTextField becomeFirstResponder];
    } else {
        [self.noteTextField resignFirstResponder];
    }
}

-(CGFloat)heightForView {
    return 150;
}

#pragma UITextFieldDelegate
- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)textField {
    self.layer.borderColor = UIColorFromRGB(0x38c6f7).CGColor;
    if (!self.editing) {
        self.editing = YES;
    }
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)textField {
    self.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.note = [textField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if (self.editing) {
        self.editing = NO;
    }
}

@end