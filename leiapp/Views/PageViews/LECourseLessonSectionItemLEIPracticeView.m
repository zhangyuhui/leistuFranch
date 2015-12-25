//
//  LECourseLessonSectionItemLEIPracticeView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/5/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIPracticeView.h"
#import "LECourseLessonSectionItemLEIPracticeOptionItemView.h"
#import "LECourseLessonSectionItemLEIPracticeAudioItemView.h"
#import "LEPreferenceService.h"
#import "LECourseLessonSectionItemView.h"
#import "NSString+Addition.h"
#import "LECourseLessonSectionItemLEIPracticeInputItemView.h"
#import "LECourseLessonSectionItemLEIPracticeImageItemView.h"

#define kItemViewTopSpacing 10
#define kItemViewBetweenSpacing 5

@interface LECourseLessonSectionItemLEIPracticeView ()

@property (strong, nonatomic) UILabel* questionLabel;
@property (assign, nonatomic) CGFloat  viewHeight;
@property (strong, nonatomic) NSMutableArray*  itemViews;

-(void)setupTitleView;
-(void)setupItemViews;
-(LECourseLessonSectionItemLEIPracticeItemView*)generatedItemView:(int)index frame:(CGRect)frame;
@end

@implementation LECourseLessonSectionItemLEIPracticeView

-(void)setQuestion:(LECourseLessonLEIPracticeQuestion *)question {
    _question = question;
    _playing = NO;
 
    if ([question hasInputs]) {
        if (self.question.selections == nil || [self.question.selections count] == 0) {
            NSUInteger count = [self.question.answers count];
            NSMutableArray* selections = [NSMutableArray arrayWithCapacity:count];
            for (NSUInteger i = 0; i < count ; i ++) {
                [selections addObject:@""];
            }
            self.question.selections = selections;
        }
    }
    
    self.itemViews = [NSMutableArray new];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setupTitleView];
    [self setupItemViews];
    
    __block BOOL editable = NO;
    [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        LECourseLessonSectionItemLEIPracticeItemView* otherView = (LECourseLessonSectionItemLEIPracticeItemView*)obj;
        if (otherView.editable) {
            editable = YES;
            *stop = YES;
        }
    }];
    
    self.editable = editable;
    self.editing = NO;
}

- (void)setEditing:(BOOL)editing {
    _editing = editing;
    if (!editing) {
        [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            LECourseLessonSectionItemLEIPracticeItemView* otherView = (LECourseLessonSectionItemLEIPracticeItemView*)obj;
            if (otherView.editing) {
                otherView.editing = NO;
            }
        }];
    }
}

-(void)removeFromSuperview {
    if ([self.question hasAudios]) {
        [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            LECourseLessonSectionItemLEIPracticeAudioItemView* audioView = (LECourseLessonSectionItemLEIPracticeAudioItemView*)obj;
            [audioView removeObserver:self forKeyPath:@"playing"];
        }];
    }
    if ([self.question hasInputs]) {
        [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            LECourseLessonSectionItemLEIPracticeInputItemView* audioView = (LECourseLessonSectionItemLEIPracticeInputItemView*)obj;
            [audioView removeObserver:self forKeyPath:@"editing"];
        }];
    }
    [super removeFromSuperview];
}

-(void)setupTitleView {
    CGRect  screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat labelPadding = [[LEPreferenceService sharedService] paddingSize];
    CGFloat labelFontSize = [[LEPreferenceService sharedService] fontSize];
    UIFont* labelFont = [UIFont systemFontOfSize:labelFontSize];
    UIColor* labelColor = [UIColor darkGrayColor];
    
    CGFloat labelWidth = screenWidth - labelPadding*2.0;
    
    NSString* questionText = [NSString stringWithFormat:@"%d. %@", (self.question.index + 1), self.question.question];
    
    CGRect labelRect = [questionText boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:labelFont} context:nil];
    
    CGFloat labelHeight = labelRect.size.height;
    
    self.questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
    self.questionLabel.font = labelFont;
    self.questionLabel.textColor = labelColor;
    self.questionLabel.numberOfLines = 0;
    self.questionLabel.text = questionText;
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.questionLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:0
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:0.0
                                                                         constant:labelHeight];
    [self.questionLabel addConstraint:heightConstraint];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.questionLabel
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:0
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:0.0
                                                                         constant:labelWidth];
    [self.questionLabel addConstraint:widthConstraint];
    
    [self addSubview:self.questionLabel];
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.questionLabel
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1.0
                                                                          constant:0];
    [self addConstraint:leadingConstraint];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.questionLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0];
    [self addConstraint:topConstraint];
    
    self.viewHeight = labelHeight;
}

