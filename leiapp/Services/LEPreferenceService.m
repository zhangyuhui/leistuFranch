//
//  LEPreferenceService.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/12/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEPreferenceService.h"
#import "LEConstants.h"

@implementation LEPreferenceService

+ (instancetype)sharedService {
    static LEPreferenceService *sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[super allocWithZone:NULL] init];
    });
    return sharedService;
}

+ (instancetype)allocWithZone:(NSZone *)zone{
    NSString *reason = [NSString stringWithFormat:@"Attempt to allocate a second instance of the singleton %@", [self class]];
    NSException *exception = [NSException exceptionWithName:@"Multiple singletons" reason:reason userInfo:nil];
    [exception raise];
    return nil;
}

- (CGFloat)fontSize {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSNumber* fontSetting = [prefs objectForKey:kLEPreferneceKeyFont];
    int fontSettingValue = (fontSetting == nil) ? 2 : [fontSetting intValue];
    if (fontSettingValue == 1){
        return 14.0;
    }else if (fontSettingValue == 2){
        return 16.0;
    }else{
        return 18.0;
    }
}

- (CGFloat)paddingSize {
    return 10.0;
}

- (CGFloat)spacingSize {
    return 5.0;
}

- (BOOL)messageNotify {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSNumber* setting = [prefs objectForKey:kLEPreferneceKeyMessageNotify];
    return (setting != nil) ? [setting boolValue]: NO;
}
- (void)setMessageNotify:(BOOL)messageNotify {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:[NSNumber numberWithBool:messageNotify] forKey:kLEPreferneceKeyMessageNotify];
}

- (BOOL)downloadInNoneWifi {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSNumber* setting = [prefs objectForKey:kLEPreferneceKeyDownloadInNoneWifi];
    return (setting != nil) ? [setting boolValue]: NO;
}

- (void)setDownloadInNoneWifi:(BOOL)downloadInNoneWifi {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:[NSNumber numberWithBool:downloadInNoneWifi] forKey:kLEPreferneceKeyDownloadInNoneWifi];
}

- (BOOL)syncInNoneWifi {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSNumber* setting = [prefs objectForKey:kLEPreferneceKeySyncInNoneWifi];
    return (setting != nil) ? [setting boolValue]: NO;
}

- (void)setSyncInNoneWifi:(BOOL)syncInNoneWifi {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:[NSNumber numberWithBool:syncInNoneWifi] forKey:kLEPreferneceKeySyncInNoneWifi];
}
@end
