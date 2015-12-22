//
//  LEAccount.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "LEEnums.h"

@class LEOrganization;

@interface LEAccount : JSONModel <NSCopying>


@property (strong, nonatomic) NSString* token;

@property (assign, nonatomic) int userId;
@property (strong, nonatomic) NSString* userName;
//@property (strong, nonatomic) NSString<Optional>* userDisplayName;

@property (strong, nonatomic) NSString<Optional>* email;
@property (strong, nonatomic) NSString<Optional>* phone;

@property (strong, nonatomic) NSString<Optional>* studentId;
@property (strong, nonatomic) NSString<Optional>* school;
@property (strong, nonatomic) NSString<Optional>* classCode;
@property (assign, nonatomic) int classId;
@property (strong, nonatomic) NSString<Optional>* className;
@property (assign, nonatomic) int classStatus;

@property (assign, nonatomic) LEUserSexType sex;

@end
