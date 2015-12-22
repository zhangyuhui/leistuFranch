//
//  LEProfileViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/26/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEProfileViewController.h"
#import "LEAccountService.h"
#import "LEProfileEditViewController.h"
#import "LEAccount.h"
#import "LEDefines.h"
#import "MBProgressHUD+Add.h"
#define kTableViewIconSize 16
#define kTableViewCellHeight 50
#define kPageTitle  @"个人资料"

#define kItemKeyUserName @"user_name"
#define kItemKeyLoginName @"login_name"
#define kItemKeyGender @"gender"
#define kItemKeySerialNumber @"serial_number"
#define kItemKeyEmail @"email"
#define kItemKeyPhone @"phone"

@interface LEProfileViewController () <UITableViewDataSource, UITableViewDelegate, LEProfileEditViewControllerDelegate>
{
    NSArray * profileItems;//用于备份被更改前的数据；
}
@property (strong, nonatomic) IBOutlet UIImageView *profileIconImageView;
@property (strong, nonatomic) IBOutlet UITableView *profileItemsTableView;

@property (strong, nonatomic) NSArray* profileItems;

@property (strong, nonatomic) UIBarButtonItem *saveButton;

@property (strong, nonatomic) NSString *editingItemKey;

@property (strong, nonatomic) LEAccount *editingAccount;

@end

@implementation LEProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = kPageTitle;
    
    LEAccount* account = [LEAccountService sharedService].account;
    self.editingAccount = [account copy];
    NSString * loginname = UserDefault(nil, @"loginname");

    self.profileItems = @[@{ @"label": @"用户名", @"value": loginname, @"key": kItemKeyLoginName},
                          @{ @"label": @"姓名", @"value": (account.userName == nil) ? @"" : account.userName, @"key": kItemKeyUserName},
                          @{ @"label": @"性别", @"value": [NSNumber numberWithInt:account.sex], @"key": kItemKeyGender},
                          @{ @"label": @"学号", @"value":(account.studentId == nil) ? @"" : account.studentId, @"key": kItemKeySerialNumber},
                          @{ @"label": @"邮箱", @"value": (account.email == nil) ? @"" : account.email, @"key": kItemKeyEmail},
                          @{ @"label": @"电话", @"value": (account.phone == nil) ? @"" : account.phone, @"key": kItemKeyPhone} ];
    profileItems = [NSArray arrayWithArray:self.profileItems];
    if (account.sex == LEUserSexTypeFemale) {
        self.profileIconImageView.image = [UIImage imageNamed:@"menu_view_controller_header_female"];
    } else {
        self.profileIconImageView.image = [UIImage imageNamed:@"menu_view_controller_header_male"];
    }
    //
    //    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveButton:)];
    //
    //    saveButton.tintColor = [UIColor grayColor];
    //
    //    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
    //                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
    //                                       target:nil action:nil];
    //    negativeSpacer.width = 5;
    //
    //    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: negativeSpacer, saveButton, nil]];
    //
    //    self.saveButton = saveButton;
    //
    //    [self.saveButton setEnabled:NO];
    
}

