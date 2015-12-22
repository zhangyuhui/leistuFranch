//
//  LEClass.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/19/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"

@interface LEClass : JSONModel

@property (assign, nonatomic) int classId;
@property (strong, nonatomic) NSString* code;
@property (strong, nonatomic) NSString* creator;
@property (strong, nonatomic) NSString* groupId;
@property (strong, nonatomic) NSString<Ignore>* joinDate;
@property (assign, nonatomic) int life;
@property (assign, nonatomic) int status;
@property (assign, nonatomic) int year;
@property (strong, nonatomic) NSString* name;

@end
