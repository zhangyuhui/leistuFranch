//
//  LEUser.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "LEEnums.h"

@class LEOrganization;

@interface LEUser : JSONModel

@property (assign, nonatomic) int userId;
@property (strong, nonatomic) NSString* userName;

@property (strong, nonatomic) NSString<Optional>* email;
@property (strong, nonatomic) NSString<Optional>* phone;

@property (strong, nonatomic) NSString<Optional>* studentId;
@property (assign, nonatomic) int groupId;

@property (assign, nonatomic) LEUserSexType sex;

@end
