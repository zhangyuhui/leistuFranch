//
//  Config.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//

//TARGET_IPHONE_DEBUG需要在项目里面定义，来控制日志输出
//#define TARGET_IPHONE_DEBUG
//#define SHOW_ALL_ERROR //定义这个宏用来在调试或测试的时候输出所有的错误信息
#define SECURITY

typedef enum TLSReponseType {
    TLSHelloReponse = 1,
    TLSKeyExchangeReponse,
    TLSHelloAndKeyExchangeReponse,
} TLSReponseType;

typedef enum HTTPConnectionState {
	HCEmpty = 0,
	HCLoading,
	HCCanceled,
	HCError,
} HTTPConnectionState;

#pragma mark -
#pragma mark ==== Stop loading method ====
#pragma mark -
inline static void endAllLoading () {
    [[WaitDialogFullS sharedWaitDialog] endLoading];
    [[WaitDialogHalfS sharedWaitDialog] endLoading];
}

#define ERROR_TEXT @"提示"
#define ALERT_HTTP_FAIL_MSG @"通讯异常，请稍后重试local"

#define ALERT_HTTP_FAIL_FILE @"<?xml version='1.0' encoding='utf-8'?><error string='通讯异常，请您稍后重试local。'/>"

#define isIPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//Screen Display
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT isIPhone5 ? 568 : 480

#define TAG_USERINFO_CCUSER_ID @"CCUSER_ID"
#define TAG_USERINFO_CARDNO @"UserCardNumber"
#define TAG_USERINFO_CITY @"userCity"
//////////////////  TLS  ////////////////////

#define TLS_HELLO_REQUEST 0x00
#define TLS_CLIENT_HELLO 0x01
#define TLS_SERVER_HELLO 0x02
#define TLS_CERTIFICATE 0x04
#define TLS_SERVER_KEY_EXCHANGE 0x05
#define TLS_CERTIFICATE_REQUEST 0x06
#define TLS_CHANGE_CIPHER_SPEC 0x07
#define TLS_CERTIFICATE_VERIFY 0x08
#define TLS_CLIENT_KEY_EXCHANGE 0x09
#define TLS_FINISHED 0x0A
#define TLS_INIT_CONTENT 0x0B


#define TLS_NULL_WITH_NULL_NULL 0x0000
#define TLS_RSA_WITH_NULL_MD5 0x0001
#define TLS_RSA_WITH_NULL_SHA 0x0002
#define TLS_RSA_WITH_AES_128_CBC_MD5 0x0004
#define TLS_RSA_WITH_AES_128_CBC_SHA 0x0005
#define TLS_RSA_WITH_AES_256_CBC_MD5 0x0006
#define TLS_RSA_WITH_AES_256_CBC_SHA 0x0007
#define TLS_RSA_WITH_DES_CBC_MD5 0x0008
#define TLS_RSA_WITH_3DES_EDE_CBC_MD5 0x000A
#define TLS_RSA_WITH_3DES_EDE_CBC_SHA 0x000B

//handshke type
#define TLS_HANDSHAKE_TYPE_CLIENT_HELLO 0x01;
#define TLS_HANDSHAKE_TYPE_SERVER_HELLO 0x02;
#define TLS_HANDSHAKE_TYPE_CERTIFICATE 0x04;
#define TLS_HANDSHAKE_TYPE_SERVER_KEY_EXCHANGE 0x05;
#define TLS_HANDSHAKE_TYPE_CERTIFICATE_REQUEST 0x06;
#define TLS_HANDSHAKE_TYPE_CHANGECIPHERSPEC 0x07;
#define TLS_HANDSHAKE_TYPE_CERTIFICATE_VERIFY 0x08;
#define TLS_HANDSHAKE_TYPE_CLIENT_KEY_EXCHANGE 0x09;
#define TLS_HANDSHAKE_TYPE_FINISHED 0x0A;
#define TLS_HANDSHAKE_TYPE_INIT_CONTENT 0x0B;


//Thread
#define NETWORK_TIME_OUT 60.0
#define THREAD_INTERVAL 0.050

#define DEFAULT_WAITINGS_FONT_HEIGHT 18.0
#define STATUS_BAR_HEIGHT 20

#define TAG_PROPERTY_COOKIE @"cookie"
#define LOADING_TEXT @"请稍候⋯"
#define CANCEL_BUTTON_NAME @"取消"

#define CLIENT_HELLO @"/user/hello?app=ceb"
#define TLS_FACILITY_URL @"/user/handshake?app=ceb"
#define KEY_EXCHANGE @"/user/exchange?app=ceb"
