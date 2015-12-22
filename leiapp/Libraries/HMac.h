//
//  HMac.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//

//static const char[] key={ (byte)0xab,(byte)0x33,(byte)0x93,(byte)0x34,(byte)0xa3,(byte)0x8e,(byte)0x93,(byte)0x3a,(byte)0x99,(byte)0x23, (byte)0xa4,(byte)0xe3,(byte)0xea,(byte)0x3e,(byte)0x76,(byte)0x84,(byte)0x80,(byte)0x2f,(byte)0x6d,(byte)0xd3,(byte)0xdb,(byte)0xe3,(byte)0xf3,(byte)0xa4};
//static NSString *KEY_MAC_MD5 = @"HmacMD5";
static NSString *KEY_MAC_SHA1 = @"HmacSHA1";

@interface HMac : NSObject {

}

+ (NSData *) encryptHMAC:(NSData *)data Key:(NSData *)key KeyMacMode:(NSString *)keyMacMode; 
+ (NSData *) PRF:(NSData *) secret label:(NSData *) label seed:(NSData *)seed length:(int) length;
+ (NSData *) prfHash:(NSData *) s1 param2:(NSData *) labelAndSeed length:(int) length keymode:(NSString *) keymode;
+ (NSData *) hmacXOR:(NSData *) byts1 param2:(NSData *) byts2;
+ (NSData *) TLS_MD_CLIENT_FINISH_CONST;
+ (NSData *) TLS_MD_SERVER_FINISH_CONST;
+ (NSData *) TLS_MD_MASTER_SECRET_CONST;
+ (NSData *) TLS_MD_MASTER_SECRET2_CONST;
+ (NSData *) TLS_MD_PREMASTER_SECRET_CONST;
+ (NSData *) TLS_MD_PREMASTER_SECRET2_CONST;
+ (NSData *) TLS_MD_CLIENT_SERVER_KEYIVMAC_CONST;
+ (NSData *) TLS_ONCE_SECRET_CONST;

@end
