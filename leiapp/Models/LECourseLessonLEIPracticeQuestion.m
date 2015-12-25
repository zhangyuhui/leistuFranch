//
//  LELessonLEIPracticeQuestion.m
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonLEIPracticeQuestion.h"
#import "NSString+Addition.h"

@interface LECourseLessonLEIPracticeQuestion()
- (BOOL)hasExistance:(NSArray*)values;
@end

@implementation LECourseLessonLEIPracticeQuestion

- (BOOL)hasExistance:(NSArray*)values {
    return values != nil && [values count] > 0 && (![NSString stringIsNilOrEmpty:[values firstObject]]);
}

- (BOOL)hasImages {
    return [self hasExistance:self.images];
}

- (BOOL)hasAudios {
    return [self hasExistance:self.audios];
}

- (BOOL)hasOptions {
    return [self hasExistance:self.options];
}

- (BOOL)hasInputs {
    return ![self hasOptions] && ![self hasAudios] && ![self hasImages] && [self hasExistance:self.answers];
}

@end
