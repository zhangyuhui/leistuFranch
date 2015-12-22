//
//  LECourseLessonsViewControllerMenuView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/15/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonsViewControllerMenuView.h"
#import "LECourseLessonsViewControllerMenuViewCell.h"

@interface LECourseLessonsViewControllerMenuView() <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)  NSArray *menuItems;

@end

@implementation LECourseLessonsViewControllerMenuView

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.menuItems = @[@{ @"image": @"detail", @"text": @"课程详情"},
                       @{ @"image": @"rule", @"text": @"成绩计算方法"},
                       @{ @"image": @"vocabulary", @"text": @"生词卡"},
                       @{ @"image": @"bookmark", @"text": @"书签"} ];
    
    self.dataSource = self;
    self.delegate = self;
    self.alwaysBounceVertical = NO;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LECourseLessonsViewControllerMenuViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [LECourseLessonsViewControllerMenuViewCell courseLessonsViewControllerMenuViewCell];
    }
    
    LECourseLessonsViewControllerMenuViewCell* courseLessonsViewControllerMenuViewCell = (LECourseLessonsViewControllerMenuViewCell*)cell;
    
    NSDictionary* menuItem = [self.menuItems objectAtIndex:indexPath.row];
    NSString* menuItemText = [menuItem objectForKey:@"text"];
    NSString* menuItemImage = [menuItem objectForKey:@"image"];
    
    courseLessonsViewControllerMenuViewCell.menuImage = [UIImage imageNamed:[NSString stringWithFormat:@"coursesection_viewcontroller_menu_%@", menuItemImage]];
    courseLessonsViewControllerMenuViewCell.menuText = menuItemText;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
//    
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        if ([self.menuDelegate respondsToSelector:@selector(menuView:didSelectMenu:)]) {
//            [self.menuDelegate menuView:self didSelectMenu:[indexPath row]];
//        }
//    });
    if ([self.menuDelegate respondsToSelector:@selector(menuView:didSelectMenu:)]) {
        [self.menuDelegate menuView:self didSelectMenu:[indexPath row]];
    }
}


@end
