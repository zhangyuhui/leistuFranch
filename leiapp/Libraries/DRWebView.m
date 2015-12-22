//
//  DRWebView.m
//  CEBCredit_3.04
//
//  Created by DK.J on 14-10-28.
//
//

#import "DRWebView.h"

@implementation DRWebView


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

- (void)removeLongPressGesture
{
    //去掉webView的长按事件
    int gestureNum = self.gestureRecognizers;
    for (int i = 0; i < gestureNum; i++) {
        if ([self.gestureRecognizers[i] isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [self removeGestureRecognizer:self.gestureRecognizers[i]];
            break;
        }
    }
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return NO;
}

@end
