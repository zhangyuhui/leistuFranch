//
//  LECourseLessonsViewControllerLessonView.m
//  leiapp
//
//  Created by Yuhui Zhang on 9/7/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonsViewControllerLessonView.h"
#import "LEDefines.h"
#import "LECourseService.h"
#import "NSString+Addition.h"
#import "RTLabel.h"
#import "LEConstants.h"
@interface LECourseLessonsViewControllerLessonView ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIView *downloadView;
@property (strong, nonatomic) IBOutlet UIView *studyView;

@property (strong, nonatomic) IBOutlet UIImageView *downloadImageView;
@property (strong, nonatomic) IBOutlet RTLabel *downloadPercentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *downloadStatusLabel;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton;

@property (strong, nonatomic) IBOutlet UIView *studyScoreView;
@property (strong, nonatomic) IBOutlet UIView *studyPercentageView;
@property (strong, nonatomic) IBOutlet UILabel *studyDurationLabel;
@property (strong, nonatomic) IBOutlet RTLabel *studyPercentageLabel;
@property (strong, nonatomic) IBOutlet RTLabel *studyScoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *studyButton;

-(IBAction)clickDownload:(id)sender;
-(IBAction)clickStudy:(id)sender;


@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *customConstraints;

- (void)updateStatusDisplay;
- (void)updatePercentageDisplay;

@end
static int completeCount, score, studyTime;

@implementation LECourseLessonsViewControllerLessonView

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausedDownloadCourse) name:kLENotificationApplicationWillResignActive object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueDownloadCourse) name:kLENotificationApplicationDidBecomeActive object:nil];
    _customConstraints = [[NSMutableArray alloc] init];
    
    UIView *view = nil;
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"LECourseLessonsViewControllerLessonView"
                                                     owner:self
                                                   options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[UIView class]]) {
            view = object;
            break;
        }
    }
    
    if (view != nil) {
        _containerView = view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        [self setNeedsUpdateConstraints];
        
        view.layer.cornerRadius = 10;
        view.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        view.layer.borderWidth = 1;
        
        self.studyScoreView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.studyScoreView.layer.borderWidth = 1;
        
        self.studyPercentageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.studyPercentageView.layer.borderWidth = 1;
        
        self.studyPercentageLabel.textAlignment = kCTCenterTextAlignment;
        self.studyPercentageLabel.textColor = [UIColor darkGrayColor];
        
        self.studyScoreLabel.textAlignment = kCTCenterTextAlignment;
        self.studyScoreLabel.textColor = [UIColor darkGrayColor];
        
        self.downloadPercentageLabel.textAlignment = kCTCenterTextAlignment;
        self.downloadPercentageLabel.textColor = [UIColor darkGrayColor];
    }
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickStudy:)];
//    tap.numberOfTapsRequired = 1;
//    [self addGestureRecognizer:tap];
}

- (void)dealloc {
    if (self.courseLesson != nil) {
        [self.courseLesson removeObserver:self forKeyPath:@"downloadStatus"];
        [self.courseLesson removeObserver:self forKeyPath:@"downloadPercentage"];
    }
}

- (void)refreshDisplay {
    [self updateStatusDisplay];
}

- (void)updateConstraints {
    [self removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];
    
    if (self.containerView != nil) {
        UIView *view = self.containerView;
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"H:|[view]|" options:0 metrics:nil views:views]];
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"V:|[view]|" options:0 metrics:nil views:views]];
        
        [self addConstraints:self.customConstraints];
    }
    
    [super updateConstraints];
}

