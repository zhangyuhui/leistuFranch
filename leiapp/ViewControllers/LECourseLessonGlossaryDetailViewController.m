//
//  LECourseLessonGlossaryDetailViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/19/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonGlossaryDetailViewController.h"
#import "LECourseLessonGlossaryDetailStackedCardView.h"
#import "LEDefines.h"

#define kPageTitle                      @"生词卡"

#define kCardViewStackCount 3

#define kCardViewSwipeAnimationDuration 0.3

#define kCardViewTransformTranslateX 0
#define kCardViewTransformTranslateY 27
#define kCardViewTransformScaleX 0.92
#define kCardViewTransformScaleY 0.92

#define kCardViewSwipeAnimationVelocity 800

@interface LECourseLessonGlossaryDetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel* pageLabel;

@property (strong, nonatomic) NSArray* glossaries;

@property (strong, nonatomic) NSMutableArray *cardViews;
@property (strong, nonatomic) NSArray *cardTransforms;
@property (assign, nonatomic) int topViewIndex;
@property (assign, nonatomic) int topGlossaryIndex;

- (void)handlePanGesture:(UIPanGestureRecognizer*)recognizer;
- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer*)recognizer;
- (void)handleSwipeRightGesture:(UISwipeGestureRecognizer*)recognizer;
- (void)handleSwipeGesture:(UIView*)view left:(BOOL)left;

- (void)setupTransforms;
- (void)setupViews;
- (void)applyAllTransforms;
- (void)applyForwardTransforms;
- (void)applyBackwardTransforms;
- (void)applyTransform:(int)index;
- (void)applyTransforms:(int)offset;
@end

@implementation LECourseLessonGlossaryDetailViewController

- (instancetype)initWithGlossaries:(NSArray*)glossaries index:(NSUInteger)index {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.glossaries = glossaries;
        self.topGlossaryIndex = (int)index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = kPageTitle;
    
    self.view.layer.contents = (id)[UIImage imageNamed:@"courselessonglossarydetail_viewcontroller_background"].CGImage;
    
    _topViewIndex = 0;
    [self setupViews];
    [self setupTransforms];
    [self applyAllTransforms];
    
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%d", (self.topGlossaryIndex + 1), (int)[self.glossaries count]];
}

- (void)setupTransforms {
    CGFloat transformScaleX = kCardViewTransformScaleX;
    CGFloat transformScaleY = kCardViewTransformScaleY;
    CGFloat transformTranslateY = -kCardViewTransformTranslateY;
    NSMutableArray* transforms = [NSMutableArray new];
    CGAffineTransform transform = CGAffineTransformIdentity;
    [transforms addObject:[NSValue valueWithCGAffineTransform:transform]];
    for(NSInteger index = 1; index < kCardViewStackCount; index++) {
        transform = CGAffineTransformTranslate(CGAffineTransformScale(CGAffineTransformIdentity, transformScaleX, transformScaleY), 0, transformTranslateY);
        [transforms addObject:[NSValue valueWithCGAffineTransform:transform]];
        transformScaleX *= kCardViewTransformScaleX;
        transformScaleY *= kCardViewTransformScaleY;
        transformTranslateY -= kCardViewTransformTranslateY/kCardViewTransformScaleY;
    }
    
    transform = CGAffineTransformTranslate(transform, 0, kCardViewTransformTranslateY);
    [transforms addObject:[NSValue valueWithCGAffineTransform:transform]];
    
    self.cardTransforms = transforms;
}

- (void)setupViews {
    NSMutableArray* views = [NSMutableArray new];
    int totalGlossaries = (int)[self.glossaries count];
    for(NSInteger index = 0; index < kCardViewStackCount + 1; index++) {
        LECourseLessonGlossaryDetailStackedCardView *view = [LECourseLessonGlossaryDetailStackedCardView courseLessonGlossaryDetailStackedCardView];
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        view.backgroundColor = [UIColor whiteColor];
        
        view.layer.cornerRadius = 10;
        view.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        view.layer.borderWidth = 1;
        
        int glossaryIndex = (self.topGlossaryIndex + index)%totalGlossaries;
        view.glossary = [self.glossaries objectAtIndex:glossaryIndex];
        
        [self.view addSubview:view];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:20]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:-20]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:122.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:-50.0]];
        
        [self.view sendSubviewToBack:view];
        
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [view addGestureRecognizer:panGestureRecognizer];
        
        UISwipeGestureRecognizer * swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeLeftGesture:)];
        swipeLeftGestureRecognizer.direction=UISwipeGestureRecognizerDirectionLeft;
        [view addGestureRecognizer:swipeLeftGestureRecognizer];
        
        UISwipeGestureRecognizer * swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeRightGesture:)];
        swipeRightGestureRecognizer.direction=UISwipeGestureRecognizerDirectionRight;
        [view addGestureRecognizer:swipeRightGestureRecognizer];
        
        [views addObject:view];
    }
    self.cardViews = views;
}

