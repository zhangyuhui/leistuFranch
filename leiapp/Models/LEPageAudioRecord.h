//
//  LEPageAudioRecord.h
//  leiappv2
//
//  Created by Yuhui Zhang on 12/1/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseSyncRecord.h"

@protocol LEPageAudioRecord
@end

@interface LEPageAudioRecord : LEBaseSyncRecord

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
