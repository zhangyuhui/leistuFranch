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
 
    self.itemViews = [NSMutableArray new];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setupTitleView];
    [self setupItemViews];
}

-(void)removeFromSuperview {
    if ([self.question.audios count] > 0) {
        NSString* audio = [self.question.audios firstObject];
        if (![NSString stringIsNilOrEmpty:audio]) {
            [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
                LECourseLessonSectionItemLEIPracticeAudioItemView* audioView = (LECourseLessonSectionItemLEIPracticeAudioItemView*)obj;
                [audioView removeObserver:self forKeyPath:@"playing"];
            }];
        }
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
    } else if ([self.question hasAnswers]) {
        [self setupFillItemViews];
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

-(void)setupFillItemViews {
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
    NSString* option = [self.question.options objectAtIndexedSubscript:index];
    NSString* image = [self.question.images objectAtIndexedSubscript:index];
    NSString* audio = [self.question.audios objectAtIndexedSubscript:index];
    
    if (![NSString stringIsNilOrEmpty:option]) {
        LECourseLessonSectionItemLEIPracticeOptionItemView* optionView = [self generatedOptionItemView:index frame:frame];
        view = optionView;
    } else if (![NSString stringIsNilOrEmpty:audio]) {
        LECourseLessonSectionItemLEIPracticeAudioItemView* audioView = [self generatedAudioItemView:index frame:frame];
        audioView.audio = [LECourseLessonSectionItemView pathForAsset:audio];
        [audioView addObserver:self forKeyPath:@"playing" options:NSKeyValueObservingOptionNew context:nil];
        view = audioView;
    } else if (![NSString stringIsNilOrEmpty:image]) {
        LECourseLessonSectionItemLEIPracticeImageItemView* imageView = [self generatedImageItemView:index frame:frame];
        imageView.image = [LECourseLessonSectionItemView pathForAsset:image];
        [imageView addObserver:self forKeyPath:@"playing" options:NSKeyValueObservingOptionNew context:nil];
        view = imageView;
    } else {
        LECourseLessonSectionItemLEIPracticeInputItemView* inputView = [self generatedInputItemView:index frame:frame];
        view = inputView;
    }
    
    view.multiple = ([self.question.answers count] > 1);
    
    if (self.submited) {
        BOOL isAnswer = [self.question.answers containsObject:[@(index+1) stringValue]];
        BOOL isSelection = [self.question.selections containsObject:[@(index+1) stringValue]];
        if (isAnswer && isSelection) {
            view.answer = LECourseLessonSectionItemLEIPracticeAnswerCorrect;
        } else if (isAnswer && !isSelection) {
            view.answer = LECourseLessonSectionItemLEIPracticeAnswerMiss;
        } else if (!isAnswer && isSelection) {
            view.answer = LECourseLessonSectionItemLEIPracticeAnswerWrong;
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
    }
}

@end