- (void)applyAllTransforms {
    [self applyTransforms:0];
}

- (void)applyForwardTransforms {
    [self applyTransforms:1];
}

- (void)applyBackwardTransforms {
    [self applyTransforms:-1];
}

- (void)applyTransforms:(int)offset {
    int total = (int)[self.cardViews count];
    int current = (self.topViewIndex + offset)%total;
    [self.cardViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (offset == 0 || idx != self.topViewIndex) {
            int transformIdx = (total - current + idx)%total;
            UIView* view = obj;
            NSValue* transform = [self.cardTransforms objectAtIndex:transformIdx];
            view.transform = [transform CGAffineTransformValue];
        }
    }];
}

- (void)applyTransform:(int)index {
    int total = (int)[self.cardViews count];
    UIView* view = [self.cardViews objectAtIndex:index];
    int transformIdx = (total - self.topViewIndex + index)%total;
    NSValue* transform = [self.cardTransforms objectAtIndex:transformIdx];
    view.transform = [transform CGAffineTransformValue];
}

#pragma mark - Gesture Handlers

-(void)handlePanGesture:(UIPanGestureRecognizer*)recognizer {
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGFloat centerX = self.view.frame.size.width/2.0;
    CGFloat centerY = recognizer.view.center.y;
    CGPoint velocity = [recognizer velocityInView:recognizer.view];
    UIView* topView = [self.cardViews objectAtIndex:self.topViewIndex];
    if(UIGestureRecognizerStateEnded == [recognizer state]) {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        CGFloat velocityX = velocity.x > 0 ? velocity.x : -(velocity.x);
        CGFloat translationX = translation.x > 0 ? translation.x : - (translation.x);
        CGFloat width = recognizer.view.frame.size.width;
        if (velocityX >= kCardViewSwipeAnimationVelocity ||
            translationX >= width*0.3) {
            [self handleSwipeGesture:topView left:(velocity.x < 0)];
        } else {
            [UIView animateWithDuration:kCardViewSwipeAnimationDuration/2.0
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 topView.center = CGPointMake(centerX, centerY);
                             } completion:nil];
            
        }
    } else {
        topView.center = CGPointMake(centerX + translation.x, centerY);
    }
}

- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer*)recognizer {
    UIView* topView = [self.cardViews objectAtIndex:self.topViewIndex];
    [self handleSwipeGesture:topView left:YES];
}

- (void)handleSwipeRightGesture:(UISwipeGestureRecognizer*)recognizer {
    UIView* topView = [self.cardViews objectAtIndex:self.topViewIndex];
    [self handleSwipeGesture:topView left:NO];
}

- (void)handleSwipeGesture:(UIView*)view left:(BOOL)left {
    CGFloat centerX = self.view.frame.size.width/2.0;
    CGFloat centerY = self.view.frame.size.height/2.0;
    CGFloat width = self.view.frame.size.width*1.5;
    int forworda = left?1:-1;
    if (left) {
        width = width * -1;
    }
    [UIView animateWithDuration:kCardViewSwipeAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         view.transform = CGAffineTransformMakeTranslation(width, 0);
                         [self applyForwardTransforms];
                     } completion:^(BOOL finished) {
                         [self.view sendSubviewToBack:view];
                         int currentTopIndex = self.topViewIndex;
                         int totalCardViews = (int)[self.cardViews count];
                         int totalGlossaries = (int)[self.glossaries count];
                         int nextGlossaryIndex = (self.topGlossaryIndex + totalCardViews)%totalGlossaries;
                         self.topGlossaryIndex = (self.topGlossaryIndex + forworda)%totalGlossaries;
                         self.pageLabel.text = [NSString stringWithFormat:@"%d/%d", (self.topGlossaryIndex + forworda), (int)[self.glossaries count]];
                         LECourseLessonGlossaryDetailStackedCardView* cardView = (LECourseLessonGlossaryDetailStackedCardView*)view;
                         cardView.glossary = [self.glossaries objectAtIndex:(nextGlossaryIndex<0)?(nextGlossaryIndex+totalGlossaries):nextGlossaryIndex];
                         int nextTopIndex = self.topViewIndex + forworda;
                         if (nextTopIndex < 0) {
                             nextTopIndex += totalCardViews;
                         }else if(nextTopIndex>totalCardViews)
                         {
                             nextTopIndex -= totalCardViews;
                         }
                         nextTopIndex = nextTopIndex%totalCardViews;
                         self.topViewIndex = nextTopIndex;
                         [self applyTransform:currentTopIndex];
                         view.center = CGPointMake(centerX, centerY);
                     }];
}

# pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

@end
