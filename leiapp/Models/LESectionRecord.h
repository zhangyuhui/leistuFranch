//
//  LESectionRecord.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "LEPageRecord.h"

@protocol LESectionRecord
@end

@interface LESectionRecord : JSONModel

@property (assign, nonatomic) int sectionId;
@property (assign, nonatomic) int score;
@property (assign, nonatomic) int duration;
@property (strong, nonatomic) NSArray<LEPageRecord>* pages;

@end
