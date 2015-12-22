//
//  LEMainViewController.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/27/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEMainViewController.h"
#import "LELoginViewController.h"
#import "LEMenuViewController.h"
#import "SlideNavigationController.h"
#import "LEMainViewControlerCellViewTableViewCell.h"
#import "LECourseService.h"
#import "LECourseLessonsViewController.h"
#import "LEDefines.h"
#import "FMDatabase.h"
#import "JKDBHelper.h"
#import "LEPraciceCheckerView.h"
#import "LEBrowserViewController.h"
#import "LEAccount.h"
#import "LEAccountService.h"
#import "LEProfileViewController.h"
#import "GuideView.h"
#define kMainViewControllerSwitchTableViewDuration 0.3

@interface LEMainViewController () <SlideNavigationControllerDelegate, LETabMenuViewDelegate, UITableViewDataSource, UITableViewDelegate, LEMainViewControlerCellViewTableViewCellDelegate,LEPraciceCheckerViewDelegate>
{
    NSInteger tableViewIndex;
}
@property (strong, nonatomic) IBOutlet LETabMenuView *tabMenuView;
@property (strong, nonatomic) IBOutlet LEBaseTableView *coursesTableView;
@property (strong, nonatomic) IBOutlet LEBaseTableView *ongoingCoursesTableView;
@property (strong, nonatomic) IBOutlet LEBaseTableView *expiredCoursesTableView;

- (void)handleRefresh:(id)sender;
- (void)handleSwipe:(id)sender;
- (UITableView*)getTableView:(NSInteger)tag;
- (void)updateCourses:(NSArray*)courses;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray* courses;
@property (strong, nonatomic) NSArray* ongoingCourses;
@property (strong, nonatomic) NSArray* expiredCourses;

@end

@implementation LEMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //增加指示页
    NSString *string = UserNameDefault(nil, @"main_userguide", @"main_userguide");
    if ([ORNULL(string) isEqualToString:@""]) {
        UserNameDefault(@"main_userguide", @"main_userguide", @"main_userguide");
        GuideView *guideView = [[GuideView alloc]initType:2];
        [guideView show];
    }
    self.navigationItem.title = @"课程";
    self.tabMenuView.leftMenuLabel = @"全部";
    self.tabMenuView.middleMenuLabel = @"进行中";
    self.tabMenuView.rightMenuLabel = @"已过期";
    self.tabMenuView.delegate = self;
//    LECourseService* courseService = [LECourseService sharedService];
//        static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [FMDatabase databaseWithPath:[JKDBHelper dbPath]];
//    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRefresh:) name:@"refreshMainView" object:nil];
    self.coursesTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.coursesTableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.coursesTableView.tableViewIndex = 1;
    self.ongoingCoursesTableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.ongoingCoursesTableView.tableViewIndex = 2;
    self.expiredCoursesTableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    self.expiredCoursesTableView.tableViewIndex = 3;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.coursesTableView addSubview:self.refreshControl];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"course_activate_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"course_activate_click"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightBarButtonItems:[NSArray arrayWithObjects:button, nil]];

    [[LECourseService sharedService] restore];
    [self updateCourses:[LECourseService sharedService].courses];
    
//    double delayInSeconds = 1.0;
    //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
//    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //推迟两纳秒执行
//    dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){

    [FMDatabase databaseWithPath:[JKDBHelper dbPath]];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.35f];
//        [[LECourseService sharedService] getStudyCoursesAndRecords:^(LECourseService *service, NSArray *courses, NSArray *records) {
//            [self updateCourses:[LECourseService sharedService].courses];
//        } failure:^(LECourseService *service, NSString *error) {
//            
//        }];
//    });
}
- (void) loadData{
    [FMDatabase databaseWithPath:[JKDBHelper dbPath]];
    [[LECourseService sharedService] getStudyCoursesAndRecords:^(LECourseService *service, NSArray *courses, NSArray *records) {
        [self updateCourses:[LECourseService sharedService].courses];
    } failure:^(LECourseService *service, NSString *error) {
        
    }];
    if ([self.ongoingCourses count]>0) {
        [self.tabMenuView clickMenuButton:self.tabMenuView.middleMenuButton];
        
    }else
    {
        [self.tabMenuView.leftMenuButton setSelected:YES];
    }
}

