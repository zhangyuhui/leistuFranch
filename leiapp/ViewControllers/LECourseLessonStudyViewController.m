//
//  LECourseLessonStudyViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/24/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonStudyViewController.h"
#import "LECourseLessonStudyViewControllerPageView.h"
#import "LECourseLessonTranscriptViewController.h"
#import "LECourseLessonPracticeAnswerViewController.h"
#import "LECourseLessonLEIPracticeItem.h"
#import "LEBaseProxyView.h"
#import "LEConstants.h"
#import "LECourseLessonSectionItem.h"
#import "LECourseLessonRolePlayViewController.h"
#import "LECourseService.h"
#import "LECourseStudyRecord.h"
#import "LEDefines.h"
#import "LESycnStudyRecord.h"
#import "SBJsonWriter.h"
#import "LEPraciceCheckerView.h"
#import "AFNetworkReachabilityManager.h"

#define kPageTitle                      @"课程详情"
#define kDragPageMin                    80
#define kPageTimer                      8

#define kBookmarkImage                  @"courselessonstudy_viewcontroller_bookmark_normal"
#define kBookmarkSelectedImage          @"courselessonstudy_viewcontroller_bookmark_selected"

@interface LECourseLessonStudyViewController ()
{
    BOOL isSpeechEnd;
}
@property (nonatomic, strong) IBOutlet LECourseLessonStudyViewControllerPageView* pageView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *pageViewBottomConstraint;
@property (nonatomic, strong)  UIView  * toolBarView;
@property (nonatomic, strong)  UIButton* prevButton;
@property (nonatomic, strong)  UIButton* nextButton;
@property (nonatomic, strong)  UILabel * progressLabel;
@property (nonatomic, strong)  UILabel * scoreLabel;

-(IBAction)clickPrevButton:(id)sender;
-(IBAction)clickNextButton:(id)sender;

@property (nonatomic, strong) UIButton *bookmarkButton;

@property (nonatomic, strong) LECourse* course;
@property (nonatomic, assign) NSUInteger lessonIndex;
@property (nonatomic, assign) NSUInteger sectionIndex;

@property (nonatomic, strong) UIImageView* snapShotView;

@property (nonatomic, assign) CGFloat dragStartX;

@property (nonatomic, strong) NSTimer* sectionTimer;
@property (nonatomic, strong) NSDate* sectionStartTime;
@property (nonatomic, strong) LEPageRecord* pageRecord;
//@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL forward;
@end
static BOOL first = YES;

@implementation LECourseLessonStudyViewController
@synthesize delegate;