-(void)setupItemViews {
    if ([self.question hasImages]) {
        [self setupImageItemViews];
    } else if ([self.question hasOptions]) {
        [self setupRegularItemViews];
    } else if ([self.question hasInputs]) {
        [self setupInputItemViews];
    } else {
        [self setupFillItemView];
    }
}

-(void)setupRegularItemViews {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat viewPadding = [[LEPreferenceService sharedService] paddingSize];
    CGFloat viewWidth = screenWidth - viewPadding*2.0;
    CGFloat viewHeight = self.viewHeight;
    int itemCount = (int)[self.question.options count];
    
    UIView* prevView;
    for (int itemIndex = 0 ; itemIndex < itemCount; itemIndex ++) {
        if (prevView) {
            viewHeight += kItemViewBetweenSpacing;
        } else {
            viewHeight += kItemViewTopSpacing;
        }
        
        LECourseLessonSectionItemLEIPracticeItemView* view = [self generatedItemView:itemIndex frame:CGRectMake(0, 0, viewWidth, CGFLOAT_MAX)];
        
        view.index = itemIndex;
        
        [self addSubview:view];
        
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeLeading
                                                                            multiplier:1.0
                                                                              constant:0];
        [self addConstraint:leadingConstraint];
        
        NSLayoutConstraint *topConstraint;
        if (prevView) {
            topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:prevView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:kItemViewBetweenSpacing];
        } else {
            topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.questionLabel
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:kItemViewTopSpacing];
            
        }
        [self addConstraint:topConstraint];
        prevView = view;
        viewHeight += view.frame.size.height;
        
        [self.itemViews addObject:view];
    }
    self.viewHeight = viewHeight;
}

-(void)setupImageItemViews {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat viewPadding = [[LEPreferenceService sharedService] paddingSize];
    CGFloat viewWidth = (screenWidth - viewPadding*5.0)/2.0;
    CGFloat viewHeight = -1;
    int itemCount = (int)[self.question.images count];
    
    CGFloat viewX = viewPadding;
    CGFloat viewY = self.viewHeight + viewPadding;
    for (int itemIndex = 0 ; itemIndex < itemCount; itemIndex ++) {
        LECourseLessonSectionItemLEIPracticeItemView* view = [self generatedItemView:itemIndex frame:CGRectMake(viewX, viewY, viewWidth, CGFLOAT_MAX)];
        
        if (viewHeight < 0) {
            viewHeight = [view heightForView];
        }
        
        CGRect frame = view.frame;
        frame.size.height = viewHeight;
        view.frame = frame;
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeWidth
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeWidth
                                                                            multiplier:0.0
                                                                              constant:viewWidth];
        [view addConstraint:widthConstraint];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeHeight
                                                                          multiplier:0.0
                                                                            constant:viewHeight];
        [view addConstraint:heightConstraint];
        
        view.index = itemIndex;
        
        [self addSubview:view];
        
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeLeading
                                                                            multiplier:1.0
                                                                              constant:viewX];
        [self addConstraint:leadingConstraint];
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0
                                                                          constant:viewY];
            
        [self addConstraint:topConstraint];
        
        if (itemIndex % 2 == 0) {
            viewX += viewWidth + viewPadding;
        } else {
            viewX = viewPadding;
            viewY += viewHeight + viewPadding;
        }
        
        [self.itemViews addObject:view];
    }
    
    if (itemCount % 2 == 1) {
        viewY += viewHeight + viewPadding;
    }
    
    self.viewHeight = viewY;
}

-(void)setupInputItemViews {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat viewPadding = [[LEPreferenceService sharedService] paddingSize];
    CGFloat viewWidth = (screenWidth - viewPadding*2.0);
    CGFloat viewHeight = -1;
    int itemCount = (int)[self.question.selections count];
    
    CGFloat viewX = 0;
    CGFloat viewY = self.viewHeight + viewPadding;
    for (int itemIndex = 0 ; itemIndex < itemCount; itemIndex ++) {
        LECourseLessonSectionItemLEIPracticeItemView* view = [self generatedItemView:itemIndex frame:CGRectMake(viewX, viewY, viewWidth, CGFLOAT_MAX)];
        
        if (viewHeight < 0) {
            viewHeight = [view heightForView];
        }
        
        CGRect frame = view.frame;
        frame.size.height = viewHeight;
        view.frame = frame;
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeWidth
                                                                          multiplier:0.0
                                                                            constant:viewWidth];
        [view addConstraint:widthConstraint];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeHeight
                                                                           multiplier:0.0
                                                                             constant:viewHeight];
        [view addConstraint:heightConstraint];
        
        view.index = itemIndex;
        
        [self addSubview:view];
        
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeLeading
                                                                            multiplier:1.0
                                                                              constant:viewX];
        [self addConstraint:leadingConstraint];
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0
                                                                          constant:viewY];
        
        [self addConstraint:topConstraint];
        
        if (itemIndex % 2 == 0) {
            viewX += viewWidth + viewPadding;
        } else {
            viewX = viewPadding;
            viewY += viewHeight + viewPadding;
        }
        
        [self.itemViews addObject:view];
    }
    
    if (itemCount % 2 == 1) {
        viewY += viewHeight + viewPadding;
    }
    
    self.viewHeight = viewY;
}

