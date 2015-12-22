//
//  UMedia.m
//  LeiTeacherClient
//
//  Created by Rambo on 15/7/23.
//  Copyright (c) 2015年 U-Learning. All rights reserved.
//

#import "AUMedia.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MKMessage.h"
#import "LEDefines.h"

@interface AUMedia ()<AVAudioPlayerDelegate>
{
    NSString *UrlStrVideo;
    NSString *UrlStrAudio;
    AVAudioPlayer *audioPlayer;//播放器
    NSTimer *timer;//进度更新定时器
}
//播放器视图控制器
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerViewController;


@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//播放器
//@property (weak, nonatomic) IBOutlet UILabel *controlPanel; //控制面板
//@property (weak, nonatomic) IBOutlet UIProgressView *playProgress;//播放进度
//@property (weak, nonatomic) IBOutlet UILabel *musicSinger; //演唱者
//@property (weak, nonatomic) IBOutlet UIButton *playOrPause; //播放/暂停按钮(如果tag为0认为是暂停状态，1是播放状态)

@property (weak ,nonatomic) NSTimer *timer;//进度更新定时器
@end
@implementation AUMedia

/*
音视频接口：UMedia
//播放视频
1、UMedia.playVideo('videoFile');
javascript:videoCompletion();//播放结束调用
//播放音频
2、UMedia.playAudio('audioFile');
3、UMedia.stopAudio();
 */
- (void)playVideo:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);

    UrlStrVideo = [command.arguments objectAtIndex:0];
    NSArray *lsarray  = [UrlStrVideo componentsSeparatedByString:@"."];
    NSString * filetype = [lsarray objectAtIndex:lsarray.count-1];
    if(!([filetype isEqualToString:@"mp4"]||[filetype isEqualToString:@"m4v"]||[filetype isEqualToString:@"mpv"]||[filetype isEqualToString:@"mov"]))
    {
        SHOWHUD(@"很抱歉，本版本不支持该视频格式！");
        return;
    }else
    {
        UserNameDefault(UrlStrVideo, [NSString stringWithFormat:@"UrlStrVideo_%@",setUserID(nil)], @"UrlStrVideo");
    }
    NSLog(@"musicURL%@",UrlStrVideo);
    [self playClick:nil];
}
#pragma mark - 私有方法
/**
 *  取得本地文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getFileUrl{
    NSString *urlStr=[[NSBundle mainBundle] pathForResource:@"The New Look of OS X Yosemite.mp4" ofType:nil];
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

/**
 *  取得网络文件路径
 *
 *  @return 文件路径
 */
-(NSURL *)getNetworkUrl{
    NSString *urlStr=UrlStrVideo;
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    return url;
}

-(MPMoviePlayerViewController *)moviePlayerViewController{
    if (!_moviePlayerViewController) {
        NSURL *url=[self getNetworkUrl];
        _moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
        [self addNotification];
    }
    return _moviePlayerViewController;
}
#pragma mark - UI事件
- (void)playClick:(id )sender {
    self.moviePlayerViewController=nil;//保证每次点击都重新创建视频播放控制器视图，避免再次点击时由于不播放的问题
    //    [self presentViewController:self.moviePlayerViewController animated:YES completion:nil];
    //注意，在MPMoviePlayerViewController.h中对UIViewController扩展两个用于模态展示和关闭MPMoviePlayerViewController的方法，增加了一种下拉展示动画效果
    [self moviePlayerViewController];
    [[MKMessage shareMessage] postotification:self.moviePlayerViewController name:NOTIFY_PRESENTMEDIA];
//    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
}

#pragma mark - 控制器通知
/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayerViewController.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerViewController.moviePlayer];
    
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayerViewController.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            [self JSHelper:@"videoCompletion()"];
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放.");
            [self JSHelper:@"videoCompletion()"];
            break;
        default:
            NSLog(@"播放状态:%li",self.moviePlayerViewController.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",self.moviePlayerViewController.moviePlayer.playbackState);
}