- (void)viewDidLoad {
    self.canBack = YES;
    [super viewDidLoad];
    [self loadToolBar];
    first = YES;
    isSpeechEnd = YES;

    Scoreline((int)self.course.scoreLine);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginIsSpench:) name:@"onBeginOfSpeech" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endIsSpench:) name:@"onEndOfSpeech" object:nil];
    UIButton *bookmarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bookmarkButton addTarget:self action:@selector(clickBookmarkButton) forControlEvents:UIControlEventTouchUpInside];
    [bookmarkButton setImage:[UIImage imageNamed:kBookmarkImage] forState:UIControlStateNormal];
    [bookmarkButton setImage:[UIImage imageNamed:kBookmarkSelectedImage] forState:UIControlStateSelected];
    
    [self setRightBarButtonItems:[NSArray arrayWithObjects: bookmarkButton, nil]];
    
    self.bookmarkButton = bookmarkButton;
    
    [self setupSectionPage:self.sectionIndex];

    [self updateSectionToolbar];
    first = NO;
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(showCourseTranscript:) name:kLENotificationCourseStudyShowTranscript object:nil];
    [notification addObserver:self selector:@selector(showCoursePracticeAnswer:) name:kLENotificationCourseStudyShowPracticeAnswer object:nil];
    [notification addObserver:self selector:@selector(showCourseProxyView:) name:kLENotificationCourseStudyShowProxyView object:nil];
    [notification addObserver:self selector:@selector(showCourseRolePlayView:) name:kLENotificationCourseStudyShowRolePlayView object:nil];
    [notification addObserver:self selector:@selector(moveUpPageView:) name:UIKeyboardWillShowNotification object:nil];
    [notification addObserver:self selector:@selector(moveDownPageView:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.canBack = YES;
}
- (void)loadToolBar{
    self.toolBarView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-45, ScreenWidth, 45)];
    self.nextButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 45, 0, 45, 45)];
    [self.nextButton addTarget:self action:@selector(clickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"courselessonstudy_viewcontroller_pagedown_normal"] forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"courselessonstudy_viewcontroller_pagedown_highlight"] forState:UIControlStateHighlighted];
    self.prevButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
    [self.prevButton addTarget:self action:@selector(clickPrevButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.prevButton setBackgroundImage:[UIImage imageNamed:@"courselessonstudy_viewcontroller_pageup_normal"] forState:UIControlStateNormal];
    [self.prevButton setBackgroundImage:[UIImage imageNamed:@"courselessonstudy_viewcontroller_pageup_highlight"] forState:UIControlStateHighlighted];
    self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2+10, 0, (ScreenWidth-110)/2, 45)];
    self.scoreLabel.textColor = COLORMAIN;
    self.scoreLabel.font = [UIFont systemFontOfSize:14];
    self.progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, (ScreenWidth-110)/2, 45)];
    self.progressLabel.textColor = COLORMAIN;
    self.progressLabel.textAlignment = NSTextAlignmentRight;
    self.progressLabel.font = [UIFont systemFontOfSize:14];
    UILabel *seperlabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, 10, .5, 25)];
    seperlabel.backgroundColor = COLORLINE;
    self.toolBarView.layer.borderColor = COLORLINE.CGColor;
    self.toolBarView.backgroundColor = COLORBACKGROUD;
    [self.toolBarView addSubview:self.prevButton];
    [self.toolBarView addSubview:self.progressLabel];
    [self.toolBarView addSubview:self.scoreLabel];
    [self.toolBarView addSubview:self.nextButton];
    [self.toolBarView addSubview:seperlabel];
    [self.view addSubview:self.toolBarView];
}
- (void)dealloc {
    int _time = 0;
    if (self.sectionStartTime) {
        NSTimeInterval timeInterval = -[self.sectionStartTime timeIntervalSinceNow];
        _pageRecord.duration += timeInterval;
        _time = timeInterval;
        LECourseLessonSection* section = [[self pageView] section];
        if (!section.hasPractice && _pageRecord.duration > 7) {
            _pageRecord.isCompleted = YES;
            _pageRecord.score = 100;
        }
    }
    [[LECourseService sharedService] persistentRecords];
    [self stopSectionTimer];
    if (_pageRecord) {
        [_pageRecord removeObserver:self forKeyPath:@"score"];
    }
    
    [self updateSycnStudyRecord:_time];
    
    if ([delegate respondsToSelector:@selector(refreshPage)]) {
        [delegate refreshPage];
    }
    
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification removeObserver:self name:kLENotificationCourseStudyShowTranscript object:nil];
    [notification removeObserver:self name:kLENotificationCourseStudyShowPracticeAnswer object:nil];
    [notification removeObserver:self name:kLENotificationCourseStudyShowProxyView object:nil];
    [notification removeObserver:self name:kLENotificationCourseStudyShowRolePlayView object:nil];
    [notification removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [notification removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)initWithCourse:(LECourse*)course lesson:(NSUInteger)lesson{
    self = [super initWithNibName:nil bundle:nil];
    if (self){
        self.course = course;
        self.lessonIndex = lesson;
        
        LECourseLesson* lessonObject = [course.detail.lessons objectAtIndex:lesson];
        self.sectionIndex = lessonObject.historySection;
    }
    return self;
}

-(void)back{
    if (isSpeechEnd) {
        [super back];
    }
}

- (instancetype)initWithCourse:(LECourse*)course lesson:(NSUInteger)lesson section:(NSUInteger)section {
    self = [super initWithNibName:nil bundle:nil];
    if (self){
        self.course = course;
        self.lessonIndex = lesson;
        self.sectionIndex = section;
    }
    return self;
}

- (void)clickBookmarkButton {
    LECourseLesson* lesson = [self.course.detail.lessons objectAtIndex:self.lessonIndex];
    LECourseLessonSection* section = [lesson.sections objectAtIndex:self.sectionIndex];
    NSMutableArray* bookmarks = [NSMutableArray arrayWithArray:self.course.detail.bookmarks];
    if (self.bookmarkButton.selected) {
        self.bookmarkButton.selected = NO;
        [self.bookmarkButton setImage:[UIImage imageNamed:kBookmarkImage] forState:UIControlStateNormal];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(lessonId == %d) AND (sectionId == %d)", lesson.index, section.index];
        [bookmarks removeObjectsInArray:[bookmarks filteredArrayUsingPredicate:predicate]];
    } else {
        self.bookmarkButton.selected = YES;
        [self.bookmarkButton setImage:[UIImage imageNamed:kBookmarkSelectedImage] forState:UIControlStateNormal];
        LECourseBookmark* bookmark = [[LECourseBookmark alloc] init];
        bookmark.lessonId = lesson.index;
        bookmark.sectionId = section.index;
        bookmark.pageId = 0;
        bookmark.title = section.title;
        bookmark.date = [NSDate date];
        [bookmarks addObject:bookmark];
        [MBProgressHUD showSuccess:@"添加成功" toView:self.view];
        
    }
    self.course.detail.bookmarks = [NSArray<LECourseBookmark> arrayWithArray:bookmarks];
}

- (void)startSectionTimer {
    [self stopSectionTimer];
    if (!self.pageView.section.complete && ![self isPracticeSection:self.pageView.section] && ![self isResponseSection:self.pageView.section]) {
        self.sectionTimer = [NSTimer scheduledTimerWithTimeInterval:kPageTimer target:self selector:@selector(markSectionStudyComplete:) userInfo:nil repeats:NO];
    }
}

- (void)stopSectionTimer {
    if (self.sectionTimer) {
        [self.sectionTimer invalidate];
        self.sectionTimer = nil;
    }
}

- (void)setupSectionPage:(NSUInteger)pageIndex {
    LECourseLesson* lesson = [self.course.detail.lessons objectAtIndex:self.lessonIndex];
    LECourseLessonSection* section = [lesson.sections objectAtIndex:pageIndex];
    self.navigationItem.title = section.title;
    if (!first && _pageRecord) {
        [_pageRecord removeObserver:self forKeyPath:@"score"];
    }
    [self pageRecord:pageIndex];
    //    int _time = 0;
    //    if (self.sectionStartTime) {
    //        NSTimeInterval timeInterval = -[self.sectionStartTime timeIntervalSinceNow];
    //        self.pageRecord.duration += timeInterval;
    //        _time = timeInterval;
    //        LECourseLessonSection* section = [[self pageView] section];
    //        if (!section.hasPractice && self.pageRecord.duration > 7) {
    //            self.pageRecord.isCompleted = YES;
    //        }
    //    }
    //
    //    [self updateSycnStudyRecord:_time];
    
    //    self.pageView.section = section;
    [self.pageView setSection:section pagerecord:_pageRecord];
    
    [_pageRecord addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:nil];
    
    //    [self.pageView.section addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:nil];
    
    NSArray* bookmarks = self.course.detail.bookmarks;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(lessonId == %d) AND (sectionId == %d)", lesson.index, section.index];
    NSArray *filteredBookmarks = [bookmarks filteredArrayUsingPredicate:predicate];
    if ([filteredBookmarks count] > 0) {
        self.bookmarkButton.selected = YES;
        [self.bookmarkButton setImage:[UIImage imageNamed:kBookmarkSelectedImage] forState:UIControlStateNormal];
        [self.bookmarkButton setImage:[UIImage imageNamed:kBookmarkSelectedImage] forState:UIControlStateSelected];
    } else {
        self.bookmarkButton.selected = NO;
        [self.bookmarkButton setImage:[UIImage imageNamed:kBookmarkImage] forState:UIControlStateNormal];
        [self.bookmarkButton setImage:[UIImage imageNamed:kBookmarkSelectedImage] forState:UIControlStateSelected];
    }
    
    if (first) {
        self.sectionStartTime = [NSDate date];
    }
    //
    //    [self startSectionTimer];
}

- (BOOL)isPracticeSection:(LECourseLessonSection*)section {
    return section.hasPractice;
}

- (LELessonRecord*)getLessonRecord {
    NSArray* studyRecords = [LECourseService sharedService].records;
    NSPredicate *studyRecordsPredicate = [NSPredicate predicateWithFormat:@"courseId == %d", self.course.identifier];
    NSArray *studyRecordsFiltered = [studyRecords filteredArrayUsingPredicate:studyRecordsPredicate];
    LECourseStudyRecord* studyRecord;
    if ([studyRecordsFiltered count] > 0) {
        studyRecord = [studyRecordsFiltered objectAtIndex:0];
    } else {
        studyRecord = [[LECourseStudyRecord alloc] init];
        studyRecord.courseId = self.course.identifier;
        studyRecord.lessons = [NSMutableArray<LELessonRecord> array];
        NSMutableArray* updatedStudyRecords = [NSMutableArray arrayWithArray:studyRecords];
        [updatedStudyRecords addObject:studyRecord];
        [LECourseService sharedService].records = updatedStudyRecords;
    }
    NSArray* lessonRecords = studyRecord.lessons;
    LELessonRecord* lessonRecord;
    NSPredicate *lessonRecordsPredicate = [NSPredicate predicateWithFormat:@"lessonId == %d", self.lessonIndex];
    NSArray *lessonRecordsFiltered = [lessonRecords filteredArrayUsingPredicate:lessonRecordsPredicate];
    if ([lessonRecordsFiltered count] > 0) {
        lessonRecord = [lessonRecordsFiltered objectAtIndex:0];
    } else {
        lessonRecord = [[LELessonRecord alloc] init];
        lessonRecord.lessonId = (int)self.lessonIndex;
        lessonRecord.sections = [NSMutableArray<LESectionRecord> array];
        
        NSMutableArray<LELessonRecord>* updatedLessonRecords = [NSMutableArray<LELessonRecord> arrayWithArray:lessonRecords];
        [updatedLessonRecords addObject:lessonRecord];
        studyRecord.lessons = updatedLessonRecords;
    }
    return lessonRecord;
}

- (LESectionRecord*)getSectionRecord: (NSUInteger)sectionId {
    LELessonRecord* lessonRecord = [self getLessonRecord];
    NSArray* sectionRecords = lessonRecord.sections;
    LESectionRecord* sectionRecord;
    NSPredicate *sectionRecordsPredicate = [NSPredicate predicateWithFormat:@"sectionId == %d", self.lessonIndex];
    NSArray *sectionRecordsFiltered = [sectionRecords filteredArrayUsingPredicate:sectionRecordsPredicate];
    if ([sectionRecordsFiltered count] > 0) {
        sectionRecord = [sectionRecordsFiltered objectAtIndex:0];
    } else {
        sectionRecord = [[LESectionRecord alloc] init];
        sectionRecord.sectionId = (int)self.lessonIndex;
        NSMutableArray<LESectionRecord>* updatedSectionRecords = [NSMutableArray<LESectionRecord> arrayWithArray:sectionRecords];
        [updatedSectionRecords addObject:sectionRecord];
        lessonRecord.sections = updatedSectionRecords;
    }
    return sectionRecord;
}
//获取页面学习记录对象
-(LEPageRecord*) pageRecord:(NSUInteger) pageIndex{
    //section是抽象的一层，现在用的lesson的下标
    LESectionRecord* sectionRecrd = [self getSectionRecord:self.lessonIndex];
    NSArray* pageRecords = sectionRecrd.pages;
    NSPredicate *pageRecordsPredicate = [NSPredicate predicateWithFormat:@"pageId == %d", pageIndex];
    NSArray *pageRecordsFiltered = [pageRecords filteredArrayUsingPredicate:pageRecordsPredicate];
    if ([pageRecordsFiltered count] > 0) {
        _pageRecord = [pageRecordsFiltered objectAtIndex:0];
    } else {
        _pageRecord = [[LEPageRecord alloc] init];
        _pageRecord.pageId = (int)pageIndex;
        NSMutableArray<LEPageRecord>* updatedPageRecords = [NSMutableArray<LEPageRecord> arrayWithArray:pageRecords];
        [updatedPageRecords addObject:_pageRecord];
        sectionRecrd.pages = updatedPageRecords;
    }
    //    NSLog(@"创建学习记录pageId：%d",pageIndex);
    return _pageRecord;
}
//判断是不是一个录音练习页面
- (BOOL)isResponseSection:(LECourseLessonSection*)section {
    __block BOOL found = false;
    [section.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        LECourseLessonSectionItem* item = obj;
        if (item.type == LECourseLessonSectionItemTypeLEIAudioResponse) {
            found = YES;
            *stop = YES;
        }
    }];
    return found;
}
- (void) countRecord:(NSUInteger) pageIndex{
    [self pageRecord:pageIndex];
    int _time = 0;
    if (self.sectionStartTime) {
        NSTimeInterval timeInterval = -[self.sectionStartTime timeIntervalSinceNow];
        self.pageRecord.duration += timeInterval;
        _time = timeInterval;
        LECourseLessonSection* section = [[self pageView] section];
        if (!section.hasPractice && self.pageRecord.duration > 7) {
            self.pageRecord.isCompleted = YES;
            self.pageRecord.score = 100;
        }
    }
    [[LECourseService sharedService] persistentRecords];
    [self updateSycnStudyRecord:_time];
    
    self.sectionStartTime = [NSDate date];
    
    //    [self startSectionTimer];
}
- (void)updateSectionPageView:(BOOL)forward {
    if (isSpeechEnd == NO) {
        return;
    }
    //    [self.prevButton setTintColor:COLORTITEL];
    //    [self.nextButton setTintColor:COLORTITEL];
    CGFloat viewWidth = self.pageView.frame.size.width;
    CGFloat viewHeight = self.pageView.frame.size.height;
    self.snapShotView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, viewWidth, viewHeight)];
    
    UIGraphicsBeginImageContext(CGSizeMake(viewWidth, viewHeight));
    CGContextScaleCTM( UIGraphicsGetCurrentContext(), 1.0f, 1.0f );
    [self.pageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.snapShotView setImage:viewImage];
    [self.view addSubview:self.snapShotView];
    
    //先累加计算当前页面的学习时间
    //    [self setupSectionPage:self.sectionIndex];
    [self countRecord:self.sectionIndex];
    
    self.sectionIndex += forward ? 1 : -1;
    
    //刷新新页面
    [self setupSectionPage:self.sectionIndex];
    
    //获取翻页后的当前页学习记录
    [self pageRecord:self.sectionIndex];
    
    //更新toolbar的成绩
    [self updateSectionToolbar];
    
    self.pageView.transform = CGAffineTransformMakeTranslation(forward ? viewWidth: -viewWidth, 0);
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect viewFrame = self.snapShotView.frame;
                         viewFrame.origin.x = forward ? -viewWidth: viewWidth;
                         self.snapShotView.frame = viewFrame;
                         self.pageView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         self.snapShotView.hidden = YES;
                         [self.snapShotView removeFromSuperview];
                         self.snapShotView = nil;
                     }];
}

