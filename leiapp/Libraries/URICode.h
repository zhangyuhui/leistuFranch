//
//  URICode.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//


@interface URICode : NSObject {
    
}

+ (NSString*) escapeHTML:(NSString*)src;
+ (NSString*) unescapeHTML:(NSString*)src;
+ (NSString*) escapeURIComponent:(NSString*)src;
+ (NSString*) unescapeURIComponent:(NSString*)url;


@end

