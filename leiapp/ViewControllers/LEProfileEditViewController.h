//
//  LEProfileEditViewController.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/26/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseModalViewController.h"
#import "LEEnums.h"

@class LEProfileEditViewController;
@protocol LEProfileEditViewControllerDelegate <NSObject>
- (void)confirmProfileDisplayNameEdit:(NSString*)displayName;
- (void)confirmProfileGenderEdit:(LEUserSexType)sexType;
- (void)confirmProfileDictionary:(NSDictionary*)account;

@end

@interface LEProfileEditViewController : LEBaseModalViewController

-(instancetype)initWithDisplayName:(NSString*)displayName;
-(instancetype)initWithGender:(LEUserSexType)sexType;
-(instancetype)initWithDictionary:(NSDictionary *)account;


@property (assign, nonatomic) id<LEProfileEditViewControllerDelegate> delegate;
@property (nonatomic , strong) NSDictionary *account;

@end
