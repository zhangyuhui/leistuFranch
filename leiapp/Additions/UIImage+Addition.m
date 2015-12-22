//
//  UIImage+Addition.m
//  iCollege
//
//  Created by Zhang Yuhui on 12/14/10.
//  Copyright 2011 __MyCompanyName__ Inc. All rights reserved.
//

#import "UIImage+Addition.h"
#import "LEDefines.h"

@implementation UIImage (Additions)

- (UIImage *)imageWithScale:(CGSize)size {
	if (size.width != self.size.width || size.height != self.size.height){
		CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
		UIGraphicsBeginImageContext(rect.size);
		[self drawInRect:rect];
		UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return resImage;
	}else {
		return self;
	}
}

- (UIImage *)imageWithReflection:(CGFloat)fraction {
	int reflectionHeight = self.size.height * fraction;
	
    // create a 2 bit CGImage containing a gradient that will be used for masking the
    // main view content to create the 'fade' of the reflection. The CGImageCreateWithMask
    // function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
	CGImageRef gradientMaskImage = NULL;
	
    // gradient is always black-white and the mask must be in the gray colorspace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // create the bitmap context
    CGContextRef gradientBitmapContext = CGBitmapContextCreate(nil, 1, reflectionHeight,
                                                               8, 0, colorSpace, kCGImageAlphaNone);
    
    // define the start and end grayscale values (with the alpha, even though
    // our bitmap context doesn't support alpha the gradient requires it)
    CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
    
    // create the CGGradient and then release the gray color space
    CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
    CGColorSpaceRelease(colorSpace);
    
    // create the start and end points for the gradient vector (straight down)
    CGPoint gradientStartPoint = CGPointMake(0, reflectionHeight);
    CGPoint gradientEndPoint = CGPointZero;
    
    // draw the gradient into the gray bitmap context
    CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint,
                                gradientEndPoint, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(grayScaleGradient);
	
	// add a black fill with 50% opacity
	CGContextSetGrayFillColor(gradientBitmapContext, 0.0, 0.5);
	CGContextFillRect(gradientBitmapContext, CGRectMake(0, 0, 1, reflectionHeight));
    
    // convert the context into a CGImageRef and release the context
    gradientMaskImage = CGBitmapContextCreateImage(gradientBitmapContext);
    CGContextRelease(gradientBitmapContext);
	
    // create an image by masking the bitmap of the mainView content with the gradient view
    // then release the pre-masked content bitmap and the gradient bitmap
    CGImageRef reflectionImageRef = CGImageCreateWithMask(self.CGImage, gradientMaskImage);
    CGImageRelease(gradientMaskImage);
	
	
	UIGraphicsBeginImageContext(CGSizeMake(self.size.width, reflectionHeight));
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, reflectionHeight), reflectionImageRef);
	UIImage* reflectionImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    CGImageRelease(reflectionImageRef);
	
	return reflectionImage;
}

- (UIImage *)imageWithOutline:(UIColor*)color  lineWidth:(CGFloat)lineWidth{
	
	UIGraphicsBeginImageContext(CGSizeMake(self.size.width, self.size.height));
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetAllowsAntialiasing(context, YES);
	CGContextSetLineWidth(context, lineWidth);
	CGContextSetStrokeColorWithColor(context, color.CGColor);
	CGContextAddRect(context, CGRectMake(0.0, 0.0, self.size.width, self.size.height));
	CGContextClosePath(context);
	CGContextStrokePath(context);
    
	[self drawInRect:CGRectMake(lineWidth, lineWidth, self.size.width - lineWidth*2.0, self.size.height - lineWidth*2.0)];
    
	UIImage* imageWithOutline = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageWithOutline;
}