- (void)updateSectionToolbar {
    
    LECourseLesson* lesson = [self.course.detail.lessons objectAtIndex:self.lessonIndex];
    LECourseLessonSection* section = [lesson.sections objectAtIndex:self.sectionIndex];
    
    self.nextButton.enabled = (self.sectionIndex < [lesson.sections count] - 1);
    self.prevButton.enabled = self.sectionIndex > 0;
    
    self.progressLabel.text = [NSString stringWithFormat:@"%2d/%2d", (int)(self.sectionIndex + 1), (int)[lesson.sections count]];
    
    if ([self isPracticeSection:section] || [self isResponseSection:section]) {
        [self pageRecord:self.sectionIndex];
        self.scoreLabel.text = [NSString stringWithFormat:@"%d分", (int)self.pageRecord.score];
    } else if (self.pageRecord.isCompleted){
        self.scoreLabel.text = @"已完成";
    } else {
        self.scoreLabel.text = @"--";
    }
}
- (void)updateSycnStudyRecord:(int)time
{
    if (time <= 0) {
        return;
    }
    //添加新的学习记录到数据库
    LESycnStudyRecord *record = [[LESycnStudyRecord alloc] init];
    record.courseID = self.course.identifier;
    LECourseLesson *lesson = [self.course.detail.lessons objectAtIndex:self.lessonIndex];
    record.lessonID = lesson.index;
    record.sectionID = lesson.index;
    record.pageID = [[self pageView] section].index;
    record.studytime = time;
    record.complete = _pageRecord.isCompleted;
    record.score = _pageRecord.score;
    if (_pageRecord.record) {
        //录音记录不是一个字典，转json失败
        record.record = _pageRecord.record;
    }
    //录音练习记录
    //    record.records = pageRecord.record.toJsonArrayString
    NSLog(@"%@", record);
    [record save];
    
    //    NSArray* recordArray = [NSArray arrayWithObject:record];
    [[LECourseService sharedService] uploadSycnStudyRecords:record success:^(LECourseService *service) {
        NSLog(@"单元学习记录上传成功");
        //        [record deleteObject];
    } failure:^(LECourseService *service, NSString *error) {
        NSLog(@"单元学习记录上传失败");
    }];
}
- (void)markSectionStudyComplete:(NSTimer *)timer {
    self.sectionTimer = nil;
    [self pageRecord:self.sectionIndex];
    self.pageRecord.isCompleted = YES;
    LECourseLessonSection* section = [[self pageView] section];
    if (!section.hasPractice) {
        self.pageRecord.score = 100;
    }
    [self updateSectionToolbar];
}

