//
//  Resources.m
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//

#import "Resources.h"

@implementation Resources


/** singleton instance  **/
static Resources                  *sharedResources = nil;

+ (Resources *) sharedResources {
    
    @synchronized ([Resources class]) {
        if (sharedResources == nil) {
            [[Resources alloc] init];
            return sharedResources;
        }
    }
    
    return sharedResources;
}


+ (id) alloc {
    @synchronized ([Resources class]) {
        sharedResources = [super alloc];
        return sharedResources;
    }
    
    return nil;
}

- (UIImage *)loadImagePathForResource:(NSString *)resource ofType:(NSString *)type
{
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    return [UIImage imageWithContentsOfFile:imagePath];
}

- (void) loadMainMenuResources 
{
    //使用shortCut键值对应图片
    NSAutoreleasePool *loadMainMenuImgPool = [[NSAutoreleasePool alloc]init];
    if (mainmenu_ == nil) 
    {
        mainmenu_ = [[NSMutableDictionary alloc] init];
        
        NSArray *array = [NSArray array];
        for (int i = 0; i < [array count]; i++)
        {
            UIImage *image = [self loadImagePathForResource:[array objectAtIndex:i] ofType:@"png"];
            if (image)
            {
                [mainmenu_ setObject:image forKey:[array objectAtIndex:i]];
            }
            else
            {
                image = [self loadImagePathForResource:[array objectAtIndex:0] ofType:@"png"];
                [mainmenu_ setObject:image forKey:[array objectAtIndex:i]];
            }
        }
    }
    
    [loadMainMenuImgPool release];
}


- (UIImage *) getMainMenuImageByShortcut:(NSString *)shortcut
{
    //直接根据shotrCut从字典中取出图片
	shortcut = [shortcut stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if([mainmenu_ objectForKey:shortcut])
    {
        return [mainmenu_ objectForKey:shortcut];
    }
    else
    {
        return [mainmenu_ objectForKey:@"noDefine"];
    }
}

/**
 * Description:    // 加载程序开始时的引导图片
 * Input:          // 
 * Output:         // 
 * Return:         // 
 * Others:         // 
 */
- (void) loadUserGuideMenuResources 
{
	if (userGuideMenu_ == nil) 
    {
		userGuideMenu_ = [[NSMutableDictionary alloc] init];
		
		for (int i = 0; i < 3; i++)
        {
			UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"userGuidImg_%d.jpg", i]];
            if (image)
            {
                [userGuideMenu_ setObject:image forKey:[NSString stringWithFormat:@"%d", i]];
            }
        }
	}
}

/**
 * Description:    // 根据索引获取引导图片
 * Input:          // num:图片索引
 * Output:         // 
 * Return:         // 
 * Others:         // 
 */
- (UIImage *) getUserGuideMenuImageByNum:(NSString *)num
{
	[self loadUserGuideMenuResources];
    UIImage *image = (UIImage *)[userGuideMenu_ objectForKey:num];
	if (image) 
    {
		return image;
	}
	
	return nil;
}

/**
 * Description:    // 加载程序开始时的引导图片
 * Input:          // 
 * Output:         // 
 * Return:         // 
 * Others:         // 
 */
- (void) loadNewGuideMenuResources 
{
	if (newGuideMenu_ == nil) 
    {
		newGuideMenu_ = [[NSMutableDictionary alloc] init];
		
		for (int i = 0; i < 3; i++)
        {
			UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"newGuidImg_%d.png", i]];
            if (image) 
            {
                [newGuideMenu_ setObject:image forKey:[NSString stringWithFormat:@"%d", i]];
            }
        }
	}
}

/**
 * Description:    // 根据索引获取引导图片
 * Input:          // num:图片索引
 * Output:         // 
 * Return:         // 
 * Others:         // 
 */
- (UIImage *) getNewGuideMenuImageByNum:(NSString *)num 
{
	[self loadNewGuideMenuResources];
    UIImage *image = (UIImage *)[newGuideMenu_ objectForKey:num];
	if (image) 
    {
		return image;
	}
	
	return nil;
}

- (UIImage *) getButtomMainMenuImageByShortcut:(NSString *)shortcut {
	//shortcut = [shortcut stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//    NSArray *array = [MAINMENU_SHORTCUT componentsSeparatedByString:@","];
//    for (int i = 0; i < [array count]; i++) {
//        NSString *sc = (NSString *)[array objectAtIndex:i];
//        if ([sc isEqualToString:shortcut] && i < [buttommainmenu_ count]) {
//            return [buttommainmenu_ objectAtIndex:i];
//        }
//    }
//    
//    return [buttommainmenu_ objectAtIndex:0];
    
    return nil;
    
}


