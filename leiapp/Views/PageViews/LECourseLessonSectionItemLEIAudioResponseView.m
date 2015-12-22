//
//  LECourseLessonSectionItemLEIAudioResponseView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/28/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIAudioResponseView.h"
#import "LECourseLessonSectionItemLEIAudioResponseItemView.h"
#import "LECourseLessonLEIAudioResponse.h"
#import "LEDefines.h"


#define kHeightDuration  0.3

@interface LECourseLessonSectionItemLEIAudioResponseView()
@property (assign, nonatomic) CGFloat itemHeight;
@property (strong, nonatomic) NSMutableArray* itemHeightConstraints;
@property (strong, nonatomic) NSMutableArray* itemViews;

- (void) updateItemViewHeightConstrant:(LECourseLessonSectionItemLEIAudioResponseItemView*)itemView;
@end

@implementation LECourseLessonSectionItemLEIAudioResponseView

- (instancetype)initWithLEIAudioResponseItem:(LECourseLessonLEIAudioResponseItem*)item record:(LEPageRecord *)record{
    _record = record;
    self = [super initWithItem:item];
    if (self){
        
    }
    return self;
}
- (LEPageAudioRecord*) pageAudioRecord:(int) index{
    if ([_record record]) {
        for (LEPageAudioRecord* tAudioRecord in [_record record]) {
            if (tAudioRecord.index == index) {
                return tAudioRecord;
            }
        }
    }
    LEPageAudioRecord* tAudioRecord = [[LEPageAudioRecord alloc] init];
    tAudioRecord.index = index;
    NSMutableArray* array = _record.record ? [NSMutableArray arrayWithArray:_record.record] : [NSMutableArray<LEPageAudioRecord> array];
    [array addObject:tAudioRecord];
    _record.record = [NSArray<LEPageAudioRecord> arrayWithArray:array];
    return tAudioRecord;
}
- (void)setupSubViews{
    self.backgroundColor = [UIColor clearColor];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    CGFloat itemWidth = [self widthForItem];
    CGFloat itemHeight = 80;//[LECourseLessonSectionItemLEIAudioResponseItemView heightForReponse:NO];
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    
    self.itemHeightConstraints = [NSMutableArray new];
    self.itemViews = [NSMutableArray new];
    
    LECourseLessonLEIAudioResponseItem* item = (LECourseLessonLEIAudioResponseItem*)self.item;

    UIView* prevView;
    
    int i = 0;
    
    for (LECourseLessonLEIAudioResponse* response in item.responses) {
        LECourseLessonSectionItemLEIAudioResponseItemView* view = [[LECourseLessonSectionItemLEIAudioResponseItemView alloc] initWithFrame:CGRectMake(itemX, itemY, itemWidth, itemHeight)];
        
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        LEPageAudioRecord* audioRecord = [self pageAudioRecord:i];
        view.audioRecord = audioRecord;
        view.response = response;
        
        [view.audioRecord addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:nil];
        
        [view addObserver:self forKeyPath:@"expanded" options:NSKeyValueObservingOptionNew context:nil];
        
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
//        itemY += itemHeight;        
        itemY += view.viewHeight;
        prevView = view;
        i++;
        [self.itemViews addObject:view];
        [self.itemHeightConstraints addObject:heightConstraint];
    }
    
    self.itemHeight = itemY;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kHeightDuration * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        LECourseLessonSectionItemLEIAudioResponseItemView* view = [self.itemViews firstObject];
        view.expanded = YES;
    });
}

