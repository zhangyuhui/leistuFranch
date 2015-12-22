//
//  LECourseLessonGlossaryDetailStackedCardView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/19/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonGlossaryDetailStackedCardView.h"

@interface LECourseLessonGlossaryDetailStackedCardView()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation LECourseLessonGlossaryDetailStackedCardView

+ (instancetype)courseLessonGlossaryDetailStackedCardView {
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LECourseLessonGlossaryDetailStackedCardView"
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];
}

- (void) setGlossary:(LECourseGlossary *)glossary {
    _glossary = glossary;
    self.nameLabel.text = glossary.name;
    self.contentLabel.text = glossary.content;
}


@end