- (UIImage *) getButtomMainSelectedMenuImageByShortcut:(NSString *)shortcut {
	//shortcut = [shortcut stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//    NSArray *array = [MAINMENU_SHORTCUT componentsSeparatedByString:@","];
//    for (int i = 0; i < [array count]; i++) {
//        NSString *sc = (NSString *)[array objectAtIndex:i];
//        if ([sc isEqualToString:shortcut] && i < [selectedButtommainmenu_ count]) {
//            return [selectedButtommainmenu_ objectAtIndex:i];
//        }
//    }
//    
//    return [selectedButtommainmenu_ objectAtIndex:0];
    return nil;
}


- (UIImage *) getArrowheadUp {
    return [self loadImagePathForResource:@"up" ofType:@"png"];
}

- (UIImage *) getArrowheadDown {
    return [self loadImagePathForResource:@"down" ofType:@"png"];
}

- (UIImage *) getButtonBarLeftOn {
    return [self loadImagePathForResource:@"buttomBarLeftOn" ofType:@"png"];
}

- (UIImage *) getButtonBarRightOn {
    return [self loadImagePathForResource:@"buttomBarRightOn" ofType:@"png"];
}

- (UIImage *) getLoginBgImage {
    return [self loadImagePathForResource:@"loginBg" ofType:@"png"];
}

- (UIImage *) getRadioImage {
    return [self loadImagePathForResource:@"radio" ofType:@"png"];
}

- (UIImage *) getRadioSelectedImage {
    return [self loadImagePathForResource:@"radioSelected" ofType:@"png"];
}

- (UIImage *) getCheckBoxImage {
    return [self loadImagePathForResource:@"checkBox" ofType:@"png"];
}

- (UIImage *) getCheckBoxSelectedImage {
    return [self loadImagePathForResource:@"checkBoxSelected" ofType:@"png"];
}

- (UIImage *) getCheckBoxImage2 {
    return [self loadImagePathForResource:@"checkbox_off" ofType:@"png"];
}

- (UIImage *) getCheckBoxSelectedImage2 {
    return [self loadImagePathForResource:@"checkbox_on" ofType:@"png"];
}
- (UIImage *) getDropDownDImage {
    return [self loadImagePathForResource:@"dropDownD" ofType:@"png"];
}

- (UIImage *) getDropDownUImage {
    return [self loadImagePathForResource:@"dropDownU" ofType:@"png"];
}

- (UIImage *) getAppLogo {
    return [self loadImagePathForResource:@"topAppLogo" ofType:@"png"];
}


- (UIImage *) getMapCenterImage {
    return [self loadImagePathForResource:@"mapcenter" ofType:@"png"];
}

- (UIImage *) getMapGreenPinImage {
    return [self loadImagePathForResource:@"map_green_pin" ofType:@"png"];
}

- (UIImage *) getMapRedPinImage {
    return [self loadImagePathForResource:@"map_red_pin" ofType:@"png"];
}


- (UIImage *) getDownArrowImage {
    return [self loadImagePathForResource:@"down_arrow" ofType:@"png"];
}

- (UIImage *) getToolTipBackground {
    return [self loadImagePathForResource:@"tooltip" ofType:@"png"];
}

- (UIImage *) getArrow {
    return [self loadImagePathForResource:@"arrow" ofType:@"png"];
}

- (UIImage *) getDateTop {
    return [self loadImagePathForResource:@"dateTop" ofType:@"png"];
}

- (UIImage *) getDateTodayBg {
    return [self loadImagePathForResource:@"dateTodayBg" ofType:@"png"];
}

- (UIImage *) getDateSelectedBg {
    return [self loadImagePathForResource:@"dateSelectBg" ofType:@"png"];
}

- (UIImage *) getDateCellBg {
    return [self loadImagePathForResource:@"dateCellBg" ofType:@"png"];
}

- (UIImage *) getLeftButtonBg {
    return [self loadImagePathForResource:@"leftButtonBg" ofType:@"png"];
}

- (UIImage *) getRightButtonBg {
    return [self loadImagePathForResource:@"rightButtonBg" ofType:@"png"];
}

- (UIImage *) getElevatorLeftButtonBg {
    return [self loadImagePathForResource:@"elevatorLeftButtonBg" ofType:@"png"];
}

- (UIImage *) getElevatorRightButtonBg {
    return [self loadImagePathForResource:@"elevatorRightButtonBg" ofType:@"png"];
}

- (UIImage *) getLabelBgImage {
    return [self loadImagePathForResource:@"labelBg" ofType:@"png"];
}

