//
//  LECourseClearViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseClearViewController.h"
#import "LECourseService.h"
#import "LECourse.h"

#define kPageTitle  @"清除下载课程"
#define kTableViewTitleFontSize 16.0
#define kTableViewDetailFontSize 14.0
#define kTableViewCellHeight 70

@interface LECourseClearViewController ()
@property (strong, nonatomic) IBOutlet UITableView *coursesTableView;

@property (strong, nonatomic) NSArray* courses;
@end

@implementation LECourseClearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = kPageTitle;
    
    NSArray* courses = [LECourseService sharedService].courses;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status >= %d", LECourseStatusStudyReady];
    self.courses = [courses filteredArrayUsingPredicate:predicate];
    
    [self.coursesTableView setEditing:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LECourseClearViewControllerCell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    LECourse* course = [self.courses objectAtIndexedSubscript:indexPath.row];
    cell.textLabel.text = course.title;
    cell.textLabel.font = [UIFont systemFontOfSize:kTableViewTitleFontSize];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"到期时间: %@", course.limit];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kTableViewDetailFontSize];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self showIndicatorView];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        LECourse* course = [self.courses objectAtIndex:indexPath.row];
        course.status = 0;
        course.download = 0;
        [[LECourseService sharedService] deleteStudyCourse:course];
        
        NSMutableArray* courses = [self.courses mutableCopy];
        [courses removeObjectAtIndex:indexPath.row];
        self.courses = courses;
        [self.coursesTableView reloadData];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self hideIndicatorView];
        });
    });
    
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

@end