- (void)setCourseLesson:(LECourseLesson *)courseLesson {
    if (_courseLesson != courseLesson) {
        if (self.courseLesson != nil) {
            [self.courseLesson removeObserver:self forKeyPath:@"downloadStatus"];
            [self.courseLesson removeObserver:self forKeyPath:@"downloadPercentage"];
        }
        _courseLesson = courseLesson;
        
        self.titleLabel.text = self.courseLesson.title;
        [self updateStatusDisplay];
        
        [self.courseLesson addObserver:self forKeyPath:@"downloadStatus" options:NSKeyValueObservingOptionNew context:nil];
        [self.courseLesson addObserver:self forKeyPath:@"downloadPercentage" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"downloadStatus"]) {
        [self updateStatusDisplay];
    } else if([keyPath isEqualToString:@"downloadPercentage"]) {
        [self updatePercentageDisplay];
    }
}

- (void)updateStatusDisplay {
    LELessonStatus status = self.courseLesson.downloadStatus;
    [self caluLessonProgress];
    if (status < LELessonStatusStudyReady){
        NSString* buttonTitle = @"";
        if (self.downloadView.hidden == YES) {
            self.downloadView.alpha = 0;
            self.downloadView.hidden = NO;
            [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
                self.downloadView.alpha = 1.0;
                self.studyView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.studyView.hidden = YES;
                self.studyView.alpha = 1.0;
            }];
        }
        if (status == LELessonStatusDownloadReady) {
            self.downloadImageView.hidden = NO;
            self.downloadPercentageLabel.hidden = YES;
            self.downloadStatusLabel.text = @"还未下载本单元的音视频文件";
            buttonTitle = @"下载音视频";
        } else {
            self.downloadImageView.hidden = YES;
            self.downloadPercentageLabel.hidden = NO;
            self.downloadPercentageLabel.text = [NSString stringWithFormat:@"<font size=24>%d</font><font size=12>%%</font>", self.courseLesson.downloadPercentage];
            if (status == LELessonStatusDownloadOngoing) {
                self.downloadStatusLabel.text = @"正在下载";
                //buttonTitle = @"暂停";
                buttonTitle = @"停止下载";
            } else if (status == LELessonStatusDownloadPaused) {
                self.downloadStatusLabel.text = @"已暂停";
                buttonTitle = @"继续下载";
            } else if (status == LELessonStatusDownloadError) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下载出错"
                                                                message:@"下载单元音视频文件出错."
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        if (![buttonTitle isEmptyOrWhitespace]) {
            [UIView performWithoutAnimation:^{
                [self.downloadButton setTitle:buttonTitle forState:UIControlStateNormal];
                [self.downloadButton setTitle:buttonTitle forState:UIControlStateHighlighted];
                [self.downloadButton setTitle:buttonTitle forState:UIControlStateSelected];
                [self.downloadButton layoutIfNeeded];
            }];
        }
    } else {
        if (self.studyView.hidden == YES) {
            self.studyView.alpha = 0;
            self.studyView.hidden = NO;
            [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
                self.studyView.alpha = 1.0;
                self.downloadView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.downloadView.hidden = YES;
                self.downloadView.alpha = 1.0;
            }];
        }

        int seconds = studyTime % 60;
        int minutes = (studyTime / 60) % 60;
        int hours = studyTime / 3600;
        int progress = completeCount * 100 / self.courseLesson.mPageCount.intValue;
        int _score = score / self.courseLesson.mPageCount.intValue;

        self.studyDurationLabel.textColor = COLORLABEL;
        self.studyDurationLabel.text = [NSString stringWithFormat:@"累计学习时间: %02d:%02d:%02d",hours, minutes, seconds];
        self.studyPercentageLabel.text = [NSString stringWithFormat:@"<font size=24>%d</font><font size=12>%%</font>", progress];
        self.studyScoreLabel.text = [NSString stringWithFormat:@"<font size=24>%d</font><font size=12>分</font>", _score];
        
        NSString* buttonTitle = @"";
        if (status == LELessonStatusStudyReady) {
            buttonTitle = @"开始学习";
        } else if (status == LELessonStatusStudyOngoing) {
            buttonTitle = @"继续学习";
        }
        
        if (![buttonTitle isEmptyOrWhitespace]) {
            [UIView performWithoutAnimation:^{
                [self.studyButton setTitle:buttonTitle forState:UIControlStateNormal];
                [self.studyButton setTitle:buttonTitle forState:UIControlStateHighlighted];
                [self.studyButton setTitle:buttonTitle forState:UIControlStateSelected];
                [self.downloadButton layoutIfNeeded];
            }];
        }
    }
}

