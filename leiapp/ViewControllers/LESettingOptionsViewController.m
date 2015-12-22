//
//  LESettingOptionsViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LESettingOptionsViewController.h"

@interface LESettingOptionsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *optionsTableView;
@property (strong, nonatomic) NSArray* optionLabels;
@property (strong, nonatomic) NSArray* optionValues;
@property (assign, nonatomic) int optionValue;
@end

@implementation LESettingOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"更改设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)initWIthOptions:(NSArray*)optionLabes optionsValues:(NSArray*)optionsValues optionValue:(int)optionValue {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.optionLabels = optionLabes;
        self.optionValues = optionsValues;
        self.optionValue = optionValue;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.optionLabels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LESettingOptionsViewControllerCellView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.tintColor = [UIColor grayColor];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = [self.optionLabels objectAtIndex:indexPath.row];
    
    NSNumber* value = [self.optionValues objectAtIndex:indexPath.row];
    if (self.optionValue == [value intValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
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


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    NSNumber* value = [self.optionValues objectAtIndex:indexPath.row];
    
    int optionValue = [value intValue];
    if (self.optionValue != optionValue) {
        self.optionValue = optionValue;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.optionsTableView reloadData];
            
            if ([self.delegate respondsToSelector:@selector(confirmOptionValueEdit:)]) {
                [self.delegate confirmOptionValueEdit:self.optionValue];
            }
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.2*NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        });
    }
}

@end
