//
//  LEOrganization.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"

@interface LEOrganization : JSONModel

@property (assign, nonatomic) int orgId;
@property (strong, nonatomic) NSString* orgName;

@end
