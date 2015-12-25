//
//  LECourseLessonSectionItemLEIPracticeView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/5/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIPracticesView.h"
#import "LECourseLessonLEIPracticeQuestion.h"
#import "LECourseLessonSectionItemLEIPracticeView.h"
#import "LEDefines.h"
#import "LEConstants.h"

@interface LECourseLessonSectionItemLEIPracticesView ()
@property (strong, nonatomic) NSMutableArray *  itemViews;
@property (assign, nonatomic) CGFloat  itemHeight;
@end

@implementation LECourseLessonSectionItemLEIPracticesView

- (instancetype)initWithLEIPracticeItem:(LECourseLessonLEIPracticeItem*)item {
    self = [super initWithItem:item];
    if (self){
        
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    CGFloat itemPadding = [self paddingForItem];
    CGFloat itemWidth = [self widthForItem];
    CGFloat itemX = itemPadding;
    CGFloat itemY = 0;
    
    self.itemViews = [NSMutableArray new];
    
    LECourseLessonLEIPracticeItem* item = (LECourseLessonLEIPracticeItem*)self.item;
    UIView* prevView;
    for (LECourseLessonLEIPracticeQuestion* question in item.questions) {
        if (prevView) {
            itemY += itemPadding;
        }
        LECourseLessonSectionItemLEIPracticeView* view = [[LECourseLessonSectionItemLEIPracticeView alloc] initWithFrame:CGRectMake(itemX, itemY, itemWidth, 90)];
        
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        view.question = question;
        
        CGFloat itemHeight = [view heightForView];
        
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
                                                                              constant:itemPadding];
        [self addConstraint:leadingConstraint];
        
        if (prevView) {
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:prevView
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0
                                                                              constant:itemPadding];
            
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
        
        [view addObserver:self forKeyPath:@"playing" options:NSKeyValueObservingOptionNew context:nil];
        [view addObserver:self forKeyPath:@"editing" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.itemViews addObject:view];
    }
    
    CGRect  screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat buttonPadding = itemPadding*2.0;
    CGFloat buttonHeight = 40;
    CGFloat buttonWidth = 200;
    CGFloat buttonX = screenWidth/2 - buttonWidth/2;
    CGFloat buttonY = itemY + buttonPadding;
    UIButton* submitButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    submitButton.titleLabel.font = [UIFont systemFontOfSize:18];
    submitButton.backgroundColor = UIColorFromRGB(0x38c6f7);
    submitButton.layer.cornerRadius = 20;
    
    [submitButton addTarget:self action:@selector(clickSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLayoutConstraint *buttonHeightConstraint = [NSLayoutConstraint constraintWithItem:submitButton
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:0.0
                                                                         constant:buttonHeight];
    
    [submitButton addConstraint:buttonHeightConstraint];
    
    NSLayoutConstraint *buttonWidthConstraint = [NSLayoutConstraint constraintWithItem:submitButton
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:0.0
                                                                        constant:buttonWidth];
    
    [submitButton addConstraint:buttonWidthConstraint];
    
    [self addSubview:submitButton];
    
    NSLayoutConstraint *buttonTopConstraint = [NSLayoutConstraint constraintWithItem:submitButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:prevView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:buttonPadding];
    
    [self addConstraint:buttonTopConstraint];
    
    NSLayoutConstraint *buttonCenterXConstraint = [NSLayoutConstraint constraintWithItem:submitButton
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1.0
                                                                            constant:0];
    
    [self addConstraint:buttonCenterXConstraint];
    
    self.itemHeight = buttonY + buttonHeight;
}

- (void)destroySubViews {
    [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        LECourseLessonSectionItemLEIPracticeView* view = (LECourseLessonSectionItemLEIPracticeView*)obj;
        [view removeObserver:self forKeyPath:@"playing"];
        [view removeObserver:self forKeyPath:@"editing"];
    }];
    [self.itemViews removeAllObjects];
    [super destroySubViews];
}

- (CGFloat)heightForItem {
    return self.itemHeight;
}

- (void)clickSubmitButton:(id)sender {
    if (self.selected) {
        self.selected = NO;
    }
    LECourseLessonLEIPracticeItem* item = (LECourseLessonLEIPracticeItem*)self.item;
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:item, @"practice", nil];
    [notification postNotificationName:kLENotificationCourseStudyShowPracticeAnswer object:nil userInfo:userInfo];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (!selected) {
        [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            LECourseLessonSectionItemLEIPracticeView* view = (LECourseLessonSectionItemLEIPracticeView*)obj;
            if (view.playing) {
                view.playing = NO;
            }
            if (view.editing) {
                view.editing = NO;
            }
        }];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (LECourseLessonSectionItemLEIPracticeView* view in self.itemViews) {
        CGPoint converted = [self convertPoint:point toView:view];
        if (![view pointInside:converted withEvent:event]) {
            if (view.editable && view.editing){
                view.editing = NO;
            }
        }
    }
    return [super hitTest:point withEvent:event];
}

# pragma mark Observers
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"playing"]) {
        LECourseLessonSectionItemLEIPracticeView* view = (LECourseLessonSectionItemLEIPracticeView*)object;
        if (view.playing) {
            [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
                LECourseLessonSectionItemLEIPracticeView* other = (LECourseLessonSectionItemLEIPracticeView*)obj;
                if (other.playing && view != other) {
                    other.playing = NO;
                }
            }];
            if (!self.selected) {
                self.selected = YES;
            }
        } else {
            __block BOOL isPlaying = NO;
            [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
                LECourseLessonSectionItemLEIPracticeView* view = (LECourseLessonSectionItemLEIPracticeView*)obj;
                if (view.playing) {
                    isPlaying = YES;
                    *stop = YES;
                }
            }];
            if (!isPlaying && self.selected) {
                self.selected = NO;
            }
        }
    } else if([keyPath isEqualToString:@"editing"]) {
        LECourseLessonSectionItemLEIPracticeView* view = (LECourseLessonSectionItemLEIPracticeView*)object;
        if (view.editing) {
            [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
                LECourseLessonSectionItemLEIPracticeView* other = (LECourseLessonSectionItemLEIPracticeView*)obj;
                if (other.editing && view != other) {
                    other.editing = NO;
                }
            }];
            if (!self.selected) {
                self.selected = YES;
            }
        } else {
            __block BOOL editing = NO;
            [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
                LECourseLessonSectionItemLEIPracticeView* view = (LECourseLessonSectionItemLEIPracticeView*)obj;
                if (view.editing) {
                    editing = YES;
                    *stop = YES;
                }
            }];
            if (!editing && self.selected) {
                self.selected = NO;
            }
        }
    }
}

@end
