//
//  LELessonLEIVideoItem.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItem.h"

@protocol LECourseLessonLEIVideoItem
@end

@interface LECourseLessonLEIVideoItem : LECourseLessonSectionItem
@property (nonatomic, strong) NSString<Optional>* direction;
@property (nonatomic, strong) NSString* video;
@property (nonatomic, strong) NSString* cover;
@property (nonatomic, strong) NSString<Optional>* transcript;
@end
