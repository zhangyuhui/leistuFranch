//
//  NSString+Addition.h
//  leiapp
//
//  Created by Yuhui Zhang on 8/16/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Addition)

+ (id)stringWithData:(NSData*)data;

+ (NSString *)generateGuid;

+ (id) NSNullToNil:(id)text;

+ (BOOL)stringIsNilOrEmpty:(NSString*)text;

+ (NSString *)stringWithPlaceholder:(NSString*)text placeholder:(NSString*)placeholder;
    
+ (NSData *)decodeBase64WithString:(NSString *)strBase64;

- (NSString*)stringByStrippingHTML;

- (NSString *)stringByURLEncodingAsStringParameter;

- (NSString*)stringByDecodingHTMLEntities;

- (NSString *)stringFromMD5;

- (BOOL)isWhitespaceAndNewlines;

- (BOOL)isEmptyOrWhitespace;

- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding;

- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query;

/**
 * Compares two strings expressing software versions.
 * Examples (?? means undefined):
 *   "3.0" = "3.0"
 *   "3.0a2" = "3.0a2"
 *   "3.0" > "2.5"
 *   "3.1" > "3.0"
 *   "3.0a1" < "3.0"
 *   "3.0a1" < "3.0a4"
 *   "3.0a2" < "3.0a19"  <-- numeric, not lexicographic
 *   "3.0a" < "3.0a1"
 *   "3.02" < "3.03"
 *   "3.0.2" < "3.0.3"
 *   "3.00" ?? "3.0"
 *   "3.02" ?? "3.0.3"
 *   "3.02" ?? "3.0.2"
 */
- (NSComparisonResult)versionStringCompare:(NSString *)other;

@property (nonatomic, readonly) NSString* md5Hash;

@end