- (void)updatePercentageDisplay {
    self.downloadPercentageLabel.text = [NSString stringWithFormat:@"<font size=24>%d</font><font size=12>%%</font>", self.courseLesson.downloadPercentage];
}

- (void)caluLessonProgress{
    completeCount = 0;
    score = 0;
    studyTime = 0;
    LELessonRecord* lessonRecord = [[LECourseService sharedService] getLessonRecord:self.courseLesson.identifier.intValue lessonId:self.courseLesson.index];
    if (lessonRecord) {
        NSArray* sections = lessonRecord.sections;
        if (sections) {
            [sections enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LESectionRecord* sectionRecord = obj;
                if (sectionRecord) {
                    NSArray* pages = sectionRecord.pages;
                    if (pages) {
                        [pages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            LEPageRecord* pageRecord = obj;
                            if (pageRecord && pageRecord.isCompleted) {
                                completeCount+=1;
                            }
                            if (pageRecord) {
                                score += pageRecord.score;
                                studyTime += pageRecord.duration;
                            }
                        }];
                    }
                }
            }];
        }
    }

}

-(IBAction)clickDownload:(id)sender {
    self.downloadButton.enabled = NO;
    LELessonStatus status = self.courseLesson.downloadStatus;
    if (status == LELessonStatusDownloadReady ||
        status == LELessonStatusDownloadPaused) {
        [[LECourseService sharedService] startDownloadLesson:self.courseLesson];
    } else {
        [[LECourseService sharedService] pauseDownloadLesson:self.courseLesson];
//        [[LECourseService sharedService] stopDownloadLesson:self.courseLesson];
    }
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(sleep3s) userInfo:nil repeats:NO];
}
-(void)sleep3s{
    self.downloadButton.enabled = YES;
}
-(void)continueDownloadCourse{
    NSMutableArray * pauseArray = [NSMutableArray arrayWithArray:UserNameDefault(nil, @"courseLesson.index", @"courseLesson.index")];
    BOOL islesson = NO;
    for (NSNumber *indexnum in pauseArray) {
        if (indexnum.intValue == self.courseLesson.index) {
            islesson = YES;
            break;
        }
    }
    if (islesson) {
        LELessonStatus status = self.courseLesson.downloadStatus;
        if (status == LELessonStatusDownloadPaused) {
            [[LECourseService sharedService] startDownloadLesson:self.courseLesson];
        }
    }
    
}
-(void)pausedDownloadCourse{
    LELessonStatus status = self.courseLesson.downloadStatus;
    NSMutableArray * pauseArray = [NSMutableArray arrayWithArray:UserNameDefault(nil, @"courseLesson.index", @"courseLesson.index")];
    [pauseArray addObject:[NSNumber numberWithInt:self.courseLesson.index]];
    UserNameDefault(pauseArray, @"courseLesson.index", @"courseLesson.index");
    if (status == LELessonStatusDownloadOngoing) {
        [[LECourseService sharedService] pauseDownloadLesson:self.courseLesson];
    }
}

-(IBAction)clickStudy:(id)sender {
    LELessonStatus status = self.courseLesson.downloadStatus;
    if (status == LELessonStatusStudyReady) {
        self.courseLesson.downloadStatus = LELessonStatusStudyOngoing;
    }
    if ([self.delegate respondsToSelector:@selector(courseLessonsViewControllerLessonView:studyLesson:)]){
        [self.delegate courseLessonsViewControllerLessonView:self studyLesson:self.courseLesson];
    }
}

@end
