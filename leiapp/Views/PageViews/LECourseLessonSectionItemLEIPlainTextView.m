//
//  LECourseLessonSectionItemLEIPlainTextView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/26/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIPlainTextView.h"
#import "LEDefines.h"
#import "RTLabel.h"
#import "NSString+Addition.h"

#define kListHeadLabelPadding 3
#define kListContentLabelPadding 14

@interface LECourseLessonSectionItemLEIPlainTextView ()
@property (nonatomic, assign) CGFloat itemHeight;
- (void)setupSubViews;
@end

@implementation LECourseLessonSectionItemLEIPlainTextView

- (instancetype)initWithLEIPlainTextItem:(LECourseLessonLEIPlainTextItem*)item {
    self = [super initWithItem:item];
    if (self){
    }
    return self;
}

- (void)setupSubViews{
    self.backgroundColor = [UIColor clearColor];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIFont* itemFont = [self fontForItem];
    CGFloat itemPadding = [self paddingForItem];
    CGFloat itemWidth = [self widthForItem] - itemPadding*2.0;
    CGFloat itemX = itemPadding;
    CGFloat itemY = 0;
    
    LECourseLessonLEIPlainTextItem* plainTextItem = (LECourseLessonLEIPlainTextItem*)self.item;
    if (![NSString stringIsNilOrEmpty:plainTextItem.text]){
        RTLabel* titleLabel = [[RTLabel alloc] initWithFrame:CGRectMake(itemX, itemY, itemWidth, CGFLOAT_MAX)];
        [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = itemFont;
        titleLabel.textColor = [UIColor darkGrayColor];
        //titleLabel.highlightTextColor = UIColorFromRGB(0x0355a9);
        titleLabel.text = [plainTextItem.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //Title style
        if (self.item.index == 0) {
            titleLabel.font = [UIFont italicSystemFontOfSize:itemFont.pointSize];
            titleLabel.textColor = [UIColor grayColor];
        }
        
        
        CGSize titleSize = [titleLabel optimumSize];
        CGFloat itemHeight = titleSize.height;
        
        CGRect titleFrame = titleLabel.frame;
        titleFrame.size.height = itemHeight;
        titleLabel.frame = titleFrame;
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:titleLabel
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeHeight
                                                                           multiplier:0.0
                                                                             constant:itemHeight];
        
        [titleLabel addConstraint:heightConstraint];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:titleLabel
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeWidth
                                                                           multiplier:0.0
                                                                             constant:itemWidth];
        
        [titleLabel addConstraint:widthConstraint];
        
        [self addSubview:titleLabel];
        
        
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:titleLabel
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeLeading
                                                                            multiplier:1.0
                                                                              constant:itemPadding];
        [self addConstraint:leadingConstraint];
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:titleLabel
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0
                                                                          constant:0];
        [self addConstraint:topConstraint];
        
        itemY += itemHeight;
        
        if (self.item.index == 0) {
            CGFloat dividerWidth = [self widthForItem];
            CGFloat dividerHeight = 1;
            CGFloat dividerX = 0;
            CGFloat dividerY = itemY + itemPadding;
            CGFloat itemSpacing = [self spacingForItem];
            
            UIView* dividerView = [[UIView alloc] initWithFrame:CGRectMake(dividerX, dividerY, dividerWidth, dividerHeight)];
            dividerView.backgroundColor = [self colorForItem:LECourseLessonSectionItemViewColorTypeDivider];
            
            NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:dividerView
                                                                                attribute:NSLayoutAttributeHeight
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:nil
                                                                                attribute:NSLayoutAttributeHeight
                                                                               multiplier:0.0
                                                                                 constant:dividerHeight];
            
            [dividerView addConstraint:heightConstraint];
            
            NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:dividerView
                                                                               attribute:NSLayoutAttributeWidth
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:nil
                                                                               attribute:NSLayoutAttributeWidth
                                                                              multiplier:0.0
                                                                                constant:dividerWidth];
            
            [dividerView addConstraint:widthConstraint];
            
            [self addSubview:dividerView];
            
            NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:dividerView
                                                                                 attribute:NSLayoutAttributeLeading
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self
                                                                                 attribute:NSLayoutAttributeLeading
                                                                                multiplier:1.0
                                                                                  constant:0];
            
            [self addConstraint:leadingConstraint];
            
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:dividerView
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:titleLabel
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0
                                                                              constant:itemPadding];
            
            [self addConstraint:topConstraint];
            
            itemY = dividerY + itemSpacing;
        }
    }
    self.itemHeight = itemY;
}

- (CGFloat)heightForItem {
    return self.itemHeight;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake([self widthForItem], [self heightForItem]);
}

@end
