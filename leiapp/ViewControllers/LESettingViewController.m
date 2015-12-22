//
//  LESettingViewController.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/30/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LESettingViewController.h"
#import "LESettingViewSectionView.h"
#import "LESettingViewTableViewCell.h"
#import "LEPreferenceService.h"
#import "LEProfileViewController.h"
#import "LEPasswordVerifyViewController.h"
#import "LECourseClearViewController.h"
#import "LESettingOptionsViewController.h"
#import "LEAboutViewController.h"
#import "LEConstants.h"
#import "LEAccountService.h"
#import "LELoginViewController.h"

typedef NS_ENUM(NSInteger, LESettingItemMode) {
    LESettingItemModelAction = 0,
    LESettingItemModelSelection,
    LESettingItemModelSwitch
};

#define kSettingsProfile        1
#define kSettingsPasswordChange 2
#define kSettingsClearDownload  3
#define kSettingsFont           4
#define kSettingsDownloadInWifi 5
//#define kSettingsSyncInWifi     5
#define kSettingsNotification   6
#define kSettingsAbout          7

#define kPageTitle @"设置"
#define kTableViewHeaderHeight 40
#define kTableViewRowHeight    50

@interface LESettingItem: NSObject
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* icon;
@property (assign, nonatomic) LESettingItemMode mode;
@property (strong, nonatomic) NSString* key;
@end

@implementation LESettingItem
@end

@interface LESettingGroup: NSObject
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSArray<LESettingItem*>* items;
@end

@implementation LESettingGroup
@end

@interface LESettingViewController () <UITableViewDataSource, UITableViewDelegate, LESettingViewTableViewCellDelegate, LESettingOptionsViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView* settingsTableView;
@property (strong, nonatomic) NSArray* settingItems;
- (void)setupSettingItems;

@end

