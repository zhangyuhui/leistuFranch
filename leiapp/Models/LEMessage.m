//
//  LEMessage.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEMessage.h"
#import "LEConstants.h"

@implementation LEMessage

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"msgFileType": @"type",
                                                       @"msgtype": @"mode",
                                                       @"sendtime": @"timestamp"
                                                       }];
}

@end
