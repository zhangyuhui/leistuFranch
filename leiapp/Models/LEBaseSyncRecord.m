//
//  LEBaseSyncRecord.m
//  leiappv2
//
//  Created by Yuhui Zhang on 11/26/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEBaseSyncRecord.h"

@interface LEBaseSyncRecord () {
    BOOL _changed;
}
@end

@implementation LEBaseSyncRecord

- (void)setChanged {
    if (!_changed) {
        _changed = YES;
    }
}

- (BOOL)isChanged {
    return _changed;
}

- (void)clearChange {
    if (_changed) {
        _changed = NO;
    }
}

@end
