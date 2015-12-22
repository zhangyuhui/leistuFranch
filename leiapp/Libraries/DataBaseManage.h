//
//  DataBaseManage.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//

#import <sqlite3.h>


@interface DataBaseManage : NSObject {
    sqlite3             *database_;
    NSString            *databasePath_;
    BOOL                bFirstCreate_;
}

+ (DataBaseManage *) shareDataBaseManager;
- (BOOL) open;
- (void) close;


- (BOOL) insertDataToBuffer:(NSString*) key value:(NSString *)value;
- (BOOL) updateBufferRecord:(NSString*)key value:(NSString *)value;
- (NSString *) getValueWithKey:(NSString*)key;

@end
