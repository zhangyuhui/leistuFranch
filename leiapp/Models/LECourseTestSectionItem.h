//
//  LECourseTestSectionItem.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, LECourseTestSectionItemType) {
    LECourseTestSectionItemTypeOption = 0
};

@interface LECourseTestSectionItem : NSObject

@property (nonatomic, readonly) LECourseTestSectionItemType type;

- (instancetype)initWithType:(LECourseTestSectionItemType)type;

@end
