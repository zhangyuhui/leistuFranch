//
//  LECourseLessonSectionItemLEIAudioResponseView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/28/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemView.h"
#import "LECourseLessonLEIAudioResponseItem.h"
#import "LEPageRecord.h"
@interface LECourseLessonSectionItemLEIAudioResponseView : LECourseLessonSectionItemView
@property (nonatomic , strong)LEPageRecord *record;
- (instancetype)initWithLEIAudioResponseItem:(LECourseLessonLEIAudioResponseItem*)item record:(LEPageRecord*) record;
@end
