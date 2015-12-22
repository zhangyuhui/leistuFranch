//
//  LECourseLessonSectionItemLEIAudioTextItemView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/4/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEAudioCustomView.h"
#import "LECourseLessonLEIAudioText.h"

@interface LECourseLessonSectionItemLEIAudioTextItemView : LEAudioCustomView
@property (strong, nonatomic) LECourseLessonLEIAudioText* audioText;
@property (assign, nonatomic) BOOL selected;

- (CGFloat)heightForView;
@end
