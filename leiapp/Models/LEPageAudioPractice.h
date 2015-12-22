//
//  LEPageNoteRecord.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"

@protocol LEPageAudioPractice
@end

@interface LEPageAudioPractice : JSONModel

@property (strong, nonatomic) NSString<Optional>* content;
@property (strong, nonatomic) NSString<Optional>* filePath;
@property (strong, nonatomic) NSString<Optional>* title;
@property (strong, nonatomic) NSString<Optional>* mediaUrl;
@property (assign, nonatomic) int index;
@property (assign, nonatomic) int score;
@property (assign, nonatomic) int minutimes;
@property (assign, nonatomic) int recordedCount;
@property (assign, nonatomic) int type;

@end
