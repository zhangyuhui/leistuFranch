//
//  LECourseGlossary.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"

@protocol LECourseGlossary
@end

@interface LECourseGlossary : JSONModel
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* content;
@end
