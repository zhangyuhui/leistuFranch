//
//  Resources.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LEDefines.h"
@interface Resources : NSObject {
    
    //使用字典对应shortCut和图片
    NSMutableDictionary         *mainmenu_;
    
    //NSMutableArray            *buttommainmenu_;
	//NSMutableArray			*selectedButtommainmenu_;
    
    //存放程序第一次加载的引导图片的字典
    NSMutableDictionary			*userGuideMenu_;
	NSMutableDictionary			*newGuideMenu_;
}


+ (Resources *) sharedResources;

- (UIImage *)loadImagePathForResource:(NSString *)resource ofType:(NSString *)type;

- (void) loadMainMenuResources;

/**
 * Description:    // 加载程序开始时的引导图片
 * Input:          // 
 * Output:         // 
 * Return:         // 
 * Others:         // 
 */
- (void) loadUserGuideMenuResources;

/**
 * Description:    // 根据索引获取引导图片
 * Input:          // num:图片索引
 * Output:         // 
 * Return:         // 
 * Others:         // 
 */
- (UIImage *) getUserGuideMenuImageByNum:(NSString *)num;

/**
 * Description:    // 加载程序开始时的引导图片
 * Input:          // 
 * Output:         // 
 * Return:         // 
 * Others:         // 
 */
- (void) loadNewGuideMenuResources;

/**
 * Description:    // 根据索引获取引导图片
 * Input:          // num:图片索引
 * Output:         // 
 * Return:         // 
 * Others:         // 
 */
- (UIImage *) getNewGuideMenuImageByNum:(NSString *)num;

- (UIImage *) getArrowheadUp;
- (UIImage *) getArrowheadDown;
- (UIImage *) getRadioImage;
- (UIImage *) getRadioSelectedImage;
- (UIImage *) getCheckBoxImage;
- (UIImage *) getCheckBoxSelectedImage;
- (UIImage *) getCheckBoxImage2;
- (UIImage *) getCheckBoxSelectedImage2;
- (UIImage *) getDropDownDImage;
- (UIImage *) getDropDownUImage;
- (UIImage *) getAppLogo;
- (UIImage *) getMapCenterImage;
- (UIImage *) getMapGreenPinImage;
- (UIImage *) getMapRedPinImage;
- (UIImage *) getDownArrowImage;
- (UIImage *) getToolTipBackground;
- (UIImage *) getArrow;

- (UIImage *) getButtonBarLeftOn;
//- (UIImage *) getButtonBarLeftOff;
- (UIImage *) getButtonBarRightOn;
//- (UIImage *) getButtonBarRightOff;

- (UIImage *) getDateTop;
- (UIImage *) getDateTodayBg;
- (UIImage *) getDateSelectedBg;
- (UIImage *) getDateCellBg;

- (UIImage *) getLeftButtonBg;
- (UIImage *) getRightButtonBg;

- (UIImage *) getElevatorLeftButtonBg;
- (UIImage *) getElevatorRightButtonBg;

- (UIImage *) getBackground;
- (UIImage *) getloadingBg;
- (UIImage *) getGetUserCodeBg;

- (UIImage *) getSelectTagBg;

- (UIImage *) getLabelBgImage;

- (NSMutableDictionary *) getMainmenu;

- (UIImage *) getMainMenuImageByShortcut:(NSString *)shortcut;
- (UIImage *) getButtomMainMenuImageByShortcut:(NSString *)shortcut;
- (UIImage *) getButtomMainSelectedMenuImageByShortcut:(NSString *)shortcut;

- (UIImage *)getHomeButtonImage;

- (UIImage *) getBackButtonImage;

//topBar背景
- (UIImage *) getTopBarImage;
- (UIImage *) getTopLogoImage;

- (UIImage *) getChannelBgImage;
- (UIImage *) getChannelSelBgImage;
- (UIImage *) getExitButtonImage;

- (UIImage *) getOptionsConfirmButtonBarImage;
- (UIImage *) getOptionsConfirmButtonImage;
- (UIImage *) getOptionsChannelButtonImage;

- (UIImage *) getLoginBgImage;

- (UIImage *) getRegisterBgImage;

- (UIImage *) getNewUISideBarBg;

- (UIImage *) getLoginDivBackgroundWithName:(NSString*)name;

- (UIImage *) getUpadateBgImage;
- (UIImage *) getUpdateButtonImage;

@end
