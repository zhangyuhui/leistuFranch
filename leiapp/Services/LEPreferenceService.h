//
//  LEPreferenceService.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/12/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEBaseService.h"
#import "LEEnums.h"

@interface LEPreferenceService : LEBaseService

+ (instancetype)sharedService;

- (CGFloat)fontSize;
- (CGFloat)paddingSize;
- (CGFloat)spacingSize;

@property (assign, nonatomic) BOOL downloadInNoneWifi;
@property (assign, nonatomic) BOOL syncInNoneWifi;
@property (assign, nonatomic) BOOL messageNotify;
@end
