//
//  Task.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//

#import "HTTPManager.h"
#import "HTTPConnection.h"


@interface Task : NSObject {
    
    HTTPConnection                          *connection_;
    
    NSString                                *name_;
    
    BOOL                                    isNotAllowedCancel_;
    
    BOOL                                    isCancel_;
    BOOL                                    isFail_;
    
    id                                      target_;
    SEL                                     selector_;
    id                                      argument_;
    
}


@property (nonatomic, retain) HTTPConnection *connection_;
@property (nonatomic, retain) NSString *name_;
@property (nonatomic, assign) BOOL isFail_;


- (id) init:(NSString *)name;

- (void) setTarget:(id)target selecter:(SEL)selector argument:(id)argument;

- (void) run;
- (void) runSyn;
- (void) cancel;
- (void) response:(NSURLResponse *)response;
- (void) receiveData:(NSData *)data;
- (void) done;
- (void) fail:(NSError *)error;

- (void) setNotAllowedCancel:(BOOL)noCancel;
- (BOOL) getNotAllowedCancel;
- (void) setIsCancel:(BOOL)isCancel;
- (BOOL) getIsCancel;

@end
