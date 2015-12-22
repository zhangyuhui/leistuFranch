//
//  LEAccount.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEAccount.h"

@interface LEAccount ()


@end

@implementation LEAccount

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"userID": @"userId",
                                                       @"studentID": @"studentId",
                                                       @"telphone": @"phone",
                                                       //@"access_token": @"token",
                                                       @"teaName": @"userDisplayName",
                                                       @"classID": @"classId"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    if ([propertyName isEqualToString: @"classStatus"]) return YES;
    if ([propertyName isEqualToString: @"classId"]) return YES;
    return NO;
}

-(id)copyWithZone:(NSZone *)zone {
    LEAccount *another = [super copyWithZone:zone];
    
    return another;
}

@end
