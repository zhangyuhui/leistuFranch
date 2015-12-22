//
//  RSA.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//


#import <Security/Security.h>



@interface RSA : NSObject {
    
    SecKeyRef                           publicKey_;
	
    
}

/** return a instance of HTTPManager    */
+ (RSA *) sharedRSA;

+ (NSString *) removeRN:(NSString *)src;



#ifdef SECURITY

- (NSString *) encryptRSAWithPublicKey:(id)src;
- (void) setPublicKey:(SecKeyRef) publicKey;

- (SecKeyRef) getPublicKeyRef:(NSString *)name type:(NSString *)type;
- (SecKeyRef) getPublicKeyFromCerData:(NSData *) data;
- (SecTrustRef) getSecTrustRefFromCerData:(NSData *) data;
- (SecTrustRef) getTrustFromCertificate:(NSString *)path;
- (NSData *) doRSAEncrypt:(id)src;
- (NSData *) doEncrypt:(id)src withPadding:(SecPadding)padding;
- (NSData *) doRSAEncryptNoPadding:(id)src;

#endif

@end
