//
//  Thread.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//




@interface Thread : NSThread {
	
	int                                     threadPriority_;
	
	NSCondition				*condition_;
	
}


@property (nonatomic, assign) int threadPriority_;
@property (nonatomic, retain) NSCondition *condition_;


- (id) init: (int)priority;


- (void) sleepForTime: (NSTimeInterval)ti;
- (BOOL) exit;


@end
