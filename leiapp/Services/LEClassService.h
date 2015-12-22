//
//  LEClassService.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/19/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseService.h"
#import "LEClass.h"

@interface LEClassService : LEBaseService

typedef enum {
    LEClassStatusAll = 0,
    LEClassStatusNormal,
    LEClassStatusArchive
} LEClassStatus;

+ (instancetype)sharedService;

@property (strong, nonatomic) NSArray* classes;

- (void)getClasses:(LEClassStatus)status
           success:(void (^)(LEClassService *service, NSArray* classes))success
           failure:(void (^)(LEClassService *service, NSString* error))failure;

- (void)getClasse:(int)classId
          success:(void (^)(LEClassService *service, LEClass* classe))success
          failure:(void (^)(LEClassService *service, NSString* error))failure;

- (void)quitClass:(int)classId
          success:(void (^)(LEClassService *service))success
          failure:(void (^)(LEClassService *service, NSString* error))failure;

- (void)reclaimClass:(int)classId
             success:(void (^)(LEClassService *service))success
             failure:(void (^)(LEClassService *service, NSString* error))failure;


@end