#pragma mark - Actions
-(IBAction)clickPrevButton:(id)sender {
    [self checkRecordPageCompleteAndGoNext:NO];
}
//检查录音页面是否完成
- (void) checkRecordPageCompleteAndGoNext:(BOOL) next{
    __block BOOL returnValue = true;
    _forward = next;
    __block int _type = -1;
    LECourseLessonSection* section = [[self pageView] section];

    if (self.pageRecord && self.pageRecord.record) {
        [self.pageRecord.record enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LEPageAudioRecord* audioRecord = obj;
            if (audioRecord.recordedCount < section.recordCount) {
                _type = 1;
                returnValue = false;
                return ;
            }else if(_type != 1 && audioRecord.score < _course.scoreLine){
                returnValue = false;
                _type = 2;
            }
        }];
    }
    BOOL networkIsWorking = [AFNetworkReachabilityManager sharedManager].isReachable;
    if (networkIsWorking && _type == 1) {
        LEPraciceCheckerView *alert = [[LEPraciceCheckerView alloc]initWithType:1 Delegate:self];
        [alert show];
    }else if(networkIsWorking && _type == 2){
        LEPraciceCheckerView *alert = [[LEPraciceCheckerView alloc]initWithType:0 Delegate:self];
        [alert show];
    }else{
        self.pageRecord.isCompleted = YES;
        if (next) {
            LECourseLesson* lesson = [self.course.detail.lessons objectAtIndex:self.lessonIndex];
            NSUInteger total = [lesson.sections count];
            if (self.sectionIndex < total - 1) {
                [self updateSectionPageView:YES];
            }
        }else{
            if (self.sectionIndex > 0) {
                [self updateSectionPageView:NO];
            }
        }
    }
}

