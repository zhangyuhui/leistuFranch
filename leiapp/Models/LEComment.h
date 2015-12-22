//
//  LEComment.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/23/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"

@interface LEComment : JSONModel

@property (assign, nonatomic) int identity;
@property (assign, nonatomic) int count;
@property (assign, nonatomic) int parentId;
@property (strong, nonatomic) NSDate* date;
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* text;

@end
