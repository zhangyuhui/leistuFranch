//
//  LEUser.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEUser.h"

@interface LEUser ()


@end

@implementation LEUser

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"userID": @"userId",
                                                       @"studentID": @"studentId",
                                                       @"telphone": @"phone",
                                                       @"groupID": @"groupId"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    if ([propertyName isEqualToString: @"sex"]) return YES;
    if ([propertyName isEqualToString: @"groupId"]) return YES;
    return NO;
}

@end
