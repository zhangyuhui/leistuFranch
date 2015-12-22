//
//  LECourseLessonsViewController.m
//  leiapp
//
//  Created by Yuhui Zhang on 9/7/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonsViewController.h"
#import "LECourseLessonsViewControllerLessonView.h"
#import "LECourseLessonsViewControllerMenuView.h"
#import "LECourseLessonDetailViewController.h"
#import "LECourseLessonRuleViewController.h"
#import "LECourseLessonGlossaryViewController.h"
#import "LECourseLessonBookmarkViewController.h"
#import "LECourseLessonStudyViewController.h"
#import "LECourseLessonSummarylViewController.h"
#import "LECourseService.h"
#import "LEDefines.h"
#import "GuideView.h"
#define kCourseSectionsViewControllerSwipeAnimationDuration 0.3
#define kCourseSectionsViewControllerTransformAnimationDuration 0.2

#define kCourseSectionsViewControllerSectionViewSpacingY 27
#define kCourseSectionsViewControllerTransformScaleX 0.92

#define kCourseSectionsViewControllerSwipeAnimationVelocity 800


@interface LECourseLessonsViewController () <UIGestureRecognizerDelegate, LECourseLessonsViewControllerMenuViewDelegate, LECourseLessonsViewControllerLessonViewDelegate>

@property (strong, nonatomic) IBOutlet UIPageControl *lessonsPageControl;
@property (strong, nonatomic) IBOutlet LECourseLessonsViewControllerLessonView *lessonView0;
@property (strong, nonatomic) IBOutlet LECourseLessonsViewControllerLessonView *lessonView1;
@property (strong, nonatomic) IBOutlet LECourseLessonsViewControllerLessonView *lessonView2;
@property (strong, nonatomic) IBOutlet LECourseLessonsViewControllerLessonView *lessonView3;
@property (strong, nonatomic) IBOutlet LECourseLessonsViewControllerLessonView *lessonViewPrev;
@property (strong, nonatomic) IBOutlet UIView *informationView;
@property (strong, nonatomic) IBOutlet LECourseLessonsViewControllerMenuView *informationMenuView;

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

-(IBAction)handleSectionViewPanGesture:(UIPanGestureRecognizer*)recognizer;

-(IBAction)handleInfomationViewTapGesture:(UITapGestureRecognizer*)recognizer;

@property (strong, nonatomic) NSMutableArray* lessonViews;
@property (strong, nonatomic) NSMutableArray* lessonTransforms;

@property (strong, nonatomic) LECourse* course;
@property (assign, nonatomic) NSUInteger topLessonIndex;
@property (assign, nonatomic) BOOL isPaging;
@property (assign, nonatomic) BOOL isPageDown;

- (void)setupTransforms;
- (void)setupViews;
- (void)applyLessons;
- (void)applyTransforms:(BOOL)animated;

- (void)clickSyncButton;
- (void)clickMoreButton;

- (void)showInformationView;
- (void)hideInformationView;
- (BOOL)isInformationViewShown;
@end

@implementation LECourseLessonsViewController

- (instancetype)initWithCourse:(LECourse*)course {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.course = course;
        _isPaging = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"单元";
    //增加指示页
    NSString *string = UserNameDefault(nil, @"lesson_userguide", @"lesson_userguide");
    if ([ORNULL(string) isEqualToString:@""]) {
        UserNameDefault(@"lesson_userguide", @"lesson_userguide", @"lesson_userguide");
        GuideView *guideView = [[GuideView alloc]initType:4];
        [guideView show];
    }
    UIButton *syncButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [syncButton addTarget:self action:@selector(clickSyncButton) forControlEvents:UIControlEventTouchUpInside];
    [syncButton setImage:[UIImage imageNamed:@"navigation_sync_normal"] forState:UIControlStateNormal];
    [syncButton setImage:[UIImage imageNamed:@"navigation_sync_highlight"] forState:UIControlStateHighlighted];
    [syncButton setImage:[UIImage imageNamed:@"navigation_sync_highlight"] forState:UIControlStateSelected];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton addTarget:self action:@selector(clickMoreButton) forControlEvents:UIControlEventTouchUpInside];
    [moreButton setImage:[UIImage imageNamed:@"navigation_more_normal"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"navigation_more_highlight"] forState:UIControlStateHighlighted];
    [moreButton setImage:[UIImage imageNamed:@"navigation_more_highlight"] forState:UIControlStateSelected];
    
    self.lessonView0.hidden = YES;
    
    self.lessonView0.delegate = self;
    self.lessonView1.delegate = self;
    self.lessonView2.delegate = self;
    self.lessonView3.delegate = self;
    
    [self setRightBarButtonItems:[NSArray arrayWithObjects: syncButton, moreButton, nil]];
    self.informationMenuView.menuDelegate = self;
    
    self.topLessonIndex = self.course.detail.historyLesson;
    self.lessonsPageControl.numberOfPages = [self.course.detail.lessons count];
    self.lessonsPageControl.currentPage = self.topLessonIndex;
    
    [self setupTransforms];
    [self setupViews];
    [self applyLessons];
    [self applyTransforms:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.lessonView0 refreshDisplay];
    [self.lessonView1 refreshDisplay];
    [self.lessonView2 refreshDisplay];
    [self.lessonView3 refreshDisplay];
}

