//
//  LELessonLEIAudioResponseItem.m
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonLEIAudioResponseItem.h"

@implementation LECourseLessonLEIAudioResponseItem
- (id)init{
    self = [super initWithType:LECourseLessonSectionItemTypeLEIAudioResponse];
    if (self){
        
    }
    return self;
}

+(BOOL)propertyIsOptional:(NSString*)propertyName {
    if ([propertyName isEqualToString: @"score"]) return YES;
    return NO;
}
@end
