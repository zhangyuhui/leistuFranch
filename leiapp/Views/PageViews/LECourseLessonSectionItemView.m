//
//  LECourseLessonSectionItemView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/25/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemView.h"
#import "LEPreferenceService.h"
#import "LEDefines.h"

#define kAudioPath @"audio_record"
#define kVideoPath @"video_record"

@interface LECourseLessonSectionItemView ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *customConstraints;
@end

@implementation LECourseLessonSectionItemView
- (instancetype)initWithItem:(LECourseLessonSectionItem*)item {
    self = [super init];
    if (self != nil){
        _item = item;
        _selected = NO;
        [self willSetupSubViews];
        NSString *className = NSStringFromClass([self class]);
        if([[NSBundle mainBundle] pathForResource:className ofType:@"nib"] != nil) {
            [self setupFromXib];
        } else {
            [self setupSubViews];
        }
        [self didSetupSubViews];
    }
    return self;
}

- (CGFloat)heightForItem {
    NSString *reason = [NSString stringWithFormat:@"Should implment the method heightForItem for class %@", [self class]];
    NSException *exception = [NSException exceptionWithName:@"Missing method implementation" reason:reason userInfo:nil];
    [exception raise];
    return 0.0;
}

- (CGFloat)widthForItem {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.width;
}

- (CGFloat)paddingForItem {
    return [[LEPreferenceService sharedService] paddingSize];
}

- (CGFloat)spacingForItem {
    return [[LEPreferenceService sharedService] spacingSize];
}

- (UIFont*)fontForItem {
    return [UIFont systemFontOfSize:[[LEPreferenceService sharedService] fontSize]];
}

- (UIColor*)colorForItem:(LECourseLessonSectionItemViewColorType)type {
    switch (type) {
        case LECourseLessonSectionItemViewColorTypeDivider:
            return UIColorFromRGB(0xe7e7e7);
            break;
    }
    return UIColorFromRGB(0xe7e7e7);
}

+ (NSString*) generateTimestamp {
    NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]);
    long digits = (long)time;
    int decimalDigits = (int)(fmod(time, 1) * 1000);
    return [NSString stringWithFormat:@"%ld%d",digits ,decimalDigits];
}

+ (NSString*)pathForAsset:(NSString*)asset {
    NSRange range = [asset rangeOfString:@"Documents"];
    if (range.location != NSNotFound){
        range.location = range.location + range.length;
        range.length = [asset length] - range.location;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        return [[paths objectAtIndex:0] stringByAppendingPathComponent:[asset substringWithRange:range]];
    }
    return asset;
}

+ (BOOL)existAssetPath:(NSString*)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}
+ (NSString*)audioPath {
    NSString *path = [[LEBaseService rootDataPath] stringByAppendingPathComponent:kAudioPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError* error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
    }
//    path = [path stringByAppendingPathComponent:[self generateTimestamp]];
    return path;
}
+ (NSString*)generateAudioPath {
    NSString *path = [[LEBaseService rootDataPath] stringByAppendingPathComponent:kAudioPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError* error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
    }
    path = [path stringByAppendingPathComponent:[self generateTimestamp]];
    return path;
}

+ (NSString*)generateVideoPath {
    NSString *path = [[LEBaseService rootDataPath] stringByAppendingPathComponent:kVideoPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError* error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
    }
    path = [path stringByAppendingPathComponent:[self generateTimestamp]];
    return path;
}

+ (void)destroyAssetPath:(NSString*)path {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError* error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
}

- (void)setupSubViews {
    
}

- (void)willSetupSubViews {
    
}

- (void)didSetupSubViews {
    
}

- (void)destroySubViews {
    
}

- (void)willDestroySubViews {
    
}

- (void)didDestroySubViews {
    
}

- (void)removeFromSuperview {
    [self willDestroySubViews];
    [self destroySubViews];
    [self didDestroySubViews];
    [super removeFromSuperview];
}

- (void)setupFromXib {
    self.backgroundColor = [UIColor clearColor];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _customConstraints = [[NSMutableArray alloc] init];
    
    UIView *view = nil;
    NSString *className = NSStringFromClass([self class]);
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:className
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
        
        
        CGFloat itemPadding = [self paddingForItem];
        CGFloat itemWidth = [self widthForItem] - itemPadding*2.0;
        CGFloat itemHeight = [self heightForItem];
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeWidth
                                                                          multiplier:0.0
                                                                            constant:itemWidth];
        
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeHeight
                                                                           multiplier:0.0
                                                                             constant:itemHeight];
        
        
        [view addConstraint:widthConstraint];
        [view addConstraint:heightConstraint];
        
        [self addSubview:view];
        [self setNeedsUpdateConstraints];
    }
}

- (void)updateConstraints {
    [self removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];
    
    if (self.containerView != nil) {
        CGFloat itemPadding = [self paddingForItem];
        
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.containerView
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeLeading
                                                                            multiplier:1.0
                                                                              constant:itemPadding];
        [self.customConstraints addObject:leadingConstraint];
        
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.containerView
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeTop
                                                                        multiplier:1.0
                                                                          constant:0];
        [self.customConstraints addObject:topConstraint];
        
        [self addConstraints:self.customConstraints];
    }
    
    [super updateConstraints];
}
@end
