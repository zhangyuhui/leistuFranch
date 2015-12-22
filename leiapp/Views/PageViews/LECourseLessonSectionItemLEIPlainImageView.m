//
//  LECourseLessonSectionItemLEIPlainImageView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/26/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIPlainImageView.h"
#import "LEConstants.h"
#import "UIImage+Addition.h"

@interface LECourseLessonSectionItemLEIPlainImageView ()
@property (nonatomic, assign) CGFloat itemHeight;
- (void)setupSubViews;
@end


@implementation LECourseLessonSectionItemLEIPlainImageView

- (instancetype)initWithLEIPlainImageItem:(LECourseLessonLEIPlainImageItem*)item {
    self = [super initWithItem:item];
    if (self){
       
    }
    return self;
}

- (void)setupSubViews{
    self.backgroundColor = [UIColor clearColor];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    CGFloat itemPadding = [self paddingForItem];
    CGFloat itemWidth = [self widthForItem] - itemPadding*2.0;
    CGFloat itemX = itemPadding;
    CGFloat itemY = 0;
    
    LECourseLessonLEIPlainImageItem* plainImageItem = (LECourseLessonLEIPlainImageItem*)self.item;
    
    UIImage* image = [UIImage imageWithContentsOfFile:[LECourseLessonSectionItemView pathForAsset:plainImageItem.image]];
    
    CGFloat itemHeight = !image ? 0 : image.size.height/image.size.width*itemWidth;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(itemX, itemY, itemWidth, itemHeight)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    image = [image imageWithOutline:[UIColor grayColor] lineWidth:0.5*(image.size.width/itemWidth)];
    
    imageView.image = image;
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:0.0
                                                                         constant:itemHeight];
    
    [imageView addConstraint:heightConstraint];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:0.0
                                                                        constant:itemWidth];
    
    [imageView addConstraint:widthConstraint];
    
    [self addSubview:imageView];
    
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1.0
                                                                          constant:itemPadding];
    [self addConstraint:leadingConstraint];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0];
    [self addConstraint:topConstraint];
    
    itemY += itemHeight;
    
    self.itemHeight = itemY;
}

- (CGFloat)heightForItem {
    return self.itemHeight;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake([self widthForItem], [self heightForItem]);
}
@end
