//
//  LEBaseSyncRecord.h
//  leiappv2
//
//  Created by Yuhui Zhang on 11/26/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "JSONModel.h"

@interface LEBaseSyncRecord : JSONModel

- (void)setChanged;
- (BOOL)isChanged;
- (void)clearChange;

@end
