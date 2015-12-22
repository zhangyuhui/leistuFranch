//
//  LECourseLessonsViewControllerMenuView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/15/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LECourseLessonsViewControllerMenu) {
    LECourseLessonsViewControllerMenuDetail = 0,
    LECourseLessonsViewControllerMenuRule,
    LECourseLessonsViewControllerMenuVocabulary,
    LECourseLessonsViewControllerMenuBookmark
};

@class LECourseLessonsViewControllerMenuView;

@protocol LECourseLessonsViewControllerMenuViewDelegate <NSObject>
@optional
- (void)menuView:(LECourseLessonsViewControllerMenuView*)menuView didSelectMenu:(LECourseLessonsViewControllerMenu)menu;
@end

@interface LECourseLessonsViewControllerMenuView : UITableView

@property (assign, nonatomic) id<LECourseLessonsViewControllerMenuViewDelegate> menuDelegate;

@end