-(void)JSHelper:(NSString *)js{
    
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}




- (void)playAudio:(CDVInvokedUrlCommand*)command
{
    NSLog(@"CDVPluginResult --> methodName: --> %@",command.methodName);

    [self play:command];

    
}
- (void)stopAudio:(CDVInvokedUrlCommand*)command
{
    [self stop:nil];
}


-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    return _timer;
}

/**
 *  创建播放器
 *
 *  @return 音频播放器
 */
//-(AVAudioPlayer *)audioPlayer{
//    if (!_audioPlayer) {
//        NSString *urlStr=[[NSBundle mainBundle]pathForResource:UrlStrAudio ofType:nil];
//        NSURL *url=[NSURL fileURLWithPath:urlStr];
//        NSError *error=nil;
//        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
//        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
//        //设置播放器属性
//        _audioPlayer.numberOfLoops=0;//设置为0不循环
//        _audioPlayer.delegate=self;
//        [_audioPlayer prepareToPlay];//加载音频文件到缓存
//        if(error){
//            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
//            return nil;
//        }
//        
//    }
//    return _audioPlayer;
//}

/**
 *  播放音频
 */
- (void)play:(CDVInvokedUrlCommand*)command
{
    //    NSString* echo = [command.arguments objectAtIndex:0];
    NSLog(@"音频下载地址：%@",[command.arguments objectAtIndex:0]);
    /*
    [Post downloadFileWithURLString:[command.arguments objectAtIndex:0] Block:^(id result, NSError *error) {
        if (result) {
            NSString *urlStr=result;
            NSLog(@"音频播放地址：%@",urlStr);
            NSURL *url=[NSURL fileURLWithPath:urlStr];
            NSError *error=nil;
            if (!timer) {
                timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
            }else
                timer.fireDate=[NSDate distantPast];//恢复定时器
            //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
            audioPlayer=nil;
            audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
            //设置播放器属性
            audioPlayer.numberOfLoops=0;//设置为0不循环
            audioPlayer.delegate=self;
            [audioPlayer prepareToPlay];//加载音频文件到缓存
            if(error){
                NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
                audioPlayer = nil;
                return ;
            }
            
            if ([audioPlayer isPlaying]) {
                [audioPlayer play];
            }
            [audioPlayer play];
            NSString *duration=[NSString stringWithFormat:@"%f",audioPlayer.duration];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:duration,@"total_duration",@"2",@"status",audioPlayer.currentTime,@"duration", nil];
            CDVPluginResult* pluginResult = nil;
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
            
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            
        }
        else
        {
            CDVPluginResult* pluginResult = nil;
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"播放失败"];
            
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            
        }
    }];
    
    */
}
-(void)updateProgress{
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"postStr({'total_duration':%f,'status':2,'duration':%f});",audioPlayer.duration,audioPlayer.currentTime]];
}

/*
 暂停音频播放：
 Course.pause();
 停止音频播放：
 Course.stop();
 成功回调：callback(200);  //200成功暂停
 */
- (void)pause:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    //    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"pause"]) {
        if ([audioPlayer isPlaying]) {
            [audioPlayer pause];
            timer.fireDate=[NSDate distantFuture];//暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
            
        }
    }
    
    NSArray* array = [NSArray arrayWithObjects:@"1", @"2", nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:array];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)stop:(CDVInvokedUrlCommand*)command
{
    if ([audioPlayer isPlaying]) {
        [audioPlayer stop];
        timer=nil;//关闭定时器
        [timer invalidate];
    }
    [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:audioStoped({status:3});"];
}






/**
 *  一旦输出改变则执行此方法
 *
 *  @param notification 输出改变通知对象
 */
-(void)routeChange:(NSNotification *)notification{
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self pause:nil];
        }
    }
    
    //    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    //        NSLog(@"%@:%@",key,obj);
    //    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成...");
    //根据实际情况播放完成可以将会话关闭，其他音频应用继续播放
    [[AVAudioSession sharedInstance]setActive:NO error:nil];
}

@end