- (void)clickSaveButton:(id)sender {
    [self showIndicatorView];
    [[LEAccountService sharedService] updateAccount:self.editingAccount success:^(LEAccountService *service, LEAccount *account) {
        [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
        if (account.sex == LEUserSexTypeFemale) {
            self.profileIconImageView.image = [UIImage imageNamed:@"menu_view_controller_header_female"];
        } else {
            self.profileIconImageView.image = [UIImage imageNamed:@"menu_view_controller_header_male"];
        }
        [self hideIndicatorView];
        //        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(LEAccountService *service, NSString *error) {
        [self hideIndicatorView];
        [MBProgressHUD showError:error toView:self.view];
        self.profileItems = nil;
        self.profileItems = [NSArray arrayWithArray:profileItems];
        [self.profileItemsTableView reloadData];
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.profileItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LEProfileViewControllerTableViewCell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSDictionary* item = [self.profileItems objectAtIndexedSubscript:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"label"];
    cell.textLabel.font = [UIFont systemFontOfSize:kTableViewIconSize];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    UILabel *tslabel  = [[UILabel alloc]initWithFrame:CGRectMake(70, 18, 80, 18)];
    tslabel.text = @"(不可修改)";
    tslabel.textColor = [UIColor grayColor];
    tslabel.font = [UIFont systemFontOfSize:12];
    UILabel *username = [[UILabel alloc]initWithFrame:CGRectMake(0, 17 , ScreenWidth-38, 18)];
    
    [cell addSubview:username];
    [cell addSubview:tslabel];
    if ([[item objectForKey:@"key"] isEqualToString:kItemKeyLoginName]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        tslabel.hidden = NO;
        username.hidden = NO;
        username.text = [item objectForKey:@"value"];
        username.font = [UIFont systemFontOfSize:kTableViewIconSize];
        username.textColor = [UIColor grayColor];
        username.textAlignment = NSTextAlignmentRight;
        return cell;
    }else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        tslabel.hidden = YES;
        tslabel.hidden = YES;
    }
    if ([[item objectForKey:@"key"] isEqualToString:kItemKeyGender]) {
        NSNumber* value = [item objectForKey:@"value"];
        NSString* valueDisplay = @"";
        if ([value intValue] == LEUserSexTypeFemale) {
            valueDisplay = @"女";
        } else if ([value intValue] == LEUserSexTypeMale) {
            valueDisplay = @"男";
        }
        cell.detailTextLabel.text = valueDisplay;
    } else {
        cell.detailTextLabel.text = [item objectForKey:@"value"];
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kTableViewIconSize];
    cell.detailTextLabel.textColor = [UIColor grayColor];
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
    return kTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 ) {
        return;
    }
    NSDictionary* item = [self.profileItems objectAtIndexedSubscript:indexPath.row];
    NSString* key = [item objectForKey:@"key"];
    
    if (![key isEqualToString:kItemKeyGender]){
        [tableView deselectRowAtIndexPath: indexPath animated: YES];
        self.editingItemKey = key;
        LEProfileEditViewController* viewController = [[LEProfileEditViewController alloc] initWithDictionary:item];
        viewController.delegate = self;
        [self presentViewController:viewController animated:YES completion:nil];
    } else  {
        [tableView deselectRowAtIndexPath: indexPath animated: YES];
        self.editingItemKey = key;
        NSNumber* value = [item objectForKey:@"value"];
        LEProfileEditViewController* viewController = [[LEProfileEditViewController alloc] initWithGender:[value intValue]];
        viewController.delegate = self;
        [self presentViewController:viewController animated:YES completion:nil];
    }
    
}

#pragma mark - LEProfileEditViewControllerDelegate
- (void)confirmProfileDictionary:(NSDictionary *)account{
    NSString *value = [account objectForKey:@"value"];
    NSString *type = [account objectForKey:@"key"];
    if ([type isEqualToString:kItemKeyUserName]) {
        self.editingAccount.userName = value;
    }else if ([type isEqualToString:kItemKeySerialNumber]) {
        value = [account objectForKey:@"value"];
        self.editingAccount.studentId = value;
    }else if ([type isEqualToString:kItemKeyEmail]) {
        value = [account objectForKey:@"value"];
        self.editingAccount.email = value;
    }else if ([type isEqualToString:kItemKeyPhone]) {
        value = [account objectForKey:@"value"];
        self.editingAccount.phone = value;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@", [account objectForKey:@"key"]];
    NSArray *filtered = [self.profileItems filteredArrayUsingPredicate:predicate];
    if ([filtered count] > 0) {
        NSDictionary* originalItem = [filtered objectAtIndex:0];
        NSMutableDictionary* updatedItem = [originalItem mutableCopy];
        [updatedItem setValue:value forKey:@"value"];
        NSMutableArray* profileItems = [self.profileItems mutableCopy];
        [profileItems replaceObjectAtIndex:[self.profileItems indexOfObject:originalItem] withObject:updatedItem];
        self.profileItems = profileItems;
        [self.profileItemsTableView reloadData];
        //        [self.saveButton setEnabled:YES];
        [self clickSaveButton:nil];
    }
}

- (void)confirmProfileGenderEdit:(LEUserSexType)sexType {
    self.editingAccount.sex = sexType;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@", kItemKeyGender];
    NSArray *filtered = [self.profileItems filteredArrayUsingPredicate:predicate];
    if ([filtered count] > 0) {
        NSDictionary* originalItem = [filtered objectAtIndex:0];
        NSMutableDictionary* updatedItem = [originalItem mutableCopy];
        [updatedItem setValue:[NSNumber numberWithInt:sexType] forKey:@"value"];
        NSMutableArray* profileItems = [self.profileItems mutableCopy];
        [profileItems replaceObjectAtIndex:[self.profileItems indexOfObject:originalItem] withObject:updatedItem];
        self.profileItems = profileItems;
        [self.profileItemsTableView reloadData];
        [self clickSaveButton:nil];
        //        [self.saveButton setEnabled:YES];
    }
}
@end
