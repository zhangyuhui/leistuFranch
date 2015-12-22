//
//  LECourseTestSection.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LECourseTestSection
@end

@interface LECourseTestSection : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray* items;

@end
