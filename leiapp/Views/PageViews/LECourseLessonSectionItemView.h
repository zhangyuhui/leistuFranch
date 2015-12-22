//
//  LECourseLessonSectionItemView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/25/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECourseLessonSectionItem.h"
#import "LECOurse.h"

typedef NS_ENUM(NSInteger, LECourseLessonSectionItemViewColorType) {
    LECourseLessonSectionItemViewColorTypeDivider
};


@class LECourseLessonSectionItemView;

@protocol LECourseLessonSectionItemViewDelegate <NSObject>
@optional
- (void)sectionItemView:(LECourseLessonSectionItemView*)sectionItemView willChangeHeight:(CGFloat)height;
- (void)sectionItemView:(LECourseLessonSectionItemView*)sectionItemView didChangeHeight:(CGFloat)height;
@end


@interface LECourseLessonSectionItemView : UIView

@property (nonatomic, readonly) LECourseLessonSectionItem* item;

- (instancetype)initWithItem:(LECourseLessonSectionItem*)item;

@property (nonatomic, assign) id<LECourseLessonSectionItemViewDelegate> delegate;

@property (nonatomic, assign) BOOL selected;

- (CGFloat)heightForItem;
- (CGFloat)widthForItem;
- (CGFloat)paddingForItem;
- (CGFloat)spacingForItem;
- (UIFont*)fontForItem;
- (UIColor*)colorForItem:(LECourseLessonSectionItemViewColorType)type;

+ (NSString*)pathForAsset:(NSString*)asset;
+ (BOOL)existAssetPath:(NSString*)path;
+ (NSString*)generateVideoPath;
+ (NSString*)generateAudioPath;
+ (void)destroyAssetPath:(NSString*)path;
+ (NSString*)audioPath ;
- (void)setupSubViews;
- (void)willSetupSubViews;
- (void)didSetupSubViews;

- (void)destroySubViews;
- (void)willDestroySubViews;
- (void)didDestroySubViews;
@end