//
//  LEUserGroup.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEUserGroup.h"

@implementation LEUserGroup

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"contactGroupID": @"groupId",
                                                       @"name": @"groupName"
                                                       }];
}

@end