-(void)setupFillItemView {
    
}

-(LECourseLessonSectionItemLEIPracticeOptionItemView*)generatedOptionItemView:(int)index frame:(CGRect)frame {
    NSString* option = [self.question.options objectAtIndexedSubscript:index];
    LECourseLessonSectionItemLEIPracticeOptionItemView* optionView = [[LECourseLessonSectionItemLEIPracticeOptionItemView alloc] initWithFrame:frame];
    optionView.option = option;
    return optionView;
}

-(LECourseLessonSectionItemLEIPracticeAudioItemView*)generatedAudioItemView:(int)index frame:(CGRect)frame {
    NSString* audio = [self.question.audios objectAtIndexedSubscript:index];
    LECourseLessonSectionItemLEIPracticeAudioItemView* audioView = [[LECourseLessonSectionItemLEIPracticeAudioItemView alloc] initWithFrame:frame];
    audioView.audio = [LECourseLessonSectionItemView pathForAsset:audio];
    return audioView;
}

-(LECourseLessonSectionItemLEIPracticeImageItemView*)generatedImageItemView:(int)index frame:(CGRect)frame {
    NSString* image = [self.question.images objectAtIndexedSubscript:index];
    LECourseLessonSectionItemLEIPracticeImageItemView* imageView = [[LECourseLessonSectionItemLEIPracticeImageItemView alloc] initWithFrame:frame];
    imageView.image = [LECourseLessonSectionItemView pathForAsset:image];
    return imageView;
}

-(LECourseLessonSectionItemLEIPracticeInputItemView*)generatedInputItemView:(int)index frame:(CGRect)frame {
    LECourseLessonSectionItemLEIPracticeInputItemView* inputView = [[LECourseLessonSectionItemLEIPracticeInputItemView alloc] initWithFrame:frame];
    return inputView;
}

-(LECourseLessonSectionItemLEIPracticeItemView*)generatedItemView:(int)index frame:(CGRect)frame {
    LECourseLessonSectionItemLEIPracticeItemView* view;
    if ([self.question hasOptions]) {
        LECourseLessonSectionItemLEIPracticeOptionItemView* optionView = [self generatedOptionItemView:index frame:frame];
        view = optionView;
    } else if ([self.question hasAudios]) {
        NSString* audio = [self.question.audios objectAtIndexedSubscript:index];
        LECourseLessonSectionItemLEIPracticeAudioItemView* audioView = [self generatedAudioItemView:index frame:frame];
        audioView.audio = [LECourseLessonSectionItemView pathForAsset:audio];
        [audioView addObserver:self forKeyPath:@"playing" options:NSKeyValueObservingOptionNew context:nil];
        view = audioView;
    } else if ([self.question hasImages]) {
        NSString* image = [self.question.images objectAtIndexedSubscript:index];
        LECourseLessonSectionItemLEIPracticeImageItemView* imageView = [self generatedImageItemView:index frame:frame];
        imageView.image = [LECourseLessonSectionItemView pathForAsset:image];
        view = imageView;
    } else {
        LECourseLessonSectionItemLEIPracticeInputItemView* inputView = [self generatedInputItemView:index frame:frame];
        inputView.input = [self.question.selections objectAtIndex:index];
        [inputView addObserver:self forKeyPath:@"editing" options:NSKeyValueObservingOptionNew context:nil];
        view = inputView;
    }
    
    if (![self.question hasInputs]) {
        view.multiple = ([self.question.answers count] > 1);
    } else {
        view.multiple = NO;
    }
    
    if (self.submited) {
        if (![self.question hasInputs]) {
            BOOL isAnswer = [self.question.answers containsObject:[@(index+1) stringValue]];
            BOOL isSelection = [self.question.selections containsObject:[@(index+1) stringValue]];
            if (isAnswer && isSelection) {
                view.answer = LECourseLessonSectionItemLEIPracticeAnswerCorrect;
            } else if (isAnswer && !isSelection) {
                view.answer = LECourseLessonSectionItemLEIPracticeAnswerMiss;
            } else if (!isAnswer && isSelection) {
                view.answer = LECourseLessonSectionItemLEIPracticeAnswerWrong;
            }
        } else {
            NSString* answer = [self.question.answers objectAtIndex:index];
            NSString* selection = [self.question.selections objectAtIndex:index];
            if ([answer caseInsensitiveCompare:selection] == NSOrderedSame) {
                view.answer = LECourseLessonSectionItemLEIPracticeAnswerCorrect;
            } else {
                view.answer = LECourseLessonSectionItemLEIPracticeAnswerWrong;
            }
        }
    }
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    CGFloat viewHeight = [view heightForView];
    CGFloat viewWidth = frame.size.width;
    
    CGRect viewFrame = view.frame;
    viewFrame.size.height = viewHeight;
    view.frame = viewFrame;
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:0
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:0.0
                                                                         constant:viewHeight];
    [view addConstraint:heightConstraint];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:0
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:0.0
                                                                         constant:viewWidth];
    [view addConstraint:widthConstraint];
    
    if (!self.submited) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(clickItemView:)];
        [view addGestureRecognizer:tapGestureRecognizer];
    }

    return view;
}

