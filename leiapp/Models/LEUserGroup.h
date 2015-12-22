//
//  LEUserGroup.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"

typedef enum {
    LEUserGroupTypeAdmin = 1,
    LEUserGroupTypeTeacher = 2,
    LEUserGroupTypeStudent = 3
} LEUserGroupType;

@interface LEUserGroup : JSONModel

@property (assign, nonatomic) int groupId;
@property (strong, nonatomic) NSString* groupName;
@property (assign, nonatomic) LEUserGroupType groupType;
@property (strong, nonatomic) NSArray<Ignore>* groupUsers;
@end
