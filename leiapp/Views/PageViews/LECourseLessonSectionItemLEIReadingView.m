//
//  LECourseLessonSectionItemLEIReadingView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/5/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIReadingView.h"
#import "RTLabel.h"

@interface LECourseLessonSectionItemLEIReadingView ()

@property (strong, nonatomic) IBOutlet RTLabel *textLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textLabelHeightConstraint;
@end

@implementation LECourseLessonSectionItemLEIReadingView

- (instancetype)initWithLEIReadingItem:(LECourseLessonLEIReadingItem*)item{
    self = [super initWithItem:item];
    if (self){
        
    }
    return self;
}

- (void)didSetupSubViews {
    LECourseLessonLEIReadingItem* item = (LECourseLessonLEIReadingItem*)self.item;
    
    self.textLabel.textColor = [UIColor darkGrayColor];
    self.textLabel.font = [self fontForItem];
    self.textLabel.text = item.text;
    
    CGFloat padding = [self paddingForItem];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat labelWidth = screenWidth - padding*2.0;
    
    CGRect labelFrame = self.textLabel.frame;
    labelFrame.size.width = labelWidth;
    self.textLabel.frame = labelFrame;
    
    CGSize labelSize = self.textLabel.optimumSize;
    CGFloat labelHeight = labelSize.height;
    
    self.textLabelHeightConstraint.constant = labelHeight;
}

- (CGFloat)heightForItem {
    return self.textLabelHeightConstraint.constant;
}


@end
