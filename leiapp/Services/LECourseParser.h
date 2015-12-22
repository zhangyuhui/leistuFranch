//
//  LECourseParser.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LECourse.h"

@interface LECourseParser : NSObject

- (void)parseCourseDetail:(LECourse*)course rootPath: (NSString*)rootPath detail:(LECourseDetail**)detail error:(NSString**)error;

@end
