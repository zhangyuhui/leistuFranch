//
//  LEMenuViewController.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/29/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEMenuViewController.h"
#import "LEMenuViewControllerCellView.h"
#import "LEAccountService.h"
#import "LENavigationController.h"
#import "LEHomeworkViewController.h"
#import "LEClassViewController.h"
#import "LESettingViewController.h"
#import "LEAccount.h"
#import "LEConstants.h"
#import "LECourseService.h"
#import "LEDefines.h"
#import "LEProfileViewController.h"
#define kMenuViewControllerSyncAnimationDuration 0.5

typedef enum {
    LEMenuItemTypeCourse   = 0,
    LEMenuItemTypeClass    = 3,
    LEMenuItemTypeHomework = 2,
    LEMenuItemTypeSetting  = 1
} LEMenuItemType;

@interface LEMenuItem : NSObject
@property (strong, nonatomic) NSString* image;
@property (strong, nonatomic) NSString* text;
@end

@implementation LEMenuItem
@synthesize image;
@synthesize text;
@end

@interface LEMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *schoolLabel;
@property (strong, nonatomic) IBOutlet UILabel *syncTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *syncActionImageButton;
@property (strong, nonatomic) IBOutlet UIButton *syncActionLabelButton;
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;

@property (strong, nonatomic) UIView *indicatorOverlayView;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

-(IBAction)clickSyncButton:(id)sender;

@property (strong, nonatomic) NSArray* menuItems;
-(void)startSyncAnimation;
-(void)stopSyncAnimation;

@end

@implementation LEMenuViewController
@synthesize menuItems = _menuItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
    NSDate * senddate = UserNameDefault(nil, @"syncTime", [NSString stringWithFormat:@"syncTime%@",userId]);
    ORNULL(senddate);
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"locationString:%@",locationString);
    if (!locationString||[locationString isEqual:[NSNull null]]||[locationString isEqualToString:@""]) {
        _syncTimeLabel.text = @"未同步";
    }else
    _syncTimeLabel.text = [NSString stringWithFormat:@"上次同步时间：%@",locationString];
    
    [self.menuTableView setScrollEnabled:YES];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.schoolLabel.textColor = [UIColor whiteColor];
    self.menuItems = @[@{ @"image": @"course", @"text": @"课程", @"view": @""},
                       //                       @{ @"image": @"class", @"text": @"班级"},
                       //                       @{ @"image": @"homework", @"text": @"作业"},
                       @{ @"image": @"setting", @"text": @"设置"} ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAccountDidChange:) name:kLENotificationAccountDidChange object:nil];
    
    LEAccountService* accountService = [LEAccountService sharedService];
    [self updateProfileDisplay:accountService.account];
    self.menuTableView.tableFooterView = [[UIView alloc]init];
    [self addIndicatorView];
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLENotificationAccountDidChange object:nil];
}


-(IBAction)clickSyncButton:(id)sender {
    if (!self.syncActionImageButton.selected) {
        self.syncActionImageButton.selected = YES;
        [UIView performWithoutAnimation:^{
            [self.syncActionLabelButton setTitle:@"正在同步..." forState:UIControlStateNormal];
            [self.syncActionLabelButton setTitle:@"正在同步..." forState:UIControlStateHighlighted];
            [self.syncActionLabelButton setTitle:@"正在同步..." forState:UIControlStateSelected];
            [self.syncActionLabelButton layoutIfNeeded];
        }];
        [self startSyncAnimation];
        
        [self showIndicatorView];
        LECourseService* courseService = [LECourseService sharedService];
        [courseService uploadStudyRecords:courseService.records success:^(LECourseService *service) {
            [self hideIndicatorView];
            NSDate * senddate=[NSDate date];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSString *  locationString=[dateformatter stringFromDate:senddate];
            NSLog(@"locationString:%@",locationString);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSNumber* userId = [userDefaults objectForKey:kLENetworkConnectionUserId];
            UserNameDefault(senddate, @"syncTime", [NSString stringWithFormat:@"syncTime%@",userId]);
            _syncTimeLabel.text = [NSString stringWithFormat:@"上次同步时间：%@",locationString];
            self.syncActionImageButton.selected = NO;
            [UIView performWithoutAnimation:^{
                [self.syncActionLabelButton setTitle:@"同步学习记录" forState:UIControlStateNormal];
                [self.syncActionLabelButton setTitle:@"同步学习记录" forState:UIControlStateHighlighted];
                [self.syncActionLabelButton setTitle:@"同步学习记录" forState:UIControlStateSelected];
                [self.syncActionLabelButton layoutIfNeeded];
            }];
            [self stopSyncAnimation];
        } failure:^(LECourseService *service, NSString *error) {
            [self hideIndicatorView];
            self.syncActionImageButton.selected = NO;
            [UIView performWithoutAnimation:^{
                [self.syncActionLabelButton setTitle:@"同步学习记录" forState:UIControlStateNormal];
                [self.syncActionLabelButton setTitle:@"同步学习记录" forState:UIControlStateHighlighted];
                [self.syncActionLabelButton setTitle:@"同步学习记录" forState:UIControlStateSelected];
                [self.syncActionLabelButton layoutIfNeeded];
            }];
            [self stopSyncAnimation];
            
            if (error != nil) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"同步出错"
//                                                                message:@"同步学习记录出错."
//                                                               delegate:self
//                                                      cancelButtonTitle:@"确定"
//                                                      otherButtonTitles:nil];
//                [alert show];
            }
        }];
    } else {
        self.syncActionImageButton.selected = NO;
        [UIView performWithoutAnimation:^{
            [self.syncActionLabelButton setTitle:@"同步学习记录" forState:UIControlStateNormal];
            [self.syncActionLabelButton setTitle:@"同步学习记录" forState:UIControlStateHighlighted];
            [self.syncActionLabelButton setTitle:@"同步学习记录" forState:UIControlStateSelected];
            [self.syncActionLabelButton layoutIfNeeded];
        }];
        [self stopSyncAnimation];
    }
}

