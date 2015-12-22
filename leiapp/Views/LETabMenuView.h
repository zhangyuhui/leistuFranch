//
//  LETabMenuView.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/31/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECustomView.h"

@class LETabMenuView;

@protocol LETabMenuViewDelegate <NSObject>
@optional
- (void)tabMenuView:(LETabMenuView*)tabMenuView willSelectTab:(NSInteger)index from:(NSInteger)from;
- (void)tabMenuView:(LETabMenuView*)tabMenuView didSelectTab:(NSInteger)index from:(NSInteger)from;
@end

@interface LETabMenuView : LECustomView

@property (strong, nonatomic) IBOutlet UIButton *leftMenuButton;
@property (strong, nonatomic) IBOutlet UIButton *middleMenuButton;
@property (strong, nonatomic) IBOutlet UIButton *rightMenuButton;
@property (strong, nonatomic) IBOutlet UIView *underscoreView;

-(IBAction)clickMenuButton:(id)sender;

@property (assign, nonatomic) id<LETabMenuViewDelegate> delegate;

@property (strong, nonatomic) NSString* leftMenuLabel;
@property (strong, nonatomic) NSString* middleMenuLabel;
@property (strong, nonatomic) NSString* rightMenuLabel;
@end
