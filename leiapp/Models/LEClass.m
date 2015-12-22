//
//  LEClass.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/19/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEClass.h"

@implementation LEClass

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"classID": @"classId",
                                                       @"groupID": @"groupId"
                                                       }];
}
@end
