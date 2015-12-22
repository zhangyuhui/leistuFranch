//
//  LEPushService.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseService.h"

@interface LEPushService : LEBaseService

+ (instancetype)sharedService;

@property (strong, nonatomic) NSString* token;

@end
