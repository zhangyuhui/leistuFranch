//
//  LEOrganization.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEOrganization.h"

@implementation LEOrganization

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"orgID": @"orgId"
                                                       }];
}


@end
