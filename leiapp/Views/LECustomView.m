//
//  LECustomView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/17/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECustomView.h"

@interface LECustomView ()
@property (nonatomic, strong) NSMutableArray *customConstraints;

- (void)commonInit;
@end

@implementation LECustomView

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
    _customConstraints = [[NSMutableArray alloc] init];
    
    UIView *view = nil;
    NSString *className = NSStringFromClass([self class]);
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:className
                                                     owner:self
                                                   options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[UIView class]]) {
            view = object;
            break;
        }
    }
    
    if (view != nil) {
        _containerView = view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        [self setNeedsUpdateConstraints];
        
        [self viewDidLoad];
    }
}

- (void)updateConstraints {
    [self removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];
    
    if (self.containerView != nil) {
        UIView *view = self.containerView;
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"H:|[view]|" options:0 metrics:nil views:views]];
        [self.customConstraints addObjectsFromArray:
         [NSLayoutConstraint constraintsWithVisualFormat:
          @"V:|[view]|" options:0 metrics:nil views:views]];
        
        [self addConstraints:self.customConstraints];
    }
    
    [super updateConstraints];
}

- (void)willRemoveSubview:(UIView *)subview {
    [self viewWillUnLoad];
    [super willRemoveSubview:subview];
}

- (void)viewDidLoad {
    
}

- (void)viewWillUnLoad {
    
}
@end
