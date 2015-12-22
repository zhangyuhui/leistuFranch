//
//  NSDate+Addition.h
//  iCollege
//
//  Created by Yuhui Zhang on 5/23/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addition)

+ (NSString*)stringFromTimeInterval:(NSTimeInterval)theInterval; 
+ (NSString*)stringFromTimeIntervalSinceReferenceDate:(NSTimeInterval)theInterval;

- (BOOL)isSameDayAs:(NSDate*)otherDate;
@end
