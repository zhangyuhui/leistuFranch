//
//  AppDelegate.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/11/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEAppDelegate.h"
#import "LEMainViewController.h"
#import "LELoginViewController.h"
#import "LEAccountService.h"
#import "LECourseService.h"
#import "LEConstants.h"
#import "iflyMSC/IFlyMSC.h"
#import "AFNetworkReachabilityManager.h"
#import "LEDefines.h"
#import "DXAlertView.h"
#import "LEWelcomeViewController.h"
#import "MobClick.h"
@interface LEAppDelegate () <UINavigationControllerDelegate>

@end

@implementation LEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [IFlySetting setLogFile:LVL_ALL];
//    [IFlySetting showLogcat:YES];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachePath = [paths objectAtIndex:0];
//    [IFlySetting setLogFilePath:cachePath];
    [MobClick startWithAppkey:@"56694e5867e58e67d1001c1c" reportPolicy:BATCH channelId:nil];;
    
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", @"5519064b"];
    [IFlySpeechUtility createUtility:initString];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"launchscreen_background"]];
    [self.window makeKeyAndVisible] ;
    LEAccountService* accountService = [LEAccountService sharedService];
//    LECourseService* courseService = [LECourseService sharedService];
//    if (accountService.account && courseService.records && courseService.courses != nil && [courseService.courses count] > 0) {
    if (accountService.account) {
        LEMainViewController* mainViewController = [[LEMainViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:mainViewController animated:NO];
    } else {
        NSString * AppFirstLoad =  UserNameDefault(nil, @"AppFirstLoad", @"AppFirstLoad");
        if ([AppFirstLoad isEqual:[NSNull null]]||!AppFirstLoad||[AppFirstLoad isEqualToString:@""]) {
            [self.navigationController setNavigationBarHidden:YES];
            LEWelcomeViewController *vc = [[LEWelcomeViewController alloc]initWithNibName:nil bundle:nil];
            vc.loginBlock=^(){
                [self.navigationController setNavigationBarHidden:NO];
                UserNameDefault(@"AppFirstLoad", @"AppFirstLoad", @"AppFirstLoad");
                LELoginViewController* loginViewController = [[LELoginViewController alloc] initWithNibName:nil bundle:nil];
                [self.navigationController pushViewController:loginViewController animated:YES];
            };
            [self.navigationController pushViewController:vc animated:NO];
            return YES;
        }else{
            LELoginViewController* loginViewController = [[LELoginViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:loginViewController animated:NO];
        }
    }
    double delayInSeconds = 50.0;
    //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //推迟两纳秒执行
    dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        [[LEAccountService sharedService]checkAppVersonSuccess:^(NSString *updateInfo) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"班级归档后:" contentText:updateInfo leftButtonTitle:@"暂不安装" rightButtonTitle:@"现在安装"];
                [alert show];
                alert.rightBlock=^(){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/jiao-hu-ying-yu/id921453267?mt=8&uo=4"]];
                };
            });
           
        } failure:^(NSString *error) {
            
        }];

    });
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //Services
//    [[LECourseService sharedService] persistent];
//    [[LECourseService sharedService] stopAllDownloads];
//    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    @try {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLENotificationApplicationWillResignActive object:nil userInfo:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        
    }

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification postNotificationName:kLENotificationApplicationDidBecomeActive object:nil userInfo:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //Services
    [[LECourseService sharedService] stopAllDownloads];
    [[LECourseService sharedService] persistent];
}

@end
