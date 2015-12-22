//
//  UFile.m
//  LeiTeacherClient
//
//  Created by Rambo on 15/7/23.
//  Copyright (c) 2015年 U-Learning. All rights reserved.
//

#import "UFile.h"
#import "LEDefines.h"
#import "MBProgressHUD+Add.h"
@interface UFile()
{
//    AFHTTPRequestOperation *op;
    NSTimer *timer;//进度更新定时器
    int progresss;
}
@end
@implementation UFile
/*
 文件操作接口：UFile
 //上传文件
 1、UFile.upload();
 javascript:uploadProgress(progress);  //上传进度
 javascript:uploadFileProgress('filepath', progress);//上传进度
 //上传文件成功
 javascript:onUploadSuccessed('filepath', 'remoteFilePath');  //上传进度
 
 

 

 


 
 //更新录音音量大小调用方法
 javascript:volume(int volumeValue);
 //已开始录音
 javascript:startRecord();
 //已停止录音
 javascript:stopRecord();
 //将录音文件地址发送到web端
 javascript:recordFile('filePath');
 //将已上传录音文件远程地址发送到web端
 javascript:uploadedRecordFile('fileRemotePath');
 //客户端错误调用方法。errorCode, errorDesc
 javascript:clientError(int errorCode, 'errorMessage');
 //上传文件进度更新
 javascript:uploadFileProgress('filePath', int uploadProgress);
 
 //选择文件
 UFile.selectFile();
 //删除已选择文件
 UFile.clearSelectFiles();
 
 */
- (void)selectFile:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);

    CDVPluginResult* pluginResult = nil;
    //    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    
    
    NSArray* array = [NSArray arrayWithObjects:@"1", @"2", nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void)clearSelectFiles:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);

    CDVPluginResult* pluginResult = nil;
    NSArray* array = [NSArray arrayWithObjects:@"1", @"2", nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)upload:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);

    CDVPluginResult* pluginResult = nil;
    //    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    SHOWHUD(@"iOS客户端暂不支持上传文件");
    if ([method isEqualToString:@"upload"]) {
    
    }
    
    NSArray* array = [NSArray arrayWithObjects:@"1", @"2", nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
/*
 //终止上传文件
 2、UFile.stopUpload();
 successFunction=删除成功
 errorFunction(msg)=删除失败
 */
- (void)stopUpload:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);
//    SHOWHUD(@"iOS客户端暂不支持上传文件");

    //    NSString* echo = [command.arguments objectAtIndex:0];
//    NSString* method = command.methodName;
//    
//    if ([method isEqualToString:@"stopUpload"]) {
//
//    }
//    
//    NSArray* array = [NSArray arrayWithObjects:@"1", @"2", nil];
//    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
//    
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
/*
 //删除文件
 3、UFile.delete('filepath');
 successFunction=删除成功
 errorFunction(msg)=删除失败
 */
- (void)delete:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);

    CDVPluginResult* pluginResult = nil;
    //    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"delete"]) {
    
    }
    
    NSArray* array = [NSArray arrayWithObjects:@"1", @"2", nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
/*
 //获取文件详情
 4、UFile.fileDetail('filepath');
 //已选文件数量、大小
 javascript:onSelectedFiles(fileCount, 'fileSize=7.5M')
 
 */
- (void)fileDetail:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);

    CDVPluginResult* pluginResult = nil;
    //    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"fileDetail"]) {

    }
    
    NSArray* array = [NSArray arrayWithObjects:@"1", @"2", nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
/*
 //选择文件
 5、HomeWork.selecteSpokenFile();
 */
- (void)selecteSpokenFile:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);

    CDVPluginResult* pluginResult = nil;
    //    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"selecteSpokenFile"]) {
    
    }
    
    NSArray* array = [NSArray arrayWithObjects:@"1", @"2", nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
/*
 //删除文件action
 6、HomeWork.deleteFile("filePath")
 */
- (void)deleteFile:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);

    CDVPluginResult* pluginResult = nil;
    //    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"deleteFile"]) {
    
    }
    
    NSArray* array = [NSArray arrayWithObjects:@"1", @"2", nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
/*
 //上传文件action
 7、HomeWork.uploadSpokenFile("filePath")
 */
- (void)uploadSpokenFile:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);

    CDVPluginResult* pluginResult = nil;
    //    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"uploadSpokenFile"]) {
    
    }
    
    NSArray* array = [NSArray arrayWithObjects:@"1", @"2", nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
/*
 //录音口语作业
 8、HomeWork.startRecord();

 */
- (void)startRecord:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);

    CDVPluginResult* pluginResult = nil;
    //    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"upload"]) {
    
    }
    
    NSArray* array = [NSArray arrayWithObjects:@"1", @"2", nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
/*
 //停止录音口语作业
 9、HomeWork.stopRecord();
 */
- (void)stopRecord:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);

    CDVPluginResult* pluginResult = nil;
    //    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"stopRecord"]) {
    
    }
    
    NSArray* array = [NSArray arrayWithObjects:@"1", @"2", nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
/*
 //播放录音口语作业
 10、HomeWork.playRecord("filePath");
 */
- (void)playRecord:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);

    CDVPluginResult* pluginResult = nil;
    //    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"playRecord"]) {
    
    }
    
    NSArray* array = [NSArray arrayWithObjects:@"1", @"2", nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
/*
 //停止播放录音口语作业
 11、HomeWork.stopPlayRecord();
 */
- (void)stopPlayRecord:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);

    CDVPluginResult* pluginResult = nil;
    //    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"upload"]) {
        
    }
    
    NSArray* array = [NSArray arrayWithObjects:@"1", @"2", nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
-(void)download:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString *urlString = [command.arguments objectAtIndex:0];
    NSOperationQueue *queue = [[NSOperationQueue alloc ]init];
    //下载地址
    NSURL *url = [NSURL URLWithString:urlString];
    //保存路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *rootPath = documentsDirectory;
    NSString *filePath;
    NSArray * nameArray = [urlString componentsSeparatedByString:@"/"];
    NSString *fileNameString = [nameArray objectAtIndex:nameArray.count-1];
    filePath= [rootPath  stringByAppendingPathComponent:fileNameString];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:filePath];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        progresss =100;
        [self updateProgress];
        timer.fireDate=[NSDate distantFuture];
        return;
    }
//    op = [[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:url]];
//    op.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
//    // 根据下载量设置进度条的百分比
//    [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        CGFloat precent = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
//        progresss = precent*100;
//    }];
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"下载成功");
//        timer=nil;//关闭定时器
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"下载失败");
//        timer=nil;//关闭定时器
//    }];
    //开始下载
//    [queue addOperation:op];
    if (!timer) {
        timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    
}
-(void)downloadSuccessed{
    [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:onDownloadAllSuccessed()"];
    timer.fireDate=[NSDate distantFuture];
}
-(void)updateProgress{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:download(%d)",progresss]];
    if (progresss ==100) {
        [self downloadSuccessed];
    }
}
-(void)cancelDownload:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);
//    [op pause];
    [self downloadSuccessed];
}
-(void)JSHelper:(NSString *)js{

    [self.webView stringByEvaluatingJavaScriptFromString:js];
}
@end