- (UIImage*)imageWithOutline:(UIColor*)color size:(CGSize)size{
    CGRect  drawRect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    [self drawInRect:drawRect];
    if (color != nil){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSetLineWidth(context, 1.0);
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
    UIImage* outlineImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outlineImage;
}

- (UIImage*)imageWithBackground:(UIColor*)background size:(CGSize)size outline:(UIColor*)outline spacing:(CGFloat)spacing{
	UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, outline.CGColor);
	CGContextSetFillColorWithColor(context, background.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
	CGContextStrokeRect(context, CGRectMake(0.0, 0.0, size.width, size.height));
    
    CGRect imageRect = CGRectMake(spacing, spacing, size.width-spacing*2.0, size.height-spacing*2.0);
	[self drawInRect:imageRect];
	
    UIImage* imageWithBackground = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageWithBackground;    
}

- (UIImage*)imageWithCornerNumber:(int)number{
	UIGraphicsBeginImageContext(CGSizeMake(self.size.width, self.size.height));
	
	CGRect imageRect = CGRectMake(0.0, 2.0, self.size.width - 2.0, self.size.height-2.0);
	[self drawInRect:imageRect];
	
	if (number > 1){
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetAllowsAntialiasing(context, YES);
		CGContextSetLineWidth(context, 1.0);
		
		CGFloat centerX = self.size.width - 10;
		CGFloat centerY = 10;
		
		CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
		CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
		
		CGContextAddArc(context, centerX, centerY, 10, 0, M_PI*2, 1);
		CGContextClosePath(context);
		CGContextFillPath(context);
		
		CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
		CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
		
		CGRect stringRect = CGRectMake(centerX-10, centerY-10, 20, 20);
		UIFont* stringFont = [UIFont boldSystemFontOfSize:17];
		NSString* numberString = [NSString stringWithFormat:@"%d", number];
		CGSize stringSize = [numberString sizeWithFont:stringFont forWidth:stringRect.size.width lineBreakMode:UILineBreakModeTailTruncation];
		stringRect.origin.x = centerX - stringSize.width/2.0f;
		stringRect.origin.y = centerY - stringSize.height/2.0f;
		stringRect.size = stringSize;
		
		[numberString drawInRect:stringRect withFont:stringFont];
	}
	
	UIImage* imageWithOutline = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageWithOutline;
    
    
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef shadowContext = CGBitmapContextCreate(NULL, self.size.width + 10, self.size.height + 10, CGImageGetBitsPerComponent(self.CGImage), 0, 
                                                       colourSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    CGContextSetShadowWithColor(shadowContext, CGSizeMake(5, -5), 5, [UIColor blackColor].CGColor);
    CGContextDrawImage(shadowContext, CGRectMake(0, 10, self.size.width, self.size.height), self.CGImage);
    
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);
    
    UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage];
    CGImageRelease(shadowedCGImage);
    
    return shadowedImage;
}

- (UIImage*)imageWithBottomNumber:(int)number{
	UIGraphicsBeginImageContext(CGSizeMake(self.size.width, self.size.height));
	
	CGRect imageRect = CGRectMake(1.0, 1.0, self.size.width - 2.0, self.size.height-2.0);
	[self drawInRect:imageRect];
	
	if (number > 0){
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetAllowsAntialiasing(context, YES);
		CGContextSetLineWidth(context, 1.0);
		CGContextSetFillColorWithColor(context,  [UIColor grayColor].CGColor);
		CGContextSetBlendMode(context, kCGBlendModeMultiply);
		
		CGRect stringRect = CGRectMake(0, self.size.height*0.75f, self.size.width, self.size.height*0.25f);
		
		CGFloat lineX = stringRect.origin.x;
		CGFloat lineY = stringRect.origin.y;
		
		CGContextMoveToPoint(context, lineX, lineY);
		
		lineX += stringRect.size.width;
		CGContextAddLineToPoint(context, lineX, lineY);
		
		lineY += stringRect.size.height;
		CGContextAddLineToPoint(context, lineX, lineY);
		
		lineX = stringRect.origin.x;
		CGContextAddLineToPoint(context, lineX, lineY);
		
		lineY = stringRect.origin.y + stringRect.size.height;
		CGContextAddLineToPoint(context, lineX, lineY);
		
		CGContextClosePath(context);
		CGContextFillPath(context);
		
		CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
		CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
		CGContextSetBlendMode(context, kCGBlendModeNormal);
		
		UIFont* stringFont = [UIFont boldSystemFontOfSize:12];
		NSString* numberString = [NSString stringWithFormat:@"%d more", number];
		CGSize stringSize = [numberString sizeWithFont:stringFont forWidth:stringRect.size.width lineBreakMode:UILineBreakModeTailTruncation];
		stringRect.origin.x = stringRect.origin.x + (stringRect.size.width - stringSize.width)/2.0f;
		stringRect.origin.y = stringRect.origin.y + (stringRect.size.height - stringSize.height)/2.0f;
		stringRect.size = stringSize;
		
		[numberString drawInRect:stringRect withFont:stringFont];
	}
	
	UIImage* imageWithOutline = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageWithOutline;
}

- (UIImage *)imageWithRoundCorners:(int)radius{
    int width = self.size.width;
    int height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(1.0, 1.0, width-2.0, height-2.0);
	
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, radius, radius);
    float roundedRectWidth = CGRectGetWidth (rect) / radius;
    float roundedRectHeight = CGRectGetHeight (rect) / radius;
    CGContextMoveToPoint(context, roundedRectWidth, roundedRectHeight/2);
    CGContextAddArcToPoint(context, roundedRectWidth, roundedRectHeight, roundedRectWidth/2, roundedRectHeight, 1);
    CGContextAddArcToPoint(context, 0, roundedRectHeight, 0, roundedRectHeight/2, 1);
    CGContextAddArcToPoint(context, 0, 0, roundedRectWidth/2, 0, 1);
    CGContextAddArcToPoint(context, roundedRectWidth, 0, roundedRectWidth, roundedRectHeight/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
	
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, width, height), self.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    UIImage* roundCornerImage = [UIImage imageWithCGImage:imageMasked];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return roundCornerImage;    
}

@end