- (UIImage *) getBackground
{
//    if(iPhone_5 == [GlobalVariables sharedGlobalVariables].theDeviceType)
//    {
//        
//        return [self loadImagePathForResource:@"backGround-568h" ofType:@"png"];
//    }
//    else
//    {
//        
//        return [self loadImagePathForResource:@"backGround" ofType:@"png"];
//    }

    return [UIImage imageNamed:@"topic_whrite.png"];
}

- (UIImage *) getloadingBg
{
    //return [UIImage imageNamed:@"Default.png"];
    if(SCREEN_HEIGHT>480)
    {

        return [self loadImagePathForResource:@"Default-568h" ofType:@"png"];
    }
    else
    {

        return [self loadImagePathForResource:@"Default" ofType:@"png"];
    }
}

- (UIImage *) getGetUserCodeBg {
    return [self loadImagePathForResource:@"getUserCodeBg" ofType:@"png"];
}

- (UIImage *) getSelectTagBg {
    return [self loadImagePathForResource:@"labelBg" ofType:@"png"];
}

- (NSMutableDictionary *) getMainmenu {
	return mainmenu_;
}

- (UIImage *) getHomeButtonImage {
	return [self loadImagePathForResource:@"homeButton" ofType:@"png"];
}

- (UIImage *) getBackButtonImage {
	return [self loadImagePathForResource:@"backButton" ofType:@"png"];
}

//topBar背景
- (UIImage *) getTopBarImage 
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version>=7.0) { // iOS7
        return [self loadImagePathForResource:@"nav_bar64" ofType:@"png"];
    } else { // 非iOS7
        return [self loadImagePathForResource:@"nav_bar" ofType:@"png"];
    }


}

- (UIImage *) getTopLogoImage 
{
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version>=7.0) { // iOS7
        return [self loadImagePathForResource:@"nav_bar64" ofType:@"png"];
    } else { // 非iOS7
        return [self loadImagePathForResource:@"nav_bar" ofType:@"png"];
    }

}

- (UIImage *) getChannelBgImage {
	return [self loadImagePathForResource:@"channelBg" ofType:@"png"];
}

- (UIImage *) getChannelSelBgImage {
	return [self loadImagePathForResource:@"channelSelBg" ofType:@"png"];
}

- (UIImage *) getExitButtonImage {
	return [self loadImagePathForResource:@"exit" ofType:@"png"];
}

- (UIImage *) getOptionsConfirmButtonBarImage {

	return [[self loadImagePathForResource:@"topicColor" ofType:@"png"] resizeImage];
}

- (UIImage *) getOptionsConfirmButtonImage {
	return [self loadImagePathForResource:@"optionsConfirmButton" ofType:@"png"];
}
- (UIImage *) getOptionsChannelButtonImage {
	return [self loadImagePathForResource:@"optionsChannelButton" ofType:@"png"];
}
- (UIImage *) getRegisterBgImage
{
    
    NSString *imgName = @"registerBg";
    
    if(SCREEN_HEIGHT>480)
    {
        imgName = @"registerBg-568h@2x";
    }
    UIImage *registerImg = [self loadImagePathForResource:imgName ofType:@"png"];
    
	return registerImg;
}

- (UIImage *) getNewUISideBarBg
{
    NSString *imgName = @"newUI_sidebar";

    if(SCREEN_HEIGHT>480)
    {
        imgName = @"newUI_sidebar-568h";
    }
    UIImage *registerImg = [self loadImagePathForResource:imgName ofType:@"png"];

	return registerImg;
}


- (void) dealloc {
    
    [mainmenu_ release];
    //[buttommainmenu_ release];
	//[selectedButtommainmenu_ release];
    
    [super dealloc];
}


//登录页面的灰色背景。
- (UIImage *) getLoginDivBackgroundWithName:(NSString*)name
{
    NSString* t = [name stringByDeletingPathExtension];
    NSString* type = [name pathExtension];
    //return [UIImage imageNamed:@"Default.png"];
    if(SCREEN_HEIGHT>480)
    {
        t = [NSString stringWithFormat:@"%@-568h",t];
        return [self loadImagePathForResource:t ofType:type];
    }
    else
    {
        return [self loadImagePathForResource:t ofType:type];
    }
}

- (UIImage *)getUpadateBgImage
{
    if(SCREEN_HEIGHT>480)
    {
        return [self loadImagePathForResource:@"newUI_update-568h" ofType:@"png"];
    }
    else
    {
        return [self loadImagePathForResource:@"newUI_update" ofType:@"png"];
    }
}

-(UIImage *)getUpdateButtonImage
{
    return [self loadImagePathForResource:@"newUI_update_btn" ofType:@"png"];
}

@end
