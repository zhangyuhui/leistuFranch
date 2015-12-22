//
//  Utils.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//



@interface Utils : NSObject {

}


+ (int) strCoordToInt:(NSString *)string;
+ (BOOL) containRect:(CGRect)rect1 rect2:(CGRect)rect2;
+ (BOOL) intersectRect:(CGRect)rect1 rect2:(CGRect)rect2 contain:(BOOL)contain;

+ (NSData *) readFile:(NSString *)name;

@end
