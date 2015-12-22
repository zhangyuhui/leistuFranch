//
//  LEPageRecord.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"
#import "LEPageAudioPractice.h"
#import "LEPageAudioRecord.h"
@protocol LEPageRecord
@end

@interface LEPageRecord : JSONModel

@property (assign, nonatomic) int pageId;
@property (assign, nonatomic) int score;
@property (assign, nonatomic) int duration;
@property (assign, nonatomic) BOOL isCompleted;
//@property (strong, nonatomic) NSString<Optional>* record;
//@property (strong, nonatomic) NSArray<Ignore>* practices;
@property (strong, nonatomic) NSArray<LEPageAudioRecord, Optional>* record;
@property (strong, nonatomic) NSArray<LEPageAudioPractice, Ignore>* practices;

@end
