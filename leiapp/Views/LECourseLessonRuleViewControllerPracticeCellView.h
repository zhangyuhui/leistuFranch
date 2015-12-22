//
//  LECourseLessonRuleViewControllerPracticeCellView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/18/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LECourseLessonRuleViewControllerPracticeCellView : UITableViewCell
@property (strong, nonatomic) NSString* question;
@property (assign, nonatomic) int score;
@property (assign, nonatomic) int total;
@property (assign, nonatomic) int count;
@property (assign, nonatomic) BOOL pass;

+ (instancetype)courseLessonRuleViewControllerPracticeCellView;

@end