- (void)setupTransforms {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    CGFloat transformScaleX = kCourseSectionsViewControllerTransformScaleX;
    CGFloat transformSpacingY = -kCourseSectionsViewControllerSectionViewSpacingY;
    
    CGAffineTransform transform0 = CGAffineTransformTranslate(CGAffineTransformIdentity, -screenWidth, 0);
    
    CGAffineTransform transform1 = CGAffineTransformIdentity;
    
    CGAffineTransform transform2 = CGAffineTransformTranslate(CGAffineTransformScale(CGAffineTransformIdentity, transformScaleX, transformScaleX), 0, transformSpacingY);
    
    transformScaleX = transformScaleX*transformScaleX;
    transformSpacingY -= kCourseSectionsViewControllerSectionViewSpacingY/kCourseSectionsViewControllerTransformScaleX;
    
    CGAffineTransform transform3 = CGAffineTransformTranslate(CGAffineTransformScale(CGAffineTransformIdentity, transformScaleX, transformScaleX), 0, transformSpacingY);
    
    self.lessonTransforms = [NSMutableArray arrayWithObjects:[NSValue valueWithCGAffineTransform:transform0], [NSValue valueWithCGAffineTransform:transform1], [NSValue valueWithCGAffineTransform:transform2], [NSValue valueWithCGAffineTransform:transform3], nil];
}

- (void)setupViews {
    self.lessonViews = [NSMutableArray arrayWithObjects:self.lessonView0, self.lessonView1, self.lessonView2, self.lessonView3, nil];
}

- (void)applyTransforms:(BOOL)animated {
    void(^performTranform)(void) = ^{
        [self.lessonViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView* lessonView = obj;
            NSValue* transform = [self.lessonTransforms objectAtIndex:idx];
            lessonView.transform = [transform CGAffineTransformValue];
        }];
    };
    
    if (animated) {
        [UIView animateWithDuration:kCourseSectionsViewControllerTransformAnimationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:performTranform completion:nil];
    } else {
        performTranform();
    }
}

- (void)applyLessons {
    NSArray* lessons = self.course.detail.lessons;
    __block int lessonIndex = (int)self.topLessonIndex;
    int totalLessons = (int)[self.course.detail.lessons count];
    if (lessonIndex > 0) {
        lessonIndex -= 1;
    } else {
        lessonIndex = totalLessons - 1;
    }
    [self.lessonViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LECourseLessonsViewControllerLessonView* lessonView = obj;
        lessonView.courseLesson = [lessons objectAtIndex:lessonIndex];
        lessonIndex += 1;
        if (lessonIndex > totalLessons - 1) {
            lessonIndex = 0;
        }
    }];
}

#pragma mark - Information View
- (void)showInformationView {
    if (self.informationView.hidden) {
        self.informationView.alpha = 0.0;
        self.informationView.hidden = NO;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.informationView.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)hideInformationView {
    if (!self.informationView.hidden) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.informationView.alpha = 0.0;
                         }
                        completion:^(BOOL finished) {
                            self.informationView.hidden = YES;
                            self.informationView.alpha = 1.0;
                        }];
    }
    
}

- (BOOL)isInformationViewShown {
    return (self.informationView.hidden == NO);
}

