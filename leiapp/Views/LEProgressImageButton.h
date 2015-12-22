//
//  LEProgressImageButton.h
//  leiappv2
//
//  Created by Yuhui Zhang on 9/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECustomView.h"

@interface LEProgressImageButton : LECustomView
@property (assign, nonatomic) CGFloat progress;
@property (assign, nonatomic) BOOL selected;
@property (assign, nonatomic) BOOL disabled;

@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) UIImage* highlightedImage;
@property (strong, nonatomic) UIImage* disabledImage;
@end
