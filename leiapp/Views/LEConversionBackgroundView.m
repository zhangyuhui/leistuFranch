//
//  LEConversionBackgroundView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/11/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEConversionBackgroundView.h"
#import "LEDefines.h"

#define kArrowWidth 14
#define kArrowHeight 6
#define kArrowPosition 40
#define kArrowRadius 6

@implementation LEConversionBackgroundView

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
    _arrowPosition = kArrowPosition;
    _arrowWidth = kArrowWidth;
    _arrowHeight = kArrowHeight;
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = self.layer.cornerRadius;
    if (radius == 0) {
        radius = kArrowRadius;
    }
    
    if (radius > self.bounds.size.width/2.0) {
        radius = self.bounds.size.width/2.0;
    }
    if (radius > self.bounds.size.height/2.0) {
        radius = self.bounds.size.height/2.0;
    }
    
    CGFloat minX = CGRectGetMinX(self.bounds);
    CGFloat midX = CGRectGetMidX(self.bounds);
    CGFloat maxX = CGRectGetMaxX(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds);
    CGFloat midY = CGRectGetMidY(self.bounds);
    CGFloat maxY = CGRectGetMaxY(self.bounds) - self.arrowHeight;
    
    CGContextMoveToPoint(context, minX + self.arrowPosition, maxY);
    CGContextAddArcToPoint(context, minX, maxY, minX, midY, radius);
    CGContextAddArcToPoint(context, minX, minY, midX, minY, radius);
    CGContextAddArcToPoint(context, maxX, minY, maxX, midY, radius);
    CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius);
    CGContextAddLineToPoint(context, minX + self.arrowPosition + self.arrowWidth, maxY);
    CGContextAddLineToPoint (context, minX + self.arrowPosition + self.arrowWidth/2, maxY + self.arrowHeight);
    
    CGContextClosePath(context);
    
    [self.filledColor setFill];
    CGContextDrawPath(context, kCGPathFill);
}

@end
