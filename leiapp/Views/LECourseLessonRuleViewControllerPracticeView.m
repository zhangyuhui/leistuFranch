//
//  LECourseLessonRuleViewControllerPracticeView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/18/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonRuleViewControllerPracticeView.h"
#import "LECourseLessonRuleViewControllerPracticeCellView.h"

@interface LECourseLessonRuleViewControllerPracticeView ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *practiceTableView;
@property (strong, nonatomic) IBOutlet UILabel *topSampleLabel;
@property (strong, nonatomic) IBOutlet UILabel *bottomSampleLabel;

@property (strong, nonatomic)  NSArray *questions;
@end

@implementation LECourseLessonRuleViewControllerPracticeView

-(void)viewDidLoad {
    self.questions = @[@{ @"question": @"Why do you think of their role play?", @"score": @56, @"total": @5, @"count": @2, @"pass": @NO},
                       @{ @"question": @"I appreciate their actings as well.", @"score": @85, @"total": @3, @"count": @1, @"pass": @YES},
                       @{ @"question": @"It is quite good.", @"score": @91, @"total": @3, @"count": @3, @"pass": @YES}];
    
    #define RADIANS(degrees) ((degrees * M_PI) / 180.0)
    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-20.0));
    self.topSampleLabel.transform = transform;
    self.bottomSampleLabel.transform = transform;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.questions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LECourseLessonRuleViewControllerPracticeCellView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [LECourseLessonRuleViewControllerPracticeCellView courseLessonRuleViewControllerPracticeCellView];
    }
    
    
    LECourseLessonRuleViewControllerPracticeCellView* cellView = (LECourseLessonRuleViewControllerPracticeCellView*)cell;
    
    NSDictionary* question = [self.questions objectAtIndex:indexPath.row];
    NSString* title = [question objectForKey:@"question"];
    int score = [[question objectForKey:@"score"] intValue];
    int total = [[question objectForKey:@"total"] intValue];
    int count = [[question objectForKey:@"count"] intValue];
    BOOL pass = [[question objectForKey:@"pass"] boolValue];
    
    cellView.question = title;
    cellView.score = score;
    cellView.total = total;
    cellView.count = count;
    cellView.pass = pass;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}
@end
