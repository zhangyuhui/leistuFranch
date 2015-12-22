//
//  UIImage+Additions.h
//  iCollege
//
//  Created by Zhang Yuhui on 12/14/10.
//  Copyright 2011 __MyCompanyName__ Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ROUND_CORNER_RADIUS_BIG   25
#define ROUND_CORNER_RADIUS_NORMAL 10 
#define ROUND_CORNER_RADIUS_SMALL  5 

@interface UIImage (Additions) 
- (UIImage*)imageWithScale:(CGSize)size;
- (UIImage*)imageWithReflection:(CGFloat)fraction;
- (UIImage*)imageWithOutline:(UIColor*)color lineWidth:(CGFloat)lineWidth;
- (UIImage*)imageWithOutline:(UIColor*)color size:(CGSize)size;
- (UIImage*)imageWithCornerNumber:(int)number;
- (UIImage*)imageWithBottomNumber:(int)number;
- (UIImage*)imageWithRoundCorners:(int)radius;
- (UIImage*)imageWithBackground:(UIColor*)color size:(CGSize)size outline:(UIColor*)outline spacing:(CGFloat)spacing;
@end
