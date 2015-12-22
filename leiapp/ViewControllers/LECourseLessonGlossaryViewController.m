//
//  LECourseLessonGlossaryViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/18/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonGlossaryViewController.h"
#import "LECourseLessonGlossaryDetailViewController.h"
#import "LECourseGlossary.h"
#import "NSString+Addition.h"

#define kPageTitle                      @"生词卡"
#define kSearchPlaceholder              @"搜索"

@interface LECourseLessonGlossaryViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar* searchBar;
@property (strong, nonatomic) IBOutlet UITableView* tableView;

@property (strong, nonatomic) LECourse* course;
@property (strong, nonatomic) NSArray* groupedGlossaries;
@property (strong, nonatomic) NSArray* sortedGlossaries;
@property (strong, nonatomic) NSString* filter;

- (void)setupGlossaries;
@end

@implementation LECourseLessonGlossaryViewController

- (instancetype)initWithCourse:(LECourse*)course {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.course = course;
        [self setupGlossaries];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = kPageTitle;
    self.searchBar.placeholder = kSearchPlaceholder;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupGlossaries {
    NSArray* filtered = [NSString stringIsNilOrEmpty:self.filter] ? self.course.detail.glossaries : [self.course.detail.glossaries filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name contains[c] %@", self.filter]];
    NSArray* sorted = [filtered sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString *)((LECourseGlossary*)obj1).name compare:(NSString *)((LECourseGlossary*)obj2).name options:NSCaseInsensitiveSearch];
    }];
    
    if ([sorted count] > 0) {
        __block NSMutableArray *grouped = [NSMutableArray new];
        __block NSMutableArray *current = [NSMutableArray new];
        [grouped addObject:current];
        [sorted enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([current count] == 0) {
                [current addObject:obj];
            } else {
                LECourseGlossary* object = obj;
                LECourseGlossary* first = [current firstObject];
                if ([[first.name substringToIndex:1] caseInsensitiveCompare:[object.name substringToIndex:1]] == NSOrderedSame) {
                    [current addObject:object];
                } else {
                    current = [NSMutableArray new];
                    [grouped addObject:current];
                    [current addObject:object];
                }
            }
        }];
        self.sortedGlossaries = sorted;
        self.groupedGlossaries = grouped;
    } else {
        self.groupedGlossaries = nil;
        self.sortedGlossaries = nil;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupedGlossaries ? [self.groupedGlossaries count] : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.groupedGlossaries objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray* grouped = [self.groupedGlossaries objectAtIndex:section];
    LECourseGlossary* glossary = [grouped firstObject];
    return [[glossary.name substringToIndex:1] uppercaseString];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *grouped = [NSMutableArray new];
    [self.groupedGlossaries enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LECourseGlossary* current = [(NSArray*)obj firstObject];
        [grouped addObject:[current.name substringToIndex:1]];
    }];
    return grouped;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LECourseLessonVocabularyTableViewCell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray* grouped = [self.groupedGlossaries objectAtIndex:indexPath.section];
    LECourseGlossary* glossary = [grouped objectAtIndex:indexPath.row];
    cell.textLabel.text = glossary.name;
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    NSArray* glossaries = [self.groupedGlossaries objectAtIndex:indexPath.section];
    LECourseGlossary* glossary = [glossaries objectAtIndex:indexPath.row];
    
    LECourseLessonGlossaryDetailViewController* viewController = [[LECourseLessonGlossaryDetailViewController alloc] initWithGlossaries:self.sortedGlossaries index:[self.sortedGlossaries indexOfObject:glossary]];
    [self.navigationController pushViewController:viewController animated:YES];
    
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.filter = searchText;
    [self setupGlossaries];
    [self.tableView reloadData];
}

@end
