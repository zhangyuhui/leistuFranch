//
//  TLS.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//

#import "HTTPConnection.h"

#define SERVER_RANDOM_NUM_2 @"SERVER_RANDOM_NUM_2"
#define SERVER_CER_FILE @"SERVER_CER_FILE"
//#define ROOT_CER_FILE_SIGN_DATA_LENGTH 128 //nots: RSA 1024 use.
#define ROOT_CER_FILE_SIGN_DATA_LENGTH 256 //nots: RSA 2048 use.


@protocol TLSDelegate <NSObject>

- (void)doneTLSData:(NSData *)data;

@end

@interface TLS : NSObject <HTTPConnectionDelegate> {
    
    id      delegate;
    
    NSData *RNS_;
	NSData *PMS_;
	NSData *RNC_;
	NSData *MS_;
	NSData *RNS2_;
	NSData *MS2_;
	NSData *OnceRnc_;
	NSData *PMS2_;
	SecKeyRef serverRSAKey_;
	NSData *clientHelloBody_;
	NSData *serverHelloBody_;
	NSData *clientKeyExBody_;
	NSData *serverKeyExBody_;
	TLSReponseType tlsReponseType_;
	//Aes key iv
	NSData *clientKey_;
	NSData *clientIv_;
	NSData *serverKey_;
	NSData *serverIv_;
	//hmac key
	NSData *clientHmacKey_;
	NSData *serverHmacKey_;
	
	
	NSString *cookie;
	
	id appDelegate_;
	
	//服务器地址
    NSString	*baseUrl;
    
    //客户端版本
	NSString    *ewpVersion;
    
    //生产或测试证书
    NSString *publicKeyRef_;
    
    NSString *_clientType;//!<客户端类型。因为信用卡会有几个不同的客户端类型，所以使用一个string的变量交由客户端控制
}



@property (nonatomic, assign) id<TLSDelegate> delegate;

@property (nonatomic, retain) NSData *RNS_;
@property (nonatomic, retain) NSData *PMS_;
@property (nonatomic, retain) NSData *RNC_;
@property (nonatomic, retain) NSData *MS_;
@property (nonatomic, retain) NSData *RNS2_;
@property (nonatomic, retain) NSData *MS2_;
@property (nonatomic, retain) NSData *OnceRnc_;
@property (nonatomic, retain) NSData *PMS2_;
@property (nonatomic, retain) NSData *clientHelloBody_;
@property (nonatomic, retain) NSData *serverHelloBody_;
@property (nonatomic, retain) NSData *clientKeyExBody_;
@property (nonatomic, retain) NSData *serverKeyExBody_;
@property (nonatomic, retain) NSData *clientKey_;
@property (nonatomic, retain) NSData *clientIv_;
@property (nonatomic, retain) NSData *serverKey_;
@property (nonatomic, retain) NSData *serverIv_;
@property (nonatomic, retain) NSData *clientHmacKey_;
@property (nonatomic, retain) NSData *serverHmacKey_;
@property (nonatomic, copy) NSString *cookie;
@property (nonatomic, assign) id appDelegate_;
@property (nonatomic, retain) NSString *baseUrl;
@property (nonatomic, retain) NSString *ewpVersion;
@property (nonatomic, retain) NSString *publicKeyRef_;
@property (nonatomic, assign, readonly) TLSReponseType tlsReponseType_;//!<增加这个接口是因为网络请求的超时不对tls的握手流程产生影响。
@property (nonatomic, retain) NSString *clientType;

+ (TLS *) sharedTLS;


- (void)getClientProtocolVersion:(unsigned char *)version;

- (int)getGMTTime;

- (void)getClientRandom:(unsigned char *)randoms count:(int)count;

- (NSData *)getSessionId;

- (NSData *)getCipherSuite;

- (NSData *)getCertSerialNumber;

- (void)createTLSWithServer:(NSString *)serverUrl;
- (void)clientHelloRequest:(NSString *)serverUrl;
- (NSData *)createFullClientHelloBody;
- (int)handleFullServerHelloResponse:(NSData *)data;
- (NSInteger)handleServerHello:(NSData *)data offset:(NSInteger) offset;
- (NSInteger)handleServerCertificate:(NSData *)data offset:(NSInteger) offset;
- (NSInteger)handleServerCertificateRequest:(NSData *)data offset:(NSInteger) offset;
- (NSData *)handleFullServerKeyExchangeResponse:(NSData *)data;
- (int)handleChangeCipher:(NSData *)data offset:(int)offset;
- (int)handleFinish:(NSData *)data offset:(int)offset;
- (int)verifyFinishData:(NSData *)hVerifyData;
- (NSData *)handleInitContent:(NSData *)data offset:(int)offset;
- (void)saveServerCertificate:(NSData *)data;
- (void)saveServerRandom2:(NSData *)data;
- (int)parseServerKeyExchange:(NSData *)data offset:(int)offset;
- (int)verifyServerCertificate:(NSData *)data;
- (void)sendClientKeyExchange;
- (NSData *)getClientKeyExchangeBody;
- (NSData *)getChangeCipherSpecBody;
- (NSData *)getFinishedBody:(NSData *)data;
- (NSData *)getVerifyData:(NSData *)data;
- (NSData *)getPreMasterSecret;
- (NSData *)getAESKey:(NSData *)data;
- (NSData *)getAESIv:(NSData *)data;
- (NSData *)getHmacKey:(NSData *)data;
- (int)verifyHmacSha1:(NSData *)secret orgData:(NSData *)orgD hmac:(NSData *)hmacsha1;
- (void)createAesKey:(NSData *)ms seed:(NSData *)msSeed;

- (void)clientHelloAndKeyExchange;
- (NSData *)handleSimpleClientHelloAndKeyExchangeResponse:(NSData *)data;

-(NSData *)getLengthData:(int)length;
int convertNSDataToInt(NSData *data);
@end
