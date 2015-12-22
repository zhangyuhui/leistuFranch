//
//  LEPushToken.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"

@interface LEPushToken : JSONModel

@property (assign, nonatomic) int userId;
@property (assign, nonatomic) int status;
@property (strong, nonatomic) NSString* deviceToken;

@end
