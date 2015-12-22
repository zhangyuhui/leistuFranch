//
//  LEBaseTableView.m
//  leiapp
//
//  Created by Yuhui Zhang on 9/2/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseTableView.h"
#import "UIScrollView+EmptyDataSet.h"

@interface LEBaseTableView () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
- (void)commonInit;
@end

@implementation LEBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (_tableViewIndex ==1) {
        return [UIImage imageNamed:@"img_tip2"];
    }else if(_tableViewIndex >1)
        return [UIImage imageNamed:@"img_tip1"];
    return [UIImage imageNamed:@"table_view_no_result"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无数据加载";
    if (_tableViewIndex == 1 ) {
        text = @"还没有课程，点击右上角的图标可取激活课程";
    }else if(_tableViewIndex == 2)
    {
        text = @"还没有开始学习课程，别落在别的同学后边哦";
    }else if(_tableViewIndex == 3){
        text = @"还没有已过期课程，抓住有限时间学习吧";
    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
