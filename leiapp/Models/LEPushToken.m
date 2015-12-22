//
//  LEPushToken.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEPushToken.h"

@implementation LEPushToken

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"userid": @"userId",
                                                       @"devicetoken": @"deviceToken"
                                                       }];
}

@end
