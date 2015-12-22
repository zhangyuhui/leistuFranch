//
//  LEDotProgressView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/11/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEDotProgressView.h"
#import "LEDefines.h"

#define kViewDotCount 20
#define kViewDotDiameter 5
#define kViewDotSpacing 3
#define kViewWidth 200

@interface LEDotProgressView ()
@end

@implementation LEDotProgressView

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _filledColor = UIColorFromRGB(0x37d162);
    _unfilledColor = UIColorFromRGB(0xcccccc);
    _progress = 0.0;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        _progress = progress;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetFillColorWithColor(context, self.filledColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    int total = (rect.size.width + kViewDotSpacing) / (kViewDotDiameter + kViewDotSpacing);
    int filled = ceil(self.progress*total);
    
    CGFloat x = 0;
    CGFloat y = 0;
    int index = 0;
    while (x <= rect.size.width - kViewDotDiameter) {
        if (index >= filled){
            CGContextSetFillColorWithColor(context, self.unfilledColor.CGColor);
        }
        CGRect circle = CGRectMake(x, y, kViewDotDiameter, kViewDotDiameter);
        CGContextFillEllipseInRect (context, circle);
        x += kViewDotDiameter + kViewDotSpacing;
        index += 1;
    }
    
    CGContextFillPath(context);
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(kViewWidth, kViewDotDiameter);
}

@end
