//
//  LEAboutViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEAboutViewController.h"
#import "SetExplanViewController.h"
#import "LEBrowserViewController.h"
@interface LEAboutViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *verSon;
@property (strong, nonatomic) IBOutlet UITableView* aboutTableView;
@property (strong, nonatomic) NSArray* aboutItems;
@end

@implementation LEAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    self.verSon.text = [NSString stringWithFormat:@"LEI v%@",version];
    self.aboutItems = @[@"常见问题", @"操作指南", @"更新通知", @"意见反馈"];
    
    self.navigationItem.title = @"关于";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)openUrl:(NSString*)url {
    LEBrowserViewController *browserView =[[LEBrowserViewController alloc] init];
    browserView.title = @"常见问题";
    browserView.url = url;
    [self.navigationController pushViewController:browserView animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.aboutItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LEAboutViewControllerCellView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.tintColor = [UIColor grayColor];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [self.aboutItems objectAtIndex:indexPath.row];
    
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
    LEBrowserViewController *browserView =[[LEBrowserViewController alloc] init];
    
    
    if (indexPath.row == 0) {
        browserView.title = @"常见问题";
        browserView.url = @"http://help.longmanenglish.cn/?page_id=2283";
        [self.navigationController pushViewController:browserView animated:YES];
    } else if (indexPath.row == 1) {
        browserView.title = @"操作指南";
        browserView.url = @"http://help.longmanenglish.cn/?page_id=2283";
        [self.navigationController pushViewController:browserView animated:YES];
    } else if (indexPath.row == 2) {
        browserView.title = @"更新通知";
        browserView.url = @"http://help.longmanenglish.cn/?page_id=3175";
        [self.navigationController pushViewController:browserView animated:YES];
    }else if (indexPath.row == 3) {
        SetExplanViewController *viewController = [[SetExplanViewController alloc]init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