- (void)clickAddButton:(id)sender
{
    
    LEBrowserViewController *browserView =[[LEBrowserViewController alloc] init];
    browserView.title = @"激活";
    LEAccount* account = [LEAccountService sharedService].account;
    browserView.url = [NSString stringWithFormat:@"http://m.longmanenglish.cn/views/jsp/activeCard.jsp?isMobile=true&token=%@",account.token];
    [self presentViewController:browserView animated:YES completion:nil];
//    LEPraciceCheckerView *alert = [[LEPraciceCheckerView alloc]initWithType:0 Delegate:self];
//    [alert show];

}
-(void)alertView:(LEPraciceCheckerView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString * string = [NSString stringWithFormat:@"%ld",buttonIndex];
    SHOWHUD(string);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.canBack = NO;
    [self.coursesTableView reloadData];
    [self.ongoingCoursesTableView reloadData];
    [self.expiredCoursesTableView reloadData];
}

- (UITableView*)getTableView:(NSInteger)tag {
    if (tag == 0) {
        return self.coursesTableView;
    } else if (tag == 1) {
        return self.ongoingCoursesTableView;
    } else {
        return self.expiredCoursesTableView;
    }
}

- (void)switchCoursesTableView:(UITableView*)fromTableView toTableView:(UITableView*)toTableView {
    BOOL toLeft = toTableView.tag > fromTableView.tag;
    CGFloat translationX = self.view.frame.size.width*( toLeft ? -1.0 : 1.0);
    
    CABasicAnimation *toAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    toAnimation.delegate = self;
    toAnimation.fromValue = [NSNumber numberWithFloat:-translationX];
    toAnimation.toValue = [NSNumber numberWithFloat:0];
    toAnimation.repeatCount = 0;
    toAnimation.duration = kMainViewControllerSwitchTableViewDuration;
    toAnimation.beginTime = 0;
    toAnimation.removedOnCompletion = NO;
    toAnimation.fillMode = kCAFillModeForwards;
    toAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [toAnimation setValue:@"to_animation" forKey:@"animation_id"];
    [toAnimation setValue:toTableView forKey:@"animation_view"];
    [toTableView.layer addAnimation:toAnimation forKey:@"to_animation"];
    
    CABasicAnimation *fromAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    fromAnimation.delegate = self;
    //fromAnimation.fromValue = [NSNumber numberWithFloat:fromTableView.frame.origin.x];
    fromAnimation.toValue = [NSNumber numberWithFloat:translationX];
    fromAnimation.repeatCount = 0;
    fromAnimation.removedOnCompletion = NO;
    fromAnimation.fillMode = kCAFillModeForwards;
    fromAnimation.duration = kMainViewControllerSwitchTableViewDuration;
    fromAnimation.beginTime = 0;
    fromAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [fromAnimation setValue:@"from_animation" forKey:@"animation_id"];
    [fromAnimation setValue:fromTableView forKey:@"animation_view"];
    [fromTableView.layer addAnimation:fromAnimation forKey:@"from_animation"];
}


-(void)animationDidStart:(CAAnimation *)animation {
    if([[animation valueForKey:@"animation_id"] isEqual:@"to_animation"]) {
        UIView* toView = [animation valueForKey:@"animation_view"];
        toView.hidden = NO;
    }
}

-(void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
    if([[animation valueForKey:@"animation_id"] isEqual:@"from_animation"]) {
        UIView* toView = [animation valueForKey:@"animation_view"];
        toView.hidden = YES;
    }
}

- (void)updateCourses:(NSArray*)courses {
    self.courses = courses;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    BOOL (^isExpired)(LECourse*) = ^BOOL(LECourse* course) {
        NSDate* date = [formatter dateFromString: course.limit];
        return [date compare:[NSDate date]] == NSOrderedAscending;
    };
    
    NSIndexSet* ongoingCoursesIndexSet = [self.courses indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        LECourse* course = obj;
        return (course.status > LECourseStatusStudyReady && !isExpired(course));
    }];
    self.ongoingCourses = [self.courses objectsAtIndexes:ongoingCoursesIndexSet];
    
    NSIndexSet* expiredCoursesIndexSet = [self.courses indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        LECourse* course = obj;
        return (isExpired(course));
    }];
    self.expiredCourses = [self.courses objectsAtIndexes:expiredCoursesIndexSet];
    [self.coursesTableView reloadData];
}

#pragma mark - SlideNavigationControllerDelegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu {
    return NO;
}

#pragma mark - LETabMenuViewDelegate

- (void)tabMenuView:(LETabMenuView*)tabMenuView didSelectTab:(NSInteger)to from:(NSInteger)from {
    //    UITableView* fromTableView = [self getTableView:from];
    //    UITableView* toTableView = [self getTableView:to];
    //    [self switchCoursesTableView:fromTableView toTableView:toTableView];
    
}

