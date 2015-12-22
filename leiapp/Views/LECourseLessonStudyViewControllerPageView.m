//
//  LECourseLessonStudyViewControllerPageView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/25/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonStudyViewControllerPageView.h"
#import "LECourseLessonSectionItem.h"
#import "LECourseLessonSectionItemLEIPlainTextView.h"
#import "LECourseLessonSectionItemLEIPlainImageView.h"
#import "LECourseLessonSectionItemLEIAudioResponseView.h"
#import "LECourseLessonSectionItemLEIAudioView.h"
#import "LECourseLessonSectionItemLEIAudioTextView.h"
#import "LECourseLessonSectionItemLEIVideoView.h"
#import "LECourseLessonSectionItemLEIReadingView.h"
#import "LECourseLessonSectionItemLEIPracticesView.h"
#import "LECourseLessonSectionItemLEIRolePlayView.h"



@interface LECourseLessonStudyViewControllerPageView() <LECourseLessonSectionItemViewDelegate>
@property (nonatomic, strong) IBOutlet UIView* contentView;
@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;

@property (nonatomic, strong) NSMutableArray *sectionItemViews;
@property (nonatomic, strong) NSMutableArray *contentViewConstraints;
@property (nonatomic, strong) NSMutableArray *sectionItemViewHeightConstraints;

@property (nonatomic, strong) LECourseLessonSectionItemView *selectedSectionItemView;

@property (nonatomic, strong) LECourseLessonLEIAudioResponseItem* audioResponseItem;
@property (nonatomic, strong) LEPageRecord* pageRecord;
- (void)setupSectionItemViews;
- (void)destroySectionItemViews;
- (void)destroySectionItemView:(LECourseLessonSectionItemView*)view;
- (void)setupSectionItemView:(LECourseLessonSectionItemView*)view;
- (LECourseLessonSectionItemView*)createSectionItemView:(LECourseLessonSectionItem*)item;

@end

@implementation LECourseLessonStudyViewControllerPageView

- (void)viewDidLoad {
    self.sectionItemViews = [NSMutableArray new];
    self.contentViewConstraints = [NSMutableArray new];
    self.sectionItemViewHeightConstraints = [NSMutableArray new];
}

- (void)setSection:(LECourseLessonSection *)section pagerecord:(LEPageRecord*)record {
    _section = section;
    _pageRecord = record;
    
    [self destroySectionItemViews];
    [self setupSectionItemViews];
}

- (void)setupSectionItemViews {
    for (LECourseLessonSectionItem* item in self.section.items){
        LECourseLessonSectionItemView* itemView = [self createSectionItemView:item];
        if (itemView) {
            itemView.delegate = self;
            [itemView addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
            [self setupSectionItemView:itemView];
        }
    }
    
    CGFloat contentHeight = 0;
    CGFloat contentWidth = 0;
    for (LECourseLessonSectionItemView* itemView in self.sectionItemViews) {
        if (itemView == [self.sectionItemViews firstObject]) {
            contentHeight += [itemView paddingForItem];
            contentWidth = [itemView widthForItem];
        }
        contentHeight += [itemView heightForItem];
        contentHeight += [itemView spacingForItem];

        if (itemView == [self.sectionItemViews lastObject]) {
            contentHeight += [itemView paddingForItem];
        }
    }
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:0.0
                                                                       constant:contentWidth];
    [self.contentView addConstraint:widthConstraint];
    [self.contentViewConstraints addObject:widthConstraint];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeHeight
                                                                      multiplier:1.0
                                                                        constant:contentHeight];
    [self.contentView addConstraint:heightConstraint];
    [self.contentViewConstraints addObject:heightConstraint];
    
    [self.scrollView setContentSize:CGSizeMake(contentWidth, contentHeight)];
    [self.scrollView setContentOffset:CGPointMake(0, -self.scrollView.contentInset.top) animated:NO];
}