-(void)startSyncAnimation {
    [UIView animateWithDuration:kMenuViewControllerSyncAnimationDuration delay:0.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
        self.syncActionImageButton.transform = transform;
    } completion:NULL];
}

-(void)stopSyncAnimation {
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        self.syncActionImageButton.transform = transform;
    } completion:NULL];
}

- (void)handleAccountDidChange:(NSNotification *)notification {
    LEAccount* account = [notification object];
    [self updateProfileDisplay:account];
}

- (void)updateProfileDisplay:(LEAccount*)account {
    self.nameLabel.text = (account.userName)?account.userName:@"";
    NSString* schollDisplay = [NSString stringWithFormat:@"%@ %@", (account.className == nil)?@"":account.className, (account.school == nil)?@"":account.school];
    self.schoolLabel.text = [schollDisplay stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (account.sex == LEUserSexTypeFemale) {
        self.iconImageView.image = [UIImage imageNamed:@"menu_view_controller_header_female"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"menu_view_controller_header_male"];
    }
}

- (void)addIndicatorView {
    self.indicatorOverlayView = [[UIView alloc] init];
    self.indicatorOverlayView.backgroundColor = [UIColor clearColor];
    [self.indicatorOverlayView setTranslatesAutoresizingMaskIntoConstraints: NO];
    self.indicatorOverlayView.hidden = YES;
    [self.view addSubview:self.indicatorOverlayView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorOverlayView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorOverlayView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorOverlayView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorOverlayView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.color = [UIColor blackColor];
    [self.indicatorView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [self.indicatorOverlayView addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    self.indicatorView.hidesWhenStopped = YES;
    
    [self.indicatorOverlayView addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.indicatorOverlayView
                                                                          attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1.0
                                                                           constant:0]];
    
    [self.indicatorOverlayView addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView
                                                                          attribute:NSLayoutAttributeCenterY
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.indicatorOverlayView
                                                                          attribute:NSLayoutAttributeCenterY
                                                                         multiplier:1.0
                                                                           constant:0]];
    
}

- (void)showIndicatorView {
    self.indicatorOverlayView.hidden = NO;
}

- (void)hideIndicatorView {
    self.indicatorOverlayView.hidden = YES;
}

- (BOOL)isIndicatorViewShown {
    return self.indicatorOverlayView.hidden == NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LEMenuViewControllerCellView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [LEMenuViewControllerCellView menuViewControllerCellView];
    }
    
    
    LEMenuViewControllerCellView* menuViewControllerCellView = (LEMenuViewControllerCellView*)cell;
    
    NSDictionary* menuItem = [self.menuItems objectAtIndex:indexPath.row];
    NSString* menuItemText = [menuItem objectForKey:@"text"];
    NSString* menuItemImage = [menuItem objectForKey:@"image"];
    
    menuViewControllerCellView.menuImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_view_controller_menu_%@_normal", menuItemImage]];
    menuViewControllerCellView.menuImageView.highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"menu_view_controller_menu_%@_highlight", menuItemImage]];
    menuViewControllerCellView.menuLabel.text = menuItemText;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    SlideNavigationController* slideNavigationController = [SlideNavigationController sharedInstance];
    
//    slideNavigationController
    switch (indexPath.row) {
        case LEMenuItemTypeCourse:
            [slideNavigationController popToRootViewControllerAnimated:YES];
            break;
        case LEMenuItemTypeClass: {
            LEClassViewController* viewController = [[LEClassViewController alloc] initWithNibName:nil bundle:nil];
            [slideNavigationController popToRootAndSwitchToViewController:viewController withSlideOutAnimation:NO andCompletion:^{
                
            }];
        }
            break;
        case LEMenuItemTypeHomework: {
            LEHomeworkViewController* viewController = [[LEHomeworkViewController alloc] initWithNibName:nil bundle:nil];
            [slideNavigationController popToRootAndSwitchToViewController:viewController withSlideOutAnimation:NO andCompletion:^{
                
            }];
        }
            break;
        case LEMenuItemTypeSetting: {
            LESettingViewController* viewController = [[LESettingViewController alloc] initWithNibName:nil bundle:nil];
            [slideNavigationController popToRootAndSwitchToViewController:viewController withSlideOutAnimation:NO andCompletion:^{
                
            }];
        }
            break;
        default:
            break;
    }
}


@end