- (CGFloat)heightForItem {
    return self.itemHeight;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake([self widthForItem], [self heightForItem]);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"expanded"]) {
        LECourseLessonSectionItemLEIAudioResponseItemView* itemView = object;
        BOOL expanded = itemView.expanded;
        if (expanded) {
            for (LECourseLessonSectionItemLEIAudioResponseItemView* view in self.itemViews) {
                if (view.expanded && view != itemView) {
                    view.expanded = NO;
                }
            }
            if (!self.selected) {
                self.selected = YES;
            }
        } else {
            BOOL hasExpanded = NO;
            for (LECourseLessonSectionItemLEIAudioResponseItemView* view in self.itemViews) {
                if (view.expanded && view != itemView) {
                    hasExpanded = YES;
                }
            }
            if (!hasExpanded && self.selected) {
                self.selected = NO;
            }
        }
        
        [self updateItemViewHeightConstrant:itemView];
    } else if([keyPath isEqualToString:@"score"]) {
        LECourseLessonLEIAudioResponseItem* item = (LECourseLessonLEIAudioResponseItem*)self.item;
        __block int score = 0;
        __block BOOL complete = 1;
        [_record.record enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LEPageAudioRecord* ar = obj;
            if (ar.recordedCount < item.total || ar.score < Scoreline(0)) {
                complete = 0;
            }
            score += ar.score;
        }];
        _record.isCompleted = complete;
//        [item.responses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
//            score += ((LECourseLessonLEIAudioResponse*)obj).score;
//        }];
        _record.score =score/[item.responses count];
//        item.score = score/[item.responses count];
    }
}

- (void)setSelected:(BOOL)selected {
    if (!selected) {
        for (LECourseLessonSectionItemLEIAudioResponseItemView* view in self.itemViews) {
            if (view.expanded) {
                view.expanded = NO;
            }
        }
    } else {
        BOOL hasExpanded = NO;
        for (LECourseLessonSectionItemLEIAudioResponseItemView* view in self.itemViews) {
            if (view.expanded) {
                hasExpanded = YES;
                break;
            }
        }
        if (!hasExpanded) {
            LECourseLessonSectionItemLEIAudioResponseItemView* view = [self.itemViews firstObject];
            view.expanded = YES;
        }
    }
    [super setSelected:selected];
}
//更新录音条目高度。被点击到条目
- (void) updateItemViewHeightConstrant:(LECourseLessonSectionItemLEIAudioResponseItemView*)itemView {
    NSUInteger index = [self.itemViews indexOfObject:itemView];
    NSLayoutConstraint* heightConstraint =  [self.itemHeightConstraints objectAtIndex:index];
//    CGFloat height = [LECourseLessonSectionItemLEIAudioResponseItemView heightForReponse:itemView.expanded];
    CGFloat height = [itemView heightForReponse:itemView.expanded];
    CGFloat itemHeight = 0;
    for (NSLayoutConstraint* constraint in self.itemHeightConstraints) {
        if (constraint != heightConstraint) {
            itemHeight += constraint.constant;
        } else {
            itemHeight += height;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(sectionItemView:willChangeHeight:)]) {
        [self.delegate sectionItemView:self willChangeHeight:itemHeight];
    }
    //570全部收缩 630有一条展开
    [UIView animateWithDuration:kHeightDuration animations:^{
        heightConstraint.constant = height;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        __block BOOL hasExpanded = false;
        [self.itemViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LECourseLessonSectionItemLEIAudioResponseItemView* view = obj;
            if (view.expanded) {
                hasExpanded = true;
                return ;
            }
        }];
        //有展开的条目，并且当前布局高度大于新高度，保持不变。防止最后条目显示不全
        if (hasExpanded && self.itemHeight > itemHeight) {
            return ;
        }
        self.itemHeight = itemHeight;
        if ([self.delegate respondsToSelector:@selector(sectionItemView:didChangeHeight:)]) {
            [self.delegate sectionItemView:self didChangeHeight:itemHeight];
        }
    }];
}

- (void)destroySubViews {
    for (LECourseLessonSectionItemLEIAudioResponseItemView* view in self.itemViews) {
        [view reset];
        [view removeObserver:self forKeyPath:@"expanded"];
//        [view.response removeObserver:self forKeyPath:@"score"];
    }
    for (LEPageAudioRecord* ar in _record.record) {
        [ar removeObserver:self forKeyPath:@"score"];
    }
    [self.itemViews removeAllObjects];
    [super destroySubViews];
}

- (void)willDestroySubViews {
    
}

- (void)didDestroySubViews {
    
}

@end