- (void)destroySectionItemViews {
    if (self.selectedSectionItemView) {
        self.selectedSectionItemView.delegate = nil;
        if (self.selectedSectionItemView.selected) {
            self.selectedSectionItemView.selected = NO;
        }
        self.selectedSectionItemView = nil;
    }
    
    if (self.audioResponseItem) {
//        [self.audioResponseItem removeObserver:self forKeyPath:@"score"];
        self.audioResponseItem = nil;
    }
    
    for (LECourseLessonSectionItemView* view in self.sectionItemViews){
        [self destroySectionItemView:view];
    }
    [self.sectionItemViews removeAllObjects];
    
    [self.contentView removeConstraints:self.contentViewConstraints];
    [self.contentViewConstraints removeAllObjects];
    [self.sectionItemViewHeightConstraints removeAllObjects];
}

- (void)destroySectionItemView:(LECourseLessonSectionItemView*)view {
    [view removeObserver:self forKeyPath:@"selected" context:nil];
    [view removeFromSuperview];
}

- (void)willRemoveSubview:(UIView *)subview {
    [self destroySectionItemViews];
    [super willRemoveSubview:subview];
}

- (void)setupSectionItemView:(LECourseLessonSectionItemView*)view {
    [self.contentView addSubview:view];
    
    CGFloat padding = [view paddingForItem];
    CGFloat spacing = [view spacingForItem];
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.contentView addConstraint:leadingConstraint];
    
    if ([self.sectionItemViews count] > 0) {
        UIView* lastView = [self.sectionItemViews lastObject];
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:lastView
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0
                                                                               constant:spacing];
        [self.contentView addConstraint:topConstraint];
    } else {
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0
                                                                          constant:padding];
        [self.contentView addConstraint:topConstraint];
    }

    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeHeight
                                                                           multiplier:0.0
                                                                             constant:[view heightForItem]];
        
    [view addConstraint:heightConstraint];
    
    [self.sectionItemViewHeightConstraints addObject:heightConstraint];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:0.0
                                                                         constant:[view widthForItem]];
    
    [view addConstraint:widthConstraint];
    
    [self.sectionItemViews addObject:view];
}


- (LECourseLessonSectionItemView*)createSectionItemView:(LECourseLessonSectionItem*)item {
    LECourseLessonSectionItemView* view;
    switch (item.type) {
        /*case LECourseLessonSectionItemTypeNoteText: {
            view = [[LECourseLessonSectionItemNoteTextView alloc] initWithNoteTextItem:(LECourseLessonNoteTextItem*)item];
            }
            break;
        case LECourseLessonSectionItemTypePlainText: {
            view = [[LECourseLessonSectionItemPlainTextView alloc] initWithPlainTextItem:(LECourseLessonPlainTextItem*)item];
            }
            break;
        case LECourseLessonSectionItemTypeThinkText: {
            }
            break;
        case LECourseLessonSectionItemTypeExampleText:{
            }
            break;
        case LECourseLessonSectionItemTypeDidYouKnowText:{
            }
            break;
        case LECourseLessonSectionItemTypeRememberText:{
            }
            break;
        case LECourseLessonSectionItemTypeImportantText:{
            }
            break;
        case LECourseLessonSectionItemTypeImage:{
            }
            break;
        case LECourseLessonSectionItemTypeVideo:{
            }
            break;
        case LECourseLessonSectionItemTypePPT: {
            }
            break;
        case LECourseLessonSectionItemTypeOptionTest:{
            }
            break;
        case LECourseLessonSectionItemTypeStatementTest:{
            }
            break;*/
        case LECourseLessonSectionItemTypeLEIPlainText: {
            view = [[LECourseLessonSectionItemLEIPlainTextView alloc] initWithLEIPlainTextItem:(LECourseLessonLEIPlainTextItem*)item];
            }
            break;
        case LECourseLessonSectionItemTypeLEIPlainImage: {
            view = [[LECourseLessonSectionItemLEIPlainImageView alloc] initWithLEIPlainImageItem:(LECourseLessonLEIPlainImageItem *)item];
            }
            break;
        case LECourseLessonSectionItemTypeLEIAudioResponse: {
            view = [[LECourseLessonSectionItemLEIAudioResponseView alloc] initWithLEIAudioResponseItem:(LECourseLessonLEIAudioResponseItem *)item record:_pageRecord];
            self.audioResponseItem = (LECourseLessonLEIAudioResponseItem *)item;
//            [self.audioResponseItem addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:nil];
            }
            break;
        case  LECourseLessonSectionItemTypeLEIAudio: {
            view = [[LECourseLessonSectionItemLEIAudioView alloc] initWithLEIAudioItem:(LECourseLessonLEIAudioItem *)item];
            }
            break;
        case LECourseLessonSectionItemTypeLEIVideo:{
            view = [[LECourseLessonSectionItemLEIVideoView alloc] initWithLEIVideoItem:(LECourseLessonLEIVideoItem *)item];
            }
            break;
        case LECourseLessonSectionItemTypeLEIPractice:{
            view = [[LECourseLessonSectionItemLEIPracticesView alloc] initWithLEIPracticeItem:(LECourseLessonLEIPracticeItem *)item];
            }
            break;
        case LECourseLessonSectionItemTypeLEIRolePlay:{
            view = [[LECourseLessonSectionItemLEIRolePlayView alloc] initWithLEIRolePlayItem:(LECourseLessonLEIRolePlayItem *)item];
            }
            break;
        case LECourseLessonSectionItemTypeLEIAudioText: {
            view = [[LECourseLessonSectionItemLEIAudioTextView alloc] initWithLEIAudioTextItem:(LECourseLessonLEIAudioTextItem *)item];
            }
            break;
        case LECourseLessonSectionItemTypeLEIReading:{
            view = [[LECourseLessonSectionItemLEIReadingView alloc] initWithLEIReadingItem:(LECourseLessonLEIReadingItem *)item];
            }
            break;
        
        default:
            break;
    }
    return view;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.selectedSectionItemView) {
        CGPoint pointConverted = [self convertPoint:point toView:self.selectedSectionItemView];
        if ([self.selectedSectionItemView pointInside:pointConverted withEvent:event]) {
            return [self.selectedSectionItemView hitTest:pointConverted withEvent:event];
        }
        else {
            BOOL ispracticeview = NO;
            for (LECourseLessonSectionItemView * view in self.sectionItemViews) {
                if([view isMemberOfClass:[LECourseLessonSectionItemLEIPracticesView class]]){
                    ispracticeview = YES;
                    break;
                }
                    
            }
            if([self.selectedSectionItemView isMemberOfClass:[LECourseLessonSectionItemLEIVideoView class]]&&!ispracticeview){
                self.selectedSectionItemView.selected = NO;
                self.selectedSectionItemView = nil;
            }
        }
    }
    
    return [super hitTest:point withEvent:event];
}

