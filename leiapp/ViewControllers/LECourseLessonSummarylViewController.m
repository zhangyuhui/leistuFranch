//
//  LECourseLessonSummarylViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 11/9/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSummarylViewController.h"
#import "LEBaseTableView.h"
#import "LECourseLesson.h"
#import "LECourseLessonSection.h"
#import "LECourseLessonSummarylViewControllerCell.h"
#import "LECourseLessonStudyViewController.h"
#import "LECourseService.h"

@interface LECourseLessonSummarylViewController () <UITableViewDelegate, UITableViewDataSource, LECourseLessonStudyViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet LEBaseTableView *lessonsTableView;

@property (strong, nonatomic) LECourse *course;
@property (strong, nonatomic) LECourseLesson *lesson;
@end
static int completeCount, score, studyTime;

@implementation LECourseLessonSummarylViewController

- (instancetype)initWithCourseAndLesson:(LECourse*)course lesson:(LECourseLesson*)lesson {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.course = course;
        self.lesson = lesson;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"单元活动";
    
    self.titleLabel.text = self.lesson.title;
    
    self.percentageLabel.layer.cornerRadius = 13;
    self.percentageLabel.layer.masksToBounds = YES;
    
    self.durationLabel.layer.cornerRadius = 13;
    self.durationLabel.layer.masksToBounds = YES;
    
    self.scoreLabel.layer.cornerRadius = 13;
    self.scoreLabel.layer.masksToBounds = YES;
    
    [self updateHeaderDisplay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateHeaderDisplay];
    [self.lessonsTableView reloadData];
}
- (void)caluLessonProgress{
    completeCount = 0;
    score = 0;
    studyTime = 0;
    _lessonRecord = [[LECourseService sharedService] getLessonRecord:self.lesson.identifier.intValue lessonId:self.lesson.index];
    if (_lessonRecord) {
        NSArray* sections = _lessonRecord.sections;
        if (sections) {
            [sections enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LESectionRecord* sectionRecord = obj;
                if (sectionRecord) {
                    _pages = sectionRecord.pages;
                    if (_pages) {
                        [_pages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
- (void)updateHeaderDisplay {
    [self caluLessonProgress];
    int seconds = studyTime % 60;
    int minutes = (studyTime / 60) % 60;
    int hours = studyTime / 3600;
    int progress = completeCount * 100 / self.lesson.mPageCount.intValue;
    int _score = score / self.lesson.mPageCount.intValue;
    
    self.percentageLabel.text =  [NSString stringWithFormat:@"%d%%", progress];
    
    self.durationLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d分", _score];
}

- (LEPageRecord*) getPageRecord:(int)index{
    if (_pages) {
        for (LEPageRecord* record in _pages) {
            if (record.pageId == index) {
                return record;
            }
        }
    }
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.lesson.sections count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LECourseLessonSection* section = [self.lesson.sections objectAtIndex:indexPath.row];
    LECourseLessonSummarylViewControllerCell *cell = [LECourseLessonSummarylViewControllerCell courseLessonSummarylViewControllerCell];
    cell.lessonSection = section;
    cell.pageRecord = [self getPageRecord:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
    
    LECourseLessonStudyViewController* viewController = [[LECourseLessonStudyViewController alloc] initWithCourse:self.course lesson:self.lesson.index section:indexPath.row];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) refreshPage{
    [self updateHeaderDisplay];
    [self.lessonsTableView reloadData];}

@end
