//
//  LECourseLessonSectionItemLEIRoleTipSelectionView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/10/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECustomView.h"

typedef NS_ENUM(NSInteger, LERoleTipType) {
    LERoleTipTypeFull = 0,
    LERoleTipTypePartial,
    LERoleTipTypeNone
};

@interface LECourseLessonSectionItemLEIRoleTipSelectionView : LECustomView
@property (assign, nonatomic) LERoleTipType type;
@end