#pragma mark - Gesture Handlers
-(IBAction)handleSectionViewPanGesture:(UIPanGestureRecognizer*)recognizer {
    CGPoint velocity = [recognizer velocityInView:recognizer.view];
    if(UIGestureRecognizerStateBegan == [recognizer state]){
        BOOL isPageDown = YES;
        if (velocity.x > 0) {
            isPageDown = NO;
        }
        self.isPaging = YES;
        self.isPageDown = isPageDown;
    }
    
    LECourseLessonsViewControllerLessonView* topView;
    if (self.isPageDown) {
        topView = [self.lessonViews objectAtIndex:1];
    } else {
        topView = [self.lessonViews objectAtIndex:0];
        topView.hidden = NO;
    }
    
    CGPoint translation = [recognizer translationInView:topView];
    
    if(UIGestureRecognizerStateEnded == [recognizer state]){
        self.isPaging = NO;
        CGPoint translation = [recognizer translationInView:topView];
        CGFloat velocityX = velocity.x > 0 ? velocity.x : -(velocity.x);
        CGFloat translationX = translation.x > 0 ? translation.x : - (translation.x);
        CGFloat width = topView.frame.size.width;
        if (velocityX >= kCourseSectionsViewControllerSwipeAnimationVelocity ||
            translationX >= width*0.3) {
            LECourseLessonsViewControllerLessonView* trickView;
            if (self.isPageDown) {
                trickView = [self.lessonViews firstObject];
                trickView.hidden = YES;
                [self.view sendSubviewToBack: trickView];
            } else {
                trickView = [self.lessonViews lastObject];
                trickView.hidden = YES;
            }
            [UIView animateWithDuration:kCourseSectionsViewControllerSwipeAnimationDuration
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.lessonViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                     UIView* lessonView = obj;
                                     NSValue* transform;
                                     int total = (int)[self.lessonTransforms count];
                                     if (self.isPageDown) {
                                         if (idx > 0) {
                                             transform = [self.lessonTransforms objectAtIndex:idx-1];
                                         } else {
                                             transform = [self.lessonTransforms objectAtIndex:total-1];
                                         }
                                     } else {
                                         if (idx < total - 1) {
                                             transform = [self.lessonTransforms objectAtIndex:idx+1];
                                         } else {
                                             transform = [self.lessonTransforms objectAtIndex:0];
                                         }
                                     }
                                     lessonView.transform = [transform CGAffineTransformValue];
                                     
                                 }];
                             } completion:^(BOOL finished) {
                                 if (self.isPageDown) {
                                     [self.lessonViews removeObject:trickView];
                                     [self.lessonViews addObject:trickView];
                                     trickView.hidden = NO;
                                     topView.hidden = YES;
                                 } else {
                                     [self.lessonViews removeObject:trickView];
                                     [self.lessonViews insertObject:trickView atIndex:0];
                                     [self.view bringSubviewToFront:trickView];
                                 }
                                 
                                 if (self.isPageDown) {
                                     int viewsTotal = (int)[self.lessonViews count];
                                     int lessonsTotal = (int)[self.course.detail.lessons count];
                                     LECourseLessonsViewControllerLessonView* prevView = [self.lessonViews objectAtIndex:viewsTotal - 2];
                                     int prevViewLessonIndex = prevView.courseLesson.index;
                                     int trivViewLessonIndex;
                                     if (prevViewLessonIndex < lessonsTotal - 1) {
                                         trivViewLessonIndex = prevViewLessonIndex + 1;
                                     } else {
                                         trivViewLessonIndex = 0;
                                     }
                                     trickView.courseLesson = [self.course.detail.lessons objectAtIndex:trivViewLessonIndex];
                                     
                                     self.topLessonIndex += 1;
                                     if (self.topLessonIndex >= lessonsTotal) {
                                         self.topLessonIndex = 0;
                                     }
                                     self.lessonsPageControl.currentPage = self.topLessonIndex;
                                 } else {
                                     int lessonsTotal = (int)[self.course.detail.lessons count];
                                     if (self.topLessonIndex == 0) {
                                         self.topLessonIndex = lessonsTotal - 1;
                                     } else {
                                         self.topLessonIndex = self.topLessonIndex - 1;
                                     }
                                     self.lessonsPageControl.currentPage = self.topLessonIndex;
                                     
                                     int trivViewLessonIndex;
                                     if (self.topLessonIndex == 0) {
                                         trivViewLessonIndex = lessonsTotal - 1;
                                     } else {
                                         trivViewLessonIndex = (int)(self.topLessonIndex - 1);
                                     }
                                     trickView.courseLesson = [self.course.detail.lessons objectAtIndex:trivViewLessonIndex];
                                 }
                                 
                                 LECourseLessonsViewControllerLessonView* newTopView = [self.lessonViews objectAtIndex:1];
                                 self.course.detail.historyLesson = newTopView.courseLesson.index;
                             }];
        } else {
            [UIView animateWithDuration:kCourseSectionsViewControllerSwipeAnimationDuration/2.0
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 NSValue* transform;
                                 if (self.isPageDown) {
                                     transform = [self.lessonTransforms objectAtIndex:1];
                                 } else {
                                     transform = [self.lessonTransforms objectAtIndex:0];
                                 }
                                 topView.transform = [transform CGAffineTransformValue];
                             } completion:^(BOOL finished) {
                                 if (!self.isPageDown) {
                                     topView.hidden = YES;
                                 }
                             }];
            
        }
    } else {
        NSValue* transform;
        if (self.isPageDown) {
            transform = [self.lessonTransforms objectAtIndex:1];;
        } else {
            transform = [self.lessonTransforms objectAtIndex:0];
        }
        topView.transform = CGAffineTransformTranslate([transform CGAffineTransformValue], translation.x, 0);
    }
}

# pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.tapGestureRecognizer) {
        CGPoint pointInView = [touch locationInView:gestureRecognizer.view];
        
        if (CGRectContainsPoint(self.informationMenuView.frame, pointInView) ) {
            return NO;
        }
    }
    return YES;
}


# pragma mark Gesture Handlers
-(IBAction)handleInfomationViewTapGesture:(UITapGestureRecognizer*)recognizer {
    [self hideInformationView];
}

# pragma mark Bar Button Actions
- (void)clickSyncButton {
    [self showIndicatorView];
    LECourseService* courseService = [LECourseService sharedService];
    [courseService uploadStudyRecords:courseService.records success:^(LECourseService *service) {
        [self hideIndicatorView];
        NSDate * senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        NSLog(@"locationString:%@",locationString);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        UserNameDefault(senddate, @"syncTime", [NSString stringWithFormat:@"syncTime%@",setUserID(nil)]);
    } failure:^(LECourseService *service, NSString *error) {
        [self hideIndicatorView];
        if (error != nil) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"同步出错"
//                                                            message:@"同步学习记录出错."
//                                                           delegate:self
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
        }
    }];
}

- (void)clickMoreButton {
    [self.view bringSubviewToFront:self.informationView];
    [self showInformationView];
}

# pragma mark LECourseLessonsViewControllerMenuViewDelegate

- (void)menuView:(LECourseLessonsViewControllerMenuView*)menuView didSelectMenu:(LECourseLessonsViewControllerMenu)menu {
    [self hideInformationView];
    
    switch (menu) {
        case LECourseLessonsViewControllerMenuDetail: {
            LECourseLessonDetailViewController* viewController = [[LECourseLessonDetailViewController alloc] initWithCourse:self.course];
            [self.navigationController pushViewController:viewController animated:YES];
            }
            break;
        case LECourseLessonsViewControllerMenuRule: {
            LECourseLessonRuleViewController* viewController = [[LECourseLessonRuleViewController alloc] initWithCourse:self.course];
            [self.navigationController pushViewController:viewController animated:YES];
            }
            break;
        case LECourseLessonsViewControllerMenuVocabulary: {
            LECourseLessonGlossaryViewController* viewController = [[LECourseLessonGlossaryViewController alloc] initWithCourse:self.course];
            [self.navigationController pushViewController:viewController animated:YES];
            }
            break;
        case LECourseLessonsViewControllerMenuBookmark: {
            LECourseLessonBookmarkViewController* viewController = [[LECourseLessonBookmarkViewController alloc] initWithCourse:self.course];
            [self.navigationController pushViewController:viewController animated:YES];           
            }
            break;
    }
}



#pragma mark - LECourseLessonsViewControllerLessonViewDelegate
- (void)courseLessonsViewControllerLessonView:(LECourseLessonsViewControllerLessonView*)courseLessonsViewControllerLessonView studyLesson:(LECourseLesson*)lesson {
    LECourseLessonSummarylViewController* viewController = [[LECourseLessonSummarylViewController alloc] initWithCourseAndLesson:self.course lesson:lesson];
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
