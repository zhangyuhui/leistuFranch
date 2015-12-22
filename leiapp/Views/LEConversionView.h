//
//  LEConversionView.h
//  leiappv2
//
//  Created by Yuhui Zhang on 10/11/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECustomView.h"

@interface LEConversionView : LECustomView
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) UIColor* textColor;
@property (strong, nonatomic) UIColor* filledColor;
@property (assign, nonatomic) CGFloat arrowPostion;

- (CGFloat)heightForViewWidth:(CGFloat)width;
@end