-(CGFloat)heightForView {
    return self.viewHeight;
}

-(void)clickItemView:(UITapGestureRecognizer*)recognizer {
    LECourseLessonSectionItemLEIPracticeItemView* view = (LECourseLessonSectionItemLEIPracticeItemView*)recognizer.view;
    if (view.editable == NO) {
        view.checked = !view.checked;
        [self updateSelection:view.index selected:view.checked];
        
        if (view.checked && !view.multiple) {
            for (LECourseLessonSectionItemLEIPracticeItemView* itemView in self.itemViews) {
                if (itemView != view && itemView.checked) {
                    itemView.checked = NO;
                    [self updateSelection:itemView.index selected:itemView.checked];
                }
            }
        }
    } else {
        view.editing = YES;
        for (LECourseLessonSectionItemLEIPracticeItemView* itemView in self.itemViews) {
            if (itemView != view && itemView.editing) {
                itemView.editing = NO;
            }
        }
    }
}

-(void)updateSelection:(int)index selected:(BOOL)selected {
    NSMutableArray* selections = [NSMutableArray arrayWithArray:self.question.selections];
    NSString* selection = [@(index+1) stringValue];
    if (selected) {
        if (![selections containsObject:selection]) {
            [selections addObject:selection];
        }
    } else {
        if ([selections containsObject:selection]) {
            [selections removeObject:selection];
        }
    }
    self.question.selections = selections;
}

-(void)setPlaying:(BOOL)playing {
    if (_playing != playing) {
        _playing = playing;
        if (!_playing) {
            [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
                LECourseLessonSectionItemLEIPracticeAudioItemView* view = (LECourseLessonSectionItemLEIPracticeAudioItemView*)obj;
                if ([view isAudioPlaying]) {
                    [view stopAudioPlay];
                }
            }];
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (LECourseLessonSectionItemLEIPracticeItemView* view in self.itemViews) {
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
        LECourseLessonSectionItemLEIPracticeAudioItemView* audioView = (LECourseLessonSectionItemLEIPracticeAudioItemView*)object;
        if (audioView.playing) {
            [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
                LECourseLessonSectionItemLEIPracticeAudioItemView* otherView = (LECourseLessonSectionItemLEIPracticeAudioItemView*)obj;
                if ([otherView isAudioPlaying] && audioView != otherView) {
                    [otherView stopAudioPlay];
                }
            }];
            if (!self.playing) {
                self.playing = YES;
            }
        } else {
            __block BOOL isPlaying = NO;
            [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
                LECourseLessonSectionItemLEIPracticeAudioItemView* otherView = (LECourseLessonSectionItemLEIPracticeAudioItemView*)obj;
                if ([otherView isAudioPlaying]) {
                    isPlaying = YES;
                    *stop = YES;
                }
            }];
            if (!isPlaying) {
                self.playing = NO;
            }
        }
    } else if([keyPath isEqualToString:@"editing"]) {
        LECourseLessonSectionItemLEIPracticeInputItemView* inputView = (LECourseLessonSectionItemLEIPracticeInputItemView*)object;
        if (!inputView.editing) {
            NSMutableArray* selections = [NSMutableArray arrayWithArray:self.question.selections];
            [selections replaceObjectAtIndex:inputView.index withObject:inputView.input];
            self.question.selections = selections;
        }
        
        __block BOOL editing = NO;
        [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            LECourseLessonSectionItemLEIPracticeInputItemView* otherView = (LECourseLessonSectionItemLEIPracticeInputItemView*)obj;
            if (otherView.editing) {
                editing = YES;
                *stop = YES;
            }
        }];
        self.editing = editing;
    }
}

@end
