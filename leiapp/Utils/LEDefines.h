//
//  LEDefines.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define UIColorFromARGB(argbValue) [UIColor \
colorWithRed:((float)((argbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((argbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(argbValue & 0xFF))/255.0 \
alpha:((float)(argbValue & 0xFF000000))/255.0]

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define StateBarHeight ScreenHeight > 480 ? 20 : 0
#define MainHeight (ScreenHeight - StateBarHeight)
#define MainWidth ScreenWidth


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define is_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define COLORLINE [UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1]
#define COLORMAIN [UIColor colorWithRed:56/255.0 green:198/255.0 blue:247/255.0 alpha:1]
#define COLORTITEL [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]
#define COLORBACKGROUD [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]

#define COLORWHITESELECT [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1]

#define COLORBUTTON_SELECT [UIColor colorWithRed:45/255.0 green:158/255.0 blue:198/255.0 alpha:1]
#define COLORLABEL [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1]
#define COLORLABEL_SELECT [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1]
#define COLORRED [UIColor colorWithRed:255/255.0 green:57/255.0 blue:57/255.0 alpha:1]
#define COLORRED_SELECT [UIColor colorWithRed:204/255.0 green:46/255.0 blue:45/255.0 alpha:1]
#define COLORYOLLOW [UIColor colorWithRed:255/255.0 green:142/255.0 blue:32/255.0 alpha:1]

#define COLORBLUE [UIColor colorWithRed:158/255.0 green:220/255.0 blue:108/255.0 alpha:1]

#define COLORYOLLOW_LOW [UIColor colorWithRed:255/255.0 green:200/255.0 blue:106/255.0 alpha:1]

#define COLORAUX [UIColor colorWithRed:30/255.0 green:127/255.0 blue:176/255.0 alpha:1]


#define FONTNAVTITLE [UIFont systemFontOfSize:20]

#define FONTTABLETITLE [UIFont systemFontOfSize:18];

#define FONTTABLELABEL [UIFont systemFontOfSize:16];

#define FONTLABEL [UIFont systemFontOfSize:14];

#define FONTNOTE [UIFont systemFontOfSize:13];
#define ORNULL(x) (x==nil||[x isEqual:[NSNull null]]||[x isKindOfClass:[NSNull class]])?@"":x
#define SHOWHUD(x) UIWindow *  window=[UIApplication sharedApplication].keyWindow;MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];hud.removeFromSuperViewOnHide =YES;hud.mode = MBProgressHUDModeText;hud.labelText = x;[hud hide:YES afterDelay:.7]

#define checkNull(__X__)        (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

#define HOST @"http://apps.longmanenglish.cn/"
static BOOL isEvaluating;

//#define HOST @"http://192.168.0.130:8080/appbackend4lei/"//蔡应时
//#define HOST @"http://192.168.0.220:8086/appbackend4lei/"//刘峰
//#define HOST @"http://192.168.0.190:8081/appbackend4lei/"//lf
inline static int showAnswer(int i){
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //反序列化
    if (!i) {
        return [[userDefaults objectForKey:@"showAnswer"] intValue];
    }
    //序列化
    [userDefaults setObject:[NSNumber numberWithInt:i] forKey:@"scoreline"];
    return 0;
}
inline static int Scoreline(int i){
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //反序列化
    if (!i) {
        return [[userDefaults objectForKey:@"scoreline"] intValue];
    }
    //序列化
    [userDefaults setObject:[NSNumber numberWithInt:i] forKey:@"scoreline"];
    return 0;
}

//NSUserDefaults只支持： NSString, NSNumber, NSDate, NSArray, NSDictionary.
inline static id UserDefault(id object,NSString *key)
{
    NSUserDefaults *objud;
    if ([key isEqualToString:@"main"]) {
        objud = [[NSUserDefaults alloc]initWithSuiteName:@"main"];
    }else
        objud = [NSUserDefaults standardUserDefaults];
    if (object) {
        @try {
            [objud setObject:object forKey:key];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        @finally {
            
        }
        return nil;
    }else
        return [objud objectForKey:key];
}

inline static id UserNameDefault(id object,NSString *key, NSString* username)
{
    NSUserDefaults *objud = [[NSUserDefaults alloc] initWithSuiteName:username];
    if (object) {
        @try {
            [objud setObject:object forKey:key];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        @finally {
            
        }
        return nil;
    }else
        return [objud objectForKey:key];
}


inline static NSString *setDownLoadType(NSString *userIDString)
{
    NSString *userIDpath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/downLoadType"];
    //反序列化
    if (!userIDString) {
        NSMutableData *data2 = [NSMutableData dataWithContentsOfFile:userIDpath];
        NSKeyedUnarchiver *ua = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
        userIDString =[ua decodeObjectForKey:@"downLoadType"];
        return userIDString;
    }
    //序列化
    NSMutableData *userIDdata = [[NSMutableData alloc]init];
    NSKeyedArchiver *userIDarchiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:userIDdata];
    [userIDarchiver encodeObject:userIDString forKey:@"downLoadType"];
    [userIDarchiver finishEncoding];
    [userIDdata writeToFile:userIDpath atomically:YES];
    return nil;
}

//存课 取课
inline static NSArray *globalAllCourse(NSArray *allCourse)
{
    NSString *userIDpath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/allCourse"];
    //反序列化
    if (!allCourse) {
        NSMutableData *data2 = [NSMutableData dataWithContentsOfFile:userIDpath];
        NSKeyedUnarchiver *ua = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
        allCourse =[ua decodeObjectForKey:@"allCourse"];
        return allCourse;
    }
    //序列化
    NSMutableData *userIDdata = [[NSMutableData alloc]init];
    NSKeyedArchiver *userIDarchiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:userIDdata];
    [userIDarchiver encodeObject:allCourse forKey:@"allCourse"];
    [userIDarchiver finishEncoding];
    [userIDdata writeToFile:userIDpath atomically:YES];
    return nil;
}
inline static NSString *setFontSize(NSString *userIDString)
{
    NSString *userIDpath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/fontSize"];
    //反序列化
    if (!userIDString) {
        NSMutableData *data2 = [NSMutableData dataWithContentsOfFile:userIDpath];
        NSKeyedUnarchiver *ua = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
        userIDString =[ua decodeObjectForKey:@"fontSize"];
        return userIDString;
    }
    //序列化
    NSMutableData *userIDdata = [[NSMutableData alloc]init];
    NSKeyedArchiver *userIDarchiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:userIDdata];
    [userIDarchiver encodeObject:userIDString forKey:@"fontSize"];
    [userIDarchiver finishEncoding];
    [userIDdata writeToFile:userIDpath atomically:YES];
    return nil;
}


inline static NSString *setUserID(NSString *userIDString)
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //反序列化
    if (!userIDString) {
        return [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"com.leiapp.networkconnectionuserid"]];
    }
    //序列化
    [userDefaults setObject:userIDString forKey:@"com.leiapp.networkconnectionuserid"];
    return nil;
}

inline static NSString *setToken(NSString *userIDString)
{
    NSString *userIDpath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/token"];
    //反序列化
    if (!userIDString) {
        NSMutableData *data2 = [NSMutableData dataWithContentsOfFile:userIDpath];
        NSKeyedUnarchiver *ua = [[NSKeyedUnarchiver alloc]initForReadingWithData:data2];
        userIDString =[ua decodeObjectForKey:@"token"];
        return userIDString;
    }
    //序列化
    NSMutableData *userIDdata = [[NSMutableData alloc]init];
    NSKeyedArchiver *userIDarchiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:userIDdata];
    [userIDarchiver encodeObject:userIDString forKey:@"token"];
    [userIDarchiver finishEncoding];
    [userIDdata writeToFile:userIDpath atomically:YES];
    return nil;
}
//shortCut

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS8_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS6_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS9_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )
inline static UIColor* getColorFromHex(NSString *hexColor)
{
    
    if (hexColor == nil) {
        return nil;
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}
