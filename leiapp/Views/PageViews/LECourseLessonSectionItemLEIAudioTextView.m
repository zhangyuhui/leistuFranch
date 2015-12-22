//
//  LECourseLessonSectionItemLEIAudioTextView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/4/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIAudioTextView.h"
#import "LECourseLessonSectionItemLEIAudioTextItemView.h"
#import "LECourseLessonLEIAudioText.h"

@interface LECourseLessonSectionItemLEIAudioTextView()
@property (assign, nonatomic) CGFloat itemHeight;
@property (strong, nonatomic) NSMutableArray* itemViews;
@end

@implementation LECourseLessonSectionItemLEIAudioTextView

- (instancetype)initWithLEIAudioTextItem:(LECourseLessonLEIAudioTextItem*)item {
    self = [super initWithItem:item];
    if (self){
        
    }
    return self;
}

- (void)setupSubViews{
    self.backgroundColor = [UIColor clearColor];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    CGFloat itemWidth = [self widthForItem];
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    
    self.itemViews = [NSMutableArray new];
    
    LECourseLessonLEIAudioTextItem* item = (LECourseLessonLEIAudioTextItem*)self.item;
    UIView* prevView;
    for (LECourseLessonLEIAudioText* audioText in item.audioTexts) {
        LECourseLessonSectionItemLEIAudioTextItemView* view = [[LECourseLessonSectionItemLEIAudioTextItemView alloc] initWithFrame:CGRectMake(itemX, itemY, itemWidth, 90)];
        
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        view.audioText = audioText;
        
        CGFloat itemHeight = [view heightForView];
        if (audioText != [item.audioTexts lastObject]) {
            itemHeight += [self paddingForItem];
        }
        
        CGRect viewFrame = view.frame;
        viewFrame.size.height = itemHeight;
        view.frame = viewFrame;
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeHeight
                                                                           multiplier:0.0
                                                                             constant:itemHeight];
        
        [view addConstraint:heightConstraint];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeWidth
                                                                          multiplier:0.0
                                                                            constant:itemWidth];
        
        [view addConstraint:widthConstraint];
        
        
        [self addSubview:view];
        
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeLeading
                                                                            multiplier:1.0
                                                                              constant:0];
        [self addConstraint:leadingConstraint];
        
        if (prevView) {
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:prevView
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0
                                                                              constant:0];
            
            [self addConstraint:topConstraint];
        } else {
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.0
                                                                              constant:0];
            [self addConstraint:topConstraint];
        }
        
        itemY += itemHeight;
        prevView = view;
        
        [view addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.itemViews addObject:view];
    }
    
    self.itemHeight = itemY;
}

- (void)willDestroySubViews {
    for (LECourseLessonSectionItemLEIAudioTextItemView* view in self.itemViews) {
        [view removeObserver:self forKeyPath:@"selected"];
    }
    [self.itemViews removeAllObjects];
}

- (CGFloat)heightForItem {
    return self.itemHeight;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake([self widthForItem], [self heightForItem]);
}

- (void)setSelected:(BOOL)selected {
    if (!selected) {
        for (LECourseLessonSectionItemLEIAudioTextItemView* view in self.itemViews) {
            if (view.selected) {
                view.selected = NO;
            }
        }
    } else {
        BOOL hasSelected = NO;
        for (LECourseLessonSectionItemLEIAudioTextItemView* view in self.itemViews) {
            if (view.selected) {
                hasSelected = YES;
                break;
            }
        }
        if (!hasSelected) {
            LECourseLessonSectionItemLEIAudioTextItemView* view = [self.itemViews firstObject];
            view.selected = YES;
        }
    }
    [super setSelected:selected];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"selected"]) {
        LECourseLessonSectionItemLEIAudioTextItemView* itemView = object;
        BOOL selected = itemView.selected;
        if (selected) {
            for (LECourseLessonSectionItemLEIAudioTextItemView* view in self.itemViews) {
                if (view.selected && view != itemView) {
                    view.selected = NO;
                }
            }
            if (!self.selected) {
                self.selected = YES;
            }
        } else {
            BOOL hasSelected = NO;
            for (LECourseLessonSectionItemLEIAudioTextItemView* view in self.itemViews) {
                if (view.selected && view != itemView) {
                    hasSelected = YES;
                }
            }
            if (!hasSelected && self.selected) {
                self.selected = NO;
            }
        }
    }
}
@end

