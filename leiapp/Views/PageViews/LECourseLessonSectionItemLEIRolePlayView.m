//
//  LECourseLessonSectionItemLEIRolePlayView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/10/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIRolePlayView.h"
#import "LEVideoControlView.h"
#import "LECourseLessonSectionItemLEIRoleTipSelectionView.h"
#import "LEConstants.h"
#import "LEDefines.h"
#import "UIImage+ImageEffects.h"

#define kSelectionViewHeight  320
#define kSelectionViewPadding 20

@interface LECourseLessonSectionItemLEIRolePlayView() <LEVideoControlViewDelegate>
@property (strong, nonatomic) IBOutlet LEVideoControlView* controllView;
@property (strong, nonatomic) IBOutlet UIButton* roleLeftButton;
@property (strong, nonatomic) IBOutlet UILabel* roleLeftLabel;
@property (strong, nonatomic) IBOutlet UIButton* roleRightButton;
@property (strong, nonatomic) IBOutlet UILabel* roleRightLabel;

@property (strong, nonatomic) LECourseLessonSectionItemLEIRoleTipSelectionView* tipSelectionView;

@end

@implementation LECourseLessonSectionItemLEIRolePlayView

- (instancetype)initWithLEIRolePlayItem:(LECourseLessonLEIRolePlayItem*)item {
    self = [super initWithItem:item];
    if (self){
        
    }
    return self;
}

- (void)dealloc {
    if (self.tipSelectionView) {
        [self.tipSelectionView removeObserver:self forKeyPath:@"type"];
        self.tipSelectionView = nil;
    }
}

- (void)didSetupSubViews {
    LECourseLessonLEIRolePlayItem* item = (LECourseLessonLEIRolePlayItem*)self.item;
    self.controllView.delegate = self;
    self.controllView.cover = [LECourseLessonSectionItemView pathForAsset:item.cover];
    self.videoPlayPath = [LECourseLessonSectionItemView pathForAsset:item.video];
    
    self.roleLeftButton.layer.cornerRadius = 30;
    self.roleLeftButton.layer.borderColor = UIColorFromRGB(0xe8c395).CGColor;
    self.roleLeftButton.layer.borderWidth = 2.0;
    self.roleRightButton.layer.cornerRadius = 30;
    self.roleRightButton.layer.borderColor = UIColorFromRGB(0xe8c395).CGColor;
    self.roleRightButton.layer.borderWidth = 2.0;
    
    NSArray* names = item.speakerNames;
    self.roleLeftLabel.text = [names objectAtIndex:0];
    self.roleRightLabel.text = [names objectAtIndex:1];
    
    NSArray* images = item.speakerImages;
    UIImage* leftImage = [UIImage imageWithContentsOfFile:[LECourseLessonSectionItemView pathForAsset:[images objectAtIndex:0]]];
    UIImage* rightImage = [UIImage imageWithContentsOfFile:[LECourseLessonSectionItemView pathForAsset:[images objectAtIndex:1]]];
    
    self.roleLeftButton.layer.masksToBounds = YES;
    self.roleRightButton.layer.masksToBounds = YES;
    
    [self.roleLeftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
    [self.roleRightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
}

- (CGFloat)heightForItem {
    return 320;
}

#pragma mark - Video Player Hooks
-(void)didVideoPlayLoaded:(UIView*)view {
    [self.controllView showVideoView:view];
}

-(void)didVideoPlayStart {
    [self.controllView hidePlayButton];
}

-(void)willVideoPlayUnloaded:(UIView*)view {
    [self.controllView hideVideoView:view];
}

-(void)didVideoPlayStopped {
    [self.controllView showPlayButton];
}

-(void)didVideoPlayPaused {
    [self.controllView showPlayButton];
}

-(void)didVideoPlayResumed {
    [self.controllView hidePlayButton];
}

#pragma mark - LEVideoControlViewDelegate
- (void)controlView:(LEVideoControlView*)controlView didClickPlayButton:(UIButton*)button {
    if ([self isVideoPlaying]) {
        [self pauseVideoPlay];
    } else if ([self isVideoPaused]){
        [self resumeVideoPlay];
    } else {
        [self startVideoPlay];
    }
}

- (void)controlView:(LEVideoControlView*)controlView didTapCanvasView:(UIView*)canvas {
    if ([self isVideoPlaying]) {
        [self pauseVideoPlay];
    }
}

#pragma mark - Actions
- (IBAction)clickRoleButton:(id)sender {
    LECourseLessonLEIRolePlayItem* item = (LECourseLessonLEIRolePlayItem*)self.item;
    item.speaker = (sender == self.roleLeftButton ) ? 0 : 1;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat viewHeight = kSelectionViewHeight;
    CGFloat viewY = (screenRect.size.height - viewHeight)/2.0;
    CGFloat viewX = kSelectionViewPadding;
    CGFloat viewWidth = screenRect.size.width - viewX*2.0;
    
    if (self.tipSelectionView) {
        [self.tipSelectionView removeObserver:self forKeyPath:@"type"];
        self.tipSelectionView = nil;
    }
    
    self.tipSelectionView = [[LECourseLessonSectionItemLEIRoleTipSelectionView alloc] initWithFrame:CGRectMake(viewX, viewY, viewWidth, viewHeight)];
    
    [self.tipSelectionView addObserver:self forKeyPath:@"type" options:NSKeyValueObservingOptionNew context:nil];
    
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.tipSelectionView, @"proxyview", nil];
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification postNotificationName:kLENotificationCourseStudyShowProxyView object:nil userInfo:userInfo];
}

# pragma mark Observers
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"type"]) {
        LERoleTipType type = self.tipSelectionView.type;
        
        [self.tipSelectionView removeObserver:self forKeyPath:@"type"];
        self.tipSelectionView = nil;
        
        LECourseLessonLEIRolePlayItem* item = (LECourseLessonLEIRolePlayItem*)self.item;
        switch (type) {
            case LERoleTipTypeFull:
                item.selection = 0;
                break;
            case LERoleTipTypePartial:
                item.selection = 1;
                break;
            case LERoleTipTypeNone:
                item.selection = 2;
                break;
        }
        NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:item, @"roleplayitem", nil];
        NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
        [notification postNotificationName:kLENotificationCourseStudyShowRolePlayView object:nil userInfo:userInfo];
        [self stopVideoPlay];
    }
}

@end
