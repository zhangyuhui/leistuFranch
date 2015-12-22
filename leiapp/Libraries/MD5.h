//
//  MD5.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MD5 : NSObject {
}

+ (NSString *) MD5Digest:(NSString *)str;
+ (NSData *) MD5DigestData:(NSData *)data;
+ (NSData *)HmacMD5:(NSData *)data Key:(NSData *)Key;

@end
