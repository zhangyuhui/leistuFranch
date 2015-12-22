//
//  LEConfigurationLoader.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/15/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEConfigurationLoader : NSObject

- (instancetype)initWithFile: (NSString*)filename;

- (NSString*)stringForKey:(NSString*)key;
- (int)intForKey:(NSString*)key;
- (double)doubleForKey:(NSString*)key;

@end