# pragma mark LECourseLessonSectionItemViewDelegate
- (void)sectionItemView:(LECourseLessonSectionItemView*)sectionItemView willChangeHeight:(CGFloat)height {
    NSUInteger index = [self.sectionItemViews indexOfObject:sectionItemView];
    NSLayoutConstraint* heightConstraint =  [self.sectionItemViewHeightConstraints objectAtIndex:index];
    [UIView animateWithDuration:0.3 animations:^{
        heightConstraint.constant = height;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGFloat contentHeight = 0;
        CGFloat contentWidth = 0;
        for (LECourseLessonSectionItemView* itemView in self.sectionItemViews) {
            if (itemView == [self.sectionItemViews firstObject]) {
                contentHeight += [itemView paddingForItem];
                contentWidth = [itemView widthForItem];
            }
            contentHeight += [itemView heightForItem];
            contentHeight += [itemView spacingForItem];
            
            if (itemView == [self.sectionItemViews lastObject]) {
                contentHeight += [itemView paddingForItem];
            }
        }
        
        [self.scrollView setContentSize:CGSizeMake(contentWidth, contentHeight)];
    }];
}

- (void)sectionItemView:(LECourseLessonSectionItemView*)sectionItemView didChangeHeight:(CGFloat)height {
    
}


# pragma mark Observers
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"selected"]) {
        LECourseLessonSectionItemView* itemView = object;
        if (itemView.selected) {
            if (self.selectedSectionItemView != itemView) {
                if (self.selectedSectionItemView) {
                    self.selectedSectionItemView.selected = NO;
                }
                self.selectedSectionItemView = itemView;
            }
        } else {
            if (self.selectedSectionItemView == itemView) {
                self.selectedSectionItemView = nil;
            }
        }
    } else if([keyPath isEqualToString:@"score"]) {
        self.section.score = self.audioResponseItem.score;
    }
}


@end
