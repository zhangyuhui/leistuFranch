//
//  HTTPConnection.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//


#if !TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
//#import <CoreServices/CoreServices.h>
#else
#import <CFNetwork/CFHTTPMessage.h>
#import <CFNetwork/CFHTTPStream.h>
//#import <CFNetwork/CFNetwork.h>
#endif

@class Task;

// Set up network parameters, designated agent
// Initiated the request, handle the back results in mehtod of delegate.
@protocol HTTPConnectionDelegate <NSObject>

@optional
- (void) receiveResponse:(NSURLResponse *)response;
- (void) failWithError:(NSError *)error;
- (void) doneData:(NSData *)data;
- (void) cancelRequest;

@end

@interface HTTPConnection : NSObject {
    
    id                                      delegate;
    
    Task                                    *curTask_;
    
    NSURLConnection                         *connection_;
    
    NSMutableURLRequest                     *request_;
    
    NSMutableData                           *data_;
	NSURLResponse                           *response_;
    
    HTTPConnectionState                     state_;
	
}


@property (nonatomic, assign) id<HTTPConnectionDelegate> delegate;
@property (nonatomic, retain) NSURLResponse *response_;
 
- (void) setRequestUrl: (NSString *)url;
- (void) setRequestCachePolicy: (NSURLRequestCachePolicy)policy;
- (void) setRequestTimeoutInterval: (NSTimeInterval)seconds;
- (void) setRequestMethod: (NSString *)method;
- (void) setRequestHeader: (NSMutableDictionary *)dic;
- (void) setRequestBody: (id)body;

- (void) setStateEmpty;
- (void) setStateLoading;
- (void) setStateCanceled;
- (void) setStateError;
- (BOOL) isStateEmpty;
- (BOOL) isStateLoading;
- (BOOL) isStateCanceled;
- (BOOL) isStateError;

- (void) start;
- (void) startSynConnection:(Task *)task;
- (void) cancel;


- (void) didFailWithError:(NSError *)error;
- (void) didReceiveResponse:(NSURLResponse *)response;
- (void) didReceiveData:(NSData *)data;
- (void) didDone;
- (void) didHmacAndNetVerify;

- (BOOL) isSameConnection:(NSURLConnection *)connection;

@end