-(void)alertView:(LEPraciceCheckerView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        if (_forward) {
            LECourseLesson* lesson = [self.course.detail.lessons objectAtIndex:self.lessonIndex];
            NSUInteger total = [lesson.sections count];
            if (self.sectionIndex < total - 1) {
                [self updateSectionPageView:YES];
            }
        }else{
            if (self.sectionIndex > 0) {
                [self updateSectionPageView:NO];
            }
        }
    }
}

-(IBAction)clickNextButton:(id)sender {
    [self checkRecordPageCompleteAndGoNext:YES];
}

-(IBAction)swipeLeftPageView:(id)sender {
    [self clickNextButton:sender];
}

-(IBAction)swipeRightPageView:(id)sender {
    [self clickPrevButton:sender];
}

-(IBAction)handleDragPageView:(id)sender {
    UIPanGestureRecognizer* recognizer = (UIPanGestureRecognizer*)sender;
    
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        self.dragStartX =  [sender locationInView:self.pageView].x;
    } else if ([recognizer state] == UIGestureRecognizerStateEnded) {
        CGFloat dragEndX =  [sender locationInView:self.pageView].x;
        CGFloat dragDistance = dragEndX - self.dragStartX;
        BOOL isDragToLeft = dragEndX > self.dragStartX;
        if (dragDistance < 0) {
            dragDistance = -dragDistance;
        }
        if (dragDistance > kDragPageMin) {
            if (isDragToLeft) {
                [self clickPrevButton:sender];
            } else {
                [self clickNextButton:sender];
            }
        }
    }
}

