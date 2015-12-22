//
//  LELessonLEIRolePlayItem.m
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonLEIRolePlayItem.h"

@implementation LECourseLessonLEIRolePlayItem
- (id)init{
    self = [super initWithType:LECourseLessonSectionItemTypeLEIRolePlay];
    if (self){
        
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary*)dict error:(NSError**)err {
    id a = [super initWithDictionary:dict error:err];
    
    
    return a;
}
@end
