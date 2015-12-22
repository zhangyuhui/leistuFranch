//
//  LECourseLessonBookmarkViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/20/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonBookmarkViewController.h"
#import "LECourseLessonBookmarkTableViewCell.h"
#import "LECourseLesson.h"
#import "LECourseLessonSection.h"
#import "NSDate+Addition.h"
#import "LECourseBookmark.h"
#import "LECourseLessonStudyViewController.h"
#define kPageTitle                      @"书签"

@interface LECourseLessonBookmarkViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) LECourse* course;
@property (strong, nonatomic) NSMutableArray* groupedBookmarks;
@property (strong, nonatomic) NSMutableArray* sortedBookmarks;

- (void)setupBookmarks;
@end

@implementation LECourseLessonBookmarkViewController

- (instancetype)initWithCourse:(LECourse*)course {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.course = course;
        [self setupBookmarks];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = kPageTitle;
//    self.
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)setupBookmarks {
//    NSMutableArray<LECourseBookmark>* fakeData = [NSMutableArray new];
//    LECourseBookmark* bookmark1 = [[LECourseBookmark alloc] init];
//    bookmark1.lessonId = 1;
//    bookmark1.sectionId = 1;
//    bookmark1.pageId = 1;
//    bookmark1.date = [NSDate date];
//    bookmark1.title = @"Haha";
//    [fakeData addObject:bookmark1];
//    self.course.detail.bookmarks = fakeData;
    
    NSArray* sorted = [self.course.detail.bookmarks sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [((LECourseBookmark*)obj1).date compare:((LECourseBookmark*)obj2).date];
    }];
    
    if ([sorted count] > 0) {
        __block NSMutableArray *grouped = [NSMutableArray new];
        __block NSMutableArray *current = [NSMutableArray new];
        [grouped addObject:current];
        [sorted enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([current count] == 0) {
                [current addObject:obj];
            } else {
                LECourseBookmark* object = obj;
                LECourseBookmark* first = [current firstObject];
                
                if ([first.date isSameDayAs:object.date]) {
                    [current addObject:object];
                } else {
                    current = [NSMutableArray new];
                    [grouped addObject:current];
                    [current addObject:object];
                }
            }
        }];
        self.sortedBookmarks = [NSMutableArray arrayWithArray:sorted];
        self.groupedBookmarks = grouped;
    } else {
        self.groupedBookmarks = nil;
        self.sortedBookmarks = nil;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return self.groupedBookmarks ? [self.groupedBookmarks count] : 0;
    return self.sortedBookmarks ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [[self.groupedBookmarks objectAtIndex:section] count];
    return [self.sortedBookmarks count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //NSArray* grouped = [self.groupedBookmarks objectAtIndex:section];
    //LECourseBookmark* bookmark = [grouped firstObject];
    
    //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"yyyy-MM-dd"];
    //return [formatter stringFromDate:bookmark.date];
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray* bookmarks = [NSMutableArray arrayWithArray:self.course.detail.bookmarks];
        LECourseBookmark* bookmark = [self.sortedBookmarks objectAtIndex:indexPath.row];
        [bookmarks removeObject:bookmark];
        self.course.detail.bookmarks = [NSArray<LECourseBookmark> arrayWithArray:bookmarks];
        //TODO
        //Delete bookmark
        [self.sortedBookmarks removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setEditing:YES animated:YES];
    static NSString *CellIdentifier = @"LECourseLessonBookmarkTableViewCell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [LECourseLessonBookmarkTableViewCell courseLessonBookmarkTableViewCell];
    }
    //NSArray* grouped = [self.groupedBookmarks objectAtIndex:indexPath.section];
    //LECourseBookmark* bookmark = [grouped objectAtIndex:indexPath.row];
    LECourseBookmark* bookmark = [self.sortedBookmarks objectAtIndex:indexPath.row];
    LECourseLesson* lesson = [self.course.detail.lessons objectAtIndex:bookmark.lessonId];
    LECourseLessonSection* section = [lesson.sections objectAtIndex:bookmark.sectionId];
    
    LECourseLessonBookmarkTableViewCell* cellView = (LECourseLessonBookmarkTableViewCell*)cell;
    cellView.bookmarkTitleLabel.text = [NSString stringWithFormat:@"%@ P%d", section.title, bookmark.sectionId];
    cellView.bookmarkDescriptonLabel.text = section.title;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    cellView.bookmarkDateLabel.text = [dateFormatter stringFromDate:bookmark.date];
    cellView.bookmarkTimeLabel.text = [timeFormatter stringFromDate:bookmark.date];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    LECourseBookmark* bookmark = [self.sortedBookmarks objectAtIndex:indexPath.row];
    LECourseLessonStudyViewController *viewController = [[LECourseLessonStudyViewController alloc]initWithCourse:self.course lesson:bookmark.lessonId section:bookmark.sectionId];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
