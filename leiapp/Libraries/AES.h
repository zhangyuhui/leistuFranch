//
//  AES.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface AES : NSObject {

}

+ (NSData *)doAESEncrypt:(NSData *)plainText Key:(NSData *)sKey IV:(NSData *)sIv isEncrypt:(CCOperation)encryptOrDecrypt;

@end
