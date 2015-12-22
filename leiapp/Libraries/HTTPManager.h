//
//  HTTPManager.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//

@class HTTPConnection;
@class Task;

@interface HTTPManager:NSObject {
    
    id                              delegate;
    
    NSMutableArray                  *connectionList_;
    
    //光大负载均衡会传Set-Cookie给客户端，需要客户端每次请求时把这个还送回去
	NSMutableDictionary             *setCookieDic;
}


@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSMutableDictionary *setCookieDic;

/** return a instance of HTTPManager    */
+ (HTTPManager *) sharedHTTPManager;


/**  get a synchronous HTTPConnection instance */
- (HTTPConnection *) getHTTPConnection:(NSString *)url cachePolicy:(NSURLRequestCachePolicy)policy timeoutInterval:(NSTimeInterval)seconds method:(NSString *)method header:(NSMutableDictionary *)dic body:(id)body;

- (void) startHTTPConnection:(HTTPConnection *)connection;
- (void) startSynHTTPConnection:(HTTPConnection *)connection task:(Task *)task;
- (void) cancelHTTPConnection:(HTTPConnection *)connection;
- (void) doneHTTPConnection:(HTTPConnection *)connection data:(NSData *)data;
- (void) failHTTPConnection:(HTTPConnection *)connection error:(NSError *)error;
- (void) responseHTTPConnection:(HTTPConnection *)connection response:(NSURLResponse *)response;

@end