- (void)tabMenuView:(LETabMenuView*)tabMenuView willSelectTab:(NSInteger)to from:(NSInteger)from {
    if (from==0) {
        [self.tabMenuView.leftMenuButton setSelected:NO];
    }
    tableViewIndex = to;
    UITableView* fromTableView = [self getTableView:from];
    UITableView* toTableView = [self getTableView:to];
    [self switchCoursesTableView:fromTableView toTableView:toTableView];
    self.tabMenuView.leftMenuButton.enabled = NO;
    self.tabMenuView.middleMenuButton.enabled = NO;
    self.tabMenuView.rightMenuButton.enabled = NO;
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(f1) userInfo:nil repeats:NO];
}
- (void)f1{
    self.tabMenuView.leftMenuButton.enabled = YES;
    self.tabMenuView.middleMenuButton.enabled = YES;
    self.tabMenuView.rightMenuButton.enabled = YES;
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* courses = nil;
    if (tableView == self.ongoingCoursesTableView) {
        courses = self.ongoingCourses;
    } else if (tableView == self.expiredCoursesTableView) {
        courses = self.expiredCourses;
    } else {
        courses = self.courses;
    }
    
    if (courses == nil) {
        return 0;
    }
    return [courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LEMainViewControlerCellViewTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [LEMainViewControlerCellViewTableViewCell mainViewControlerCellViewTableViewCell];
    }
    
    LEMainViewControlerCellViewTableViewCell* mainViewControlerCellViewTableViewCell = (LEMainViewControlerCellViewTableViewCell*)cell;
    mainViewControlerCellViewTableViewCell.delegate = self;
    NSMutableArray *courseArray ;
    if (tableView == self.ongoingCoursesTableView) {
        courseArray = [NSMutableArray arrayWithArray:self.ongoingCourses];
    } else if (tableView == self.expiredCoursesTableView) {
        courseArray = [NSMutableArray arrayWithArray:self.expiredCourses];
    } else {
        courseArray = [NSMutableArray arrayWithArray:self.courses];
    }
    mainViewControlerCellViewTableViewCell.course = [courseArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.courses count] - 1) {
        return 260;
    }
    return 250;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    //    LECourse* course;
    //    if (tableView == self.ongoingCoursesTableView) {
    //        course = [self.ongoingCourses objectAtIndex:indexPath.row];
    //    } else if (tableView == self.expiredCoursesTableView) {
    //        course = [self.expiredCourses objectAtIndex:indexPath.row];
    //    } else {
    //        course = [self.courses objectAtIndex:indexPath.row];
    //    }
    //
    //    if (course.status == LECourseStatusStudying) {
    //        LECourseLessonsViewController* viewController = [[LECourseLessonsViewController alloc] initWithCourse:course];
    //        [self.navigationController pushViewController:viewController animated:YES];
    //    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    UITableView *tableView = (UITableView *)scrollView;
    NSArray* tableCells = [tableView visibleCells];
    for (NSIndexPath *cell in tableCells) {
        ((LEMainViewControlerCellViewTableViewCell*)cell).scrolling = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        UITableView *tableView = (UITableView *)scrollView;
        NSArray* tableCells = [tableView visibleCells];
        for (NSIndexPath *cell in tableCells) {
            ((LEMainViewControlerCellViewTableViewCell*)cell).scrolling = NO;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    UITableView *tableView = (UITableView *)scrollView;
    NSArray* tableCells = [tableView visibleCells];
    for (NSIndexPath *cell in tableCells) {
        ((LEMainViewControlerCellViewTableViewCell*)cell).scrolling = NO;
    }
}


#pragma mark - Swip Gesture Recognizer
- (void)handleSwipe:(UISwipeGestureRecognizer*)sender {
    //    if (sender.direction == UISwipeGestureRecognizerDirectionRight){
    //        NSLog(@"Swip right");
    //    } else {
    //        NSLog(@"Swip left");
    //    }
}

#pragma mark - Refresh Control
- (void)handleRefresh:(id)sender {
    [[LECourseService sharedService] getStudyCourses:^(LECourseService *service, NSArray *courses) {
        [self updateCourses:courses];
//        [self.coursesTableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(LECourseService *service, NSString *error) {
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - LEMainViewControlerCellViewTableViewCellDelegate
- (void)mainViewControlerCellViewTableViewCell:(LEMainViewControlerCellViewTableViewCell*)cellView downloadCourse:(LECourse*)course {
    [[LECourseService sharedService] startDownloadCourse:course];
}

- (void)mainViewControlerCellViewTableViewCell:(LEMainViewControlerCellViewTableViewCell*)cellView studyCourse:(LECourse*)course {
    if (course.status == LECourseStatusStudyReady) {
        course.status = LECourseStatusStudying;
        [self updateCourses:self.courses];
    }
    LECourseLessonsViewController* viewController = [[LECourseLessonsViewController alloc] initWithCourse:course];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
