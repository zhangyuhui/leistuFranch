//
//  LENavigationController.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/29/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LENavigationController.h"
#import "LELoginViewController.h"
#import "LEMenuViewController.h"

@interface LENavigationController ()

@end

@implementation LENavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LEMenuViewController* menuViewController = [[LEMenuViewController alloc] init];
    
    CGRect frame = menuViewController.view.frame;
    frame.size.width = frame.size.width - self.portraitSlideOffset;
    menuViewController.view.frame = frame;
    [menuViewController.view setFrame:frame];
    
    self.leftMenu = menuViewController;
    
}


#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    [super navigationController:navigationController willShowViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    NSArray *viewControllers = [self viewControllers];
    UIViewController* rootViewController = [viewControllers objectAtIndex:0];
    if ([rootViewController isKindOfClass:[LELoginViewController class]] &&
        [viewControllers count] > 1){
        if ([rootViewController respondsToSelector:@selector(removeFromParentViewController)]){
            [rootViewController removeFromParentViewController];
        }else{
            NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
            [viewControllers removeObjectAtIndex:0];
            self.navigationController.viewControllers = viewControllers;
        }
    }
}

@end
