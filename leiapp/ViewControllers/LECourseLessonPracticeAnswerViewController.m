//
//  LECourseLessonPracticeAnswerViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/6/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonPracticeAnswerViewController.h"
#import "LECourseLessonSectionItemLEIPracticeView.h"

#define kPageTitle                      @"课程答案"
#define kPagePadding                    10

@interface LECourseLessonPracticeAnswerViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView* scrollView;
@property (strong, nonatomic) IBOutlet UIView* contentView;
@property (strong, nonatomic) IBOutlet UIView* headerView;
@property (strong, nonatomic) IBOutlet UILabel* scoreLabel;
@property (strong, nonatomic) IBOutlet UIImageView* scoreImageView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint* headerViewHeightConstraint;

@property (nonatomic, strong) LECourseLessonLEIPracticeItem* practice;
@property (nonatomic, strong) LECourseLesson* lesson;
@property (nonatomic, strong) LECourseLessonSection* section;
@property (nonatomic, strong) LEPageRecord* pageRecord;
@property (strong, nonatomic) NSMutableArray *  itemViews;
@property (assign, nonatomic) CGFloat  itemHeight;
@property (assign, nonatomic) int  score;
@end

@implementation LECourseLessonPracticeAnswerViewController

- (instancetype)initWithLEIPractice:(LECourseLessonLEIPracticeItem*)practice lesson:(LECourseLesson*)lesson section:(LECourseLessonSection*)section pageRecord:(LEPageRecord*) pageRecord{
    self = [super initWithNibName:nil bundle:nil];
    if (self){
        self.practice = practice;
        self.lesson = lesson;
        self.section = section;
        _pageRecord = pageRecord;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.title = kPageTitle;
    
    [self setupPracticeItemViews];
}

- (void)setupPracticeItemViews {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat itemPadding = kPagePadding;
    CGFloat itemWidth = screenRect.size.width - itemPadding*2.0;
    CGFloat itemX = itemPadding;
    CGFloat itemY = self.headerViewHeightConstraint.constant + kPagePadding;
    
    self.itemViews = [NSMutableArray new];
    
    int correctCount = 0;
    
    UIView* prevView = self.headerView;
    for (LECourseLessonLEIPracticeQuestion* question in self.practice.questions) {
        itemY += itemPadding;
        LECourseLessonSectionItemLEIPracticeView* view = [[LECourseLessonSectionItemLEIPracticeView alloc] initWithFrame:CGRectMake(itemX, itemY, itemWidth, 90)];
        
        view.submited = YES;
        
        __block BOOL isCorrect = true;
        if ([question.answers count] == [question.selections count]) {
            [question.answers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString* answer = (NSString*)obj;
                NSString* selection = [question.selections objectAtIndex:idx];
                if (![answer isEqualToString:selection]) {
                    isCorrect = false;
                    *stop = true;
                }
            }];
        } else {
            isCorrect = false;
        }
        
        if (isCorrect) {
            correctCount += 1;
        }
        
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
        
        
        [self.contentView addSubview:view];
        
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.contentView
                                                                             attribute:NSLayoutAttributeLeading
                                                                            multiplier:1.0
                                                                              constant:itemPadding];
        [self.contentView addConstraint:leadingConstraint];
        
         NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:prevView
                                                                             attribute:NSLayoutAttributeBottom
                                                                            multiplier:1.0
                                                                              constant:itemPadding];
            
        [self.contentView addConstraint:topConstraint];
        
        
        itemY += itemHeight;
        prevView = view;
        
        [self.itemViews addObject:view];
    }
    
    itemY += kPagePadding;
    
    
    NSLayoutConstraint *contentHeightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                               attribute:NSLayoutAttributeHeight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:nil
                                                                               attribute:NSLayoutAttributeHeight
                                                                              multiplier:0.0
                                                                                constant:itemY];
    
    [self.contentView addConstraint:contentHeightConstraint];
    
    NSLayoutConstraint *contentWidthConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:0.0
                                                                        constant:screenWidth];
    
    [self.contentView addConstraint:contentWidthConstraint];
    
    [self.scrollView setContentSize:CGSizeMake(contentWidthConstraint.constant, contentHeightConstraint.constant)];
    
    self.score = correctCount*100/[self.practice.questions count];
    
    self.lesson.score = self.score;
    self.practice.score = self.score;
    self.section.score = self.score;
    _pageRecord.score = self.score;
    self.scoreLabel.text = [@(self.score) stringValue];
    
    if (self.score < 60) {
        self.scoreImageView.highlighted = YES;
    }
}

@end
