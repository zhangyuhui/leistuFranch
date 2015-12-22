//
//  LEMessageService.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/22/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseService.h"
#import "LEMessage.h"

@interface LEMessageService : LEBaseService

+ (instancetype)sharedService;

- (void)sendMessage:(LEMessage*)message
            success:(void (^)(LEMessageService *service))success
            failure:(void (^)(LEMessageService *service, NSString* error))failure;

@end
