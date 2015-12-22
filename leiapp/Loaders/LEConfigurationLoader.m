//
//  LEConfigurationLoader.m
//  leiapp
//
//  Created by Yuhui Zhang on 8/15/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEConfigurationLoader.h"

@interface LEConfigurationLoader ()

@property (strong, nonatomic) NSDictionary* configurations;

@end

@implementation LEConfigurationLoader

- (instancetype)init {
    return [self initWithFile:@"LEAppConfiguration"];
}

- (id)initWithFile:(NSString*)filename {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    self.configurations = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    return self;
}


- (NSString*)stringForKey:(NSString*)key {
    return [self.configurations valueForKey:key];
}

- (int)intForKey:(NSString*)key {
    return [[self.configurations valueForKey:key] intValue];
}

- (double)doubleForKey:(NSString*)key {
    return [[self.configurations valueForKey:key] doubleValue];
}


@end