@implementation LESettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = kPageTitle;
    [self setupSettingItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSettingItems {
    int key = 1;
    NSMutableArray* settingItems = [NSMutableArray new];
    {
        LESettingGroup* group = [[LESettingGroup alloc] init];
        group.name = @"帐号管理";
        NSMutableArray* items = [NSMutableArray new];
        {
            LESettingItem* item = [[LESettingItem alloc] init];
            item.name = @"个人资料";
            item.icon = @"profile";
            item.mode = LESettingItemModelAction;
            item.key = [NSString stringWithFormat:@"%d", key++];
            [items addObject:item];
        }
        {
            LESettingItem* item = [[LESettingItem alloc] init];
            item.name = @"修改密码";
            item.icon = @"password";
            item.mode = LESettingItemModelAction;
            item.key = [NSString stringWithFormat:@"%d", key++];
            [items addObject:item];
        }
        group.items = items;
        
        [settingItems addObject:group];
    }
    {
        LESettingGroup* group = [[LESettingGroup alloc] init];
        group.name = @"课程管理";
        NSMutableArray* items = [NSMutableArray new];
        {
            LESettingItem* item = [[LESettingItem alloc] init];
            item.name = @"清除下载课程";
            item.icon = @"clean";
            item.mode = LESettingItemModelAction;
            item.key = [NSString stringWithFormat:@"%d", key++];
            [items addObject:item];
        }
        group.items = items;
        
        [settingItems addObject:group];
    }
    {
        LESettingGroup* group = [[LESettingGroup alloc] init];
        group.name = @"通用设置";
        NSMutableArray* items = [NSMutableArray new];
        {
            LESettingItem* item = [[LESettingItem alloc] init];
            item.name = @"课程字体大小";
            item.icon = @"font";
            item.mode = LESettingItemModelSelection;
            item.key = [NSString stringWithFormat:@"%d", key++];
            [items addObject:item];
        }
        {
            LESettingItem* item = [[LESettingItem alloc] init];
            item.name = @"仅WiFi下载";
            item.icon = @"download";
            item.mode = LESettingItemModelSwitch;
            item.key = [NSString stringWithFormat:@"%d", key++];
            [items addObject:item];
        }
        {
            LESettingItem* item = [[LESettingItem alloc] init];
            item.name = @"消息提醒";
            item.icon = @"message";
            item.mode = LESettingItemModelSwitch;
            item.key = [NSString stringWithFormat:@"%d", key++];
            [items addObject:item];
        }
        group.items = items;
        
        [settingItems addObject:group];
    }
    {
        LESettingGroup* group = [[LESettingGroup alloc] init];
        group.name = @"关于我们";
        NSMutableArray* items = [NSMutableArray new];
        {
            LESettingItem* item = [[LESettingItem alloc] init];
            item.name = @"关于我们";
            item.icon = @"about";
            item.mode = LESettingItemModelAction;
            item.key = [NSString stringWithFormat:@"%d", key++];
            [items addObject:item];
        }
        group.items = items;
        
        [settingItems addObject:group];
    }
    
    self.settingItems = settingItems;
    
    CGRect  screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat buttonHeight = 40;
    CGFloat buttonWidth = screenWidth - 20;;
    CGFloat buttonX = 10;
    CGFloat buttonY = 10;
    
    UIView* tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60.0)];
    
    UIButton* logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    
    [logoutButton setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:18];
    logoutButton.backgroundColor = [UIColor redColor];
    logoutButton.layer.cornerRadius = 5;
    
    [logoutButton addTarget:self action:@selector(clickLogoutButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [tableFootView addSubview:logoutButton];
    
    self.settingsTableView.tableFooterView = tableFootView;
}

- (void)clickLogoutButton:(id)sender {
    [[LEAccountService sharedService] logoutUser];
    LELoginViewController* loginViewController = [[LELoginViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:loginViewController]];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settingItems ? [self.settingItems count] : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LESettingGroup* group = [self.settingItems objectAtIndex:section];
    return [group.items count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    LESettingGroup* group = [self.settingItems objectAtIndex:section];
    return group.name;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableViewHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewRowHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LESettingViewSectionView* view = [[LESettingViewSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kTableViewHeaderHeight)];
    LESettingGroup* group = [self.settingItems objectAtIndex:section];
    view.titleLabel.text = group.name;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LESettingGroup* group = [self.settingItems objectAtIndex:indexPath.section];
    LESettingItem* item = [group.items objectAtIndex:indexPath.row];
    
    LESettingViewTableViewCell *cell = [LESettingViewTableViewCell settingViewTableViewCell];
    cell.settingIconImage = [UIImage imageNamed:[NSString stringWithFormat:@"setting_viewcontroller_%@", item.icon]];
    cell.settingTitle = item.name;
    
    if (item.mode == LESettingItemModelSelection) {
        NSNumber* font = [[NSUserDefaults standardUserDefaults] objectForKey:kLEPreferneceKeyFont];
        int fontValue = (font == nil) ? 2: [font intValue];
        if (fontValue == 1) {
            cell.settingSelection = @"小";
        } else if (fontValue == 2) {
            cell.settingSelection = @"中";
        } else {
            cell.settingSelection = @"大";
        }
    } else if (item.mode == LESettingItemModelSwitch) {
//        if ([item.key intValue] == kSettingsSyncInWifi) {
//            cell.settingSwitch = [LEPreferenceService sharedService].syncInNoneWifi;
//        } else
            if ([item.key intValue] == kSettingsDownloadInWifi) {
            cell.settingSwitch = [LEPreferenceService sharedService].downloadInNoneWifi;
        }else if ([item.key intValue] == kSettingsNotification) {
            cell.settingSwitch = [LEPreferenceService sharedService].messageNotify;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    LESettingGroup* group = [self.settingItems objectAtIndex:indexPath.section];
    LESettingItem* item = [group.items objectAtIndex:indexPath.row];
    int key = [item.key intValue];
    
    if (key == kSettingsProfile) {
        LEProfileViewController* viewController = [[LEProfileViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (key == kSettingsPasswordChange) {
        LEPasswordVerifyViewController* viewController = [[LEPasswordVerifyViewController alloc] initWithNibName:nil bundle:nil];
        [self presentViewController:viewController animated:YES completion:nil];
    } else if (key == kSettingsClearDownload) {
        LECourseClearViewController* viewController = [[LECourseClearViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (key == kSettingsFont) {
        NSArray* fontLabels = @[ @"小", @"中", @"大"];
        NSArray* fontValues = @[ [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3]];
        
        NSNumber* fontValue = [[NSUserDefaults standardUserDefaults] objectForKey:kLEPreferneceKeyFont];
        LESettingOptionsViewController* viewController = [[LESettingOptionsViewController alloc] initWIthOptions:fontLabels optionsValues:fontValues optionValue:(fontValue == nil)?2:[fontValue intValue]];
        viewController.delegate = self;
        [self presentViewController:viewController animated:YES completion:nil];
    } else if (key == kSettingsAbout) {
        LEAboutViewController* viewController = [[LEAboutViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - LESettingViewTableViewCellDelegate
- (void)settingViewTableViewCell:(LESettingViewTableViewCell*)settingViewTableViewCell didSwitchValueChanged:(BOOL)value {
    NSIndexPath* indexPath = [self.settingsTableView indexPathForCell:settingViewTableViewCell];
    LESettingGroup* group = [self.settingItems objectAtIndex:indexPath.section];
    LESettingItem* item = [group.items objectAtIndex:indexPath.row];
    
//    if ([item.key intValue] == kSettingsSyncInWifi) {
//        [LEPreferenceService sharedService].syncInNoneWifi = value;
//    } else
    if ([item.key intValue] == kSettingsDownloadInWifi) {
        [LEPreferenceService sharedService].downloadInNoneWifi = value;
    } else if ([item.key intValue] == kSettingsNotification) {
        [LEPreferenceService sharedService].messageNotify = value;
    }
}

#pragma mark - LESettingOptionsViewControllerDelegate
- (void)confirmOptionValueEdit:(int)optionValue {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:optionValue] forKey:kLEPreferneceKeyFont];
    [self.settingsTableView reloadData];
}

@end