#pragma mark Observers
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"score"]) {
        [self updateSectionToolbar];
    }
}

#pragma mark Notifications
- (void)showCourseTranscript:(NSNotification *)notfication {
    NSString* transcript = [notfication.userInfo objectForKey:@"transcript"];
    LECourseLessonTranscriptViewController* viewController = [[LECourseLessonTranscriptViewController alloc] initWithTranscript:transcript];
    
    [self presentViewController:viewController animated:YES completion:nil];
}
- (void)showCoursePracticeAnswer:(NSNotification *)notfication {
    LECourseLessonLEIPracticeItem* practice = [notfication.userInfo objectForKey:@"practice"];
    LECourseLesson* lesson = [self.course.detail.lessons objectAtIndex:self.lessonIndex];
    LECourseLessonSection* section = [lesson.sections objectAtIndex:lesson.historySection];
    LECourseLessonPracticeAnswerViewController* viewController = [[LECourseLessonPracticeAnswerViewController alloc] initWithLEIPractice:practice lesson:lesson section:section pageRecord:[self pageRecord:self.sectionIndex]];
    [self presentViewController:viewController animated:YES completion:^{
        _pageRecord.isCompleted = YES;
        BOOL isLECourseLessonLEIPracticeQuestion = NO;
        for (LECourseLessonLEIPracticeQuestion * question in practice.questions) {
            question.selections = nil;
            isLECourseLessonLEIPracticeQuestion = YES;
        }
        if (isLECourseLessonLEIPracticeQuestion) {
            [self setupSectionPage:self.sectionIndex];
        }
        [self updateSectionToolbar];
    }];
}
- (void)showCourseProxyView:(NSNotification *)notfication {
    LEBaseProxyView* proxyView = [notfication.userInfo objectForKey:@"proxyview"];
    [self showProxyView:proxyView];
}
- (void)showCourseRolePlayView:(NSNotification *)notfication {
    if ([self isProxyViewShown]) {
        [self hideProxyView];
    }
    LECourseLessonLEIRolePlayItem* item = [notfication.userInfo objectForKey:@"roleplayitem"];
    LECourseLessonRolePlayViewController* viewController = [[LECourseLessonRolePlayViewController alloc] initWithLEIRolePlayItem:item];
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void)beginIsSpench:(NSNotification*)notify
{
    isSpeechEnd = NO;
}
-(void)endIsSpench:(NSNotification*)notify
{
    isSpeechEnd = YES;
}
-(void)moveUpPageView:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.pageViewBottomConstraint.constant = keyboardSize.height;
}
-(void)moveDownPageView:(NSNotification*)notification {
    self.pageViewBottomConstraint.constant = 44;
}
@end
