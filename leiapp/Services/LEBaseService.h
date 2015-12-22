//
//  LEBaseService.h
//  leiapp
//
//  Created by Yuhui Zhang on 9/4/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEBaseService : NSObject

- (void)persistent;
- (void)restore;
- (NSString*)dataPathWithAccount;
- (NSString*)dataPath;
- (NSString*)dataPath:category;
+ (NSString*)rootDataPath;
+ (NSString*)rootDataPath;
@end
