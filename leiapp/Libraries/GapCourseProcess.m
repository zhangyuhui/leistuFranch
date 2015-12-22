//
//  GapCourseProcess.m
//  CordovaLibTests
//
//  Created by Rambo on 15/7/8.
//
//

#import "GapCourseProcess.h"
#import "MKMessage.h"
#import "PathsClicked.h"
//#import "UserInfo.h"
#import "LEDefines.h"
#import "LEAccount.h"
#import "LEAccountService.h"
#import "LEEnums.h"
//#import "Post.h"
//#import "Course.h"
//#import "Lesson.h"
//#import "LessonSection.h"
//#import "LessonLEIAudioResponse.h"
//#import "ChatViewController.h"
//#import "EaseMob.h"
//#import "RobotManager.h"
@interface GapCourseProcess()
{
    AVAudioPlayer *audioPlayer;//播放器
    NSTimer *timer;//进度更新定时器
    BOOL pauseBool;
}
@end
@implementation GapCourseProcess
#pragma mark LEIapp methods
/*
 退出页面:
 LEIapp.finish
 */
- (void)finish:(CDVInvokedUrlCommand*)command
{
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"finish"]) {
        [[MKMessage shareMessage] postotification:nil name:NOTIFY_WEBFINISH];
    }
}
/*
 后退：
 LEIapp.back
*/
- (void)back:(CDVInvokedUrlCommand*)command
{
    NSLog(@"back");
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"back"]) {
        [self.webView goBack];
    }
}
/*
 
 设置按下返回键返回页面：
 LEIapp.backurl(["backurl"]);
 */

- (void)backurl:(CDVInvokedUrlCommand*)command
{
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"backurl"]) {
        NSNotification *notificattion = [[NSNotification alloc]initWithName:[command.arguments objectAtIndex:0]  object:nil userInfo:nil];
        [super handleOpenURL:notificattion];
    }
}
/*
 按下左上角返回按钮，并且需要返回到指定的URL调用下面方法：
 LEIapp.onback(["backurl"]);
 */
- (void)onback:(CDVInvokedUrlCommand*)command
{
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"onback"]) {
        NSNotification *notificattion = [[NSNotification alloc]initWithName:[command.arguments objectAtIndex:0] object:nil userInfo:nil];
        [super handleOpenURL:notificattion];
    }
}
/*
 前进：
 LEIapp.forward
 */
- (void)forward:(CDVInvokedUrlCommand*)command
{
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"forward"]) {
        [self.webView goForward];
    }
}
#pragma mark Course methods
/*
 录音列表：
 Course.responselist
 参数1：courseID
 参数2：lessonIndex
 参数3：sectionIndex
 回调页面：callback([{"count":5,"text":"hello"},{"count":5,"text":"world"}..])
 */
- (void)responselist:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString *count;
    NSString *text;
//    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"responselist"]) {
        if (command.arguments.count) {
            NSString *courseID= [command.arguments objectAtIndex:0];
//            Course * course = UserDefault(nil,[NSString stringWithFormat:@"course_%@", courseID]);
//            Course * course = [Course getCourseFromDicWithKey:[NSString stringWithFormat:@"%@",courseID]];
//            NSInteger interge=(NSInteger)[command.arguments objectAtIndex:1];
//            Lesson *lesson=[course.lessons objectAtIndex:interge];
//            LessonSection *section=[lesson.sections objectAtIndex:(NSInteger)[command.arguments objectAtIndex:2]];
//            count =[NSString stringWithFormat:@"%ld", section.recordCount];
//            NSArray *items = section.items;
//            for (LessonLEIAudioResponse *response in items) {
//                if (response.text==nil||[response.text isEqualToString: @""]) {
//                    text = response.prototype;
//                }else
//                    text = response.text;
//            }
        }
    }
//    NSArray *backarray = [NSArray arrayWithObjects:count,text,nil];
//    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:backarray];
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
/*
 获取当前选择班级、课程、单元：
 Course.getClassCourseLesson
 回调：callback({"courseID":"2451", "classID":123, "lessonIndex":1,"year":2015})
 
 */
- (void)getClassCourseLesson:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
//    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    if ([method isEqualToString:@"getClassCourseLesson"]) {
        PathsClicked *paths=[PathsClicked getPath:nil];
        
        NSDictionary *dic =  [[NSDictionary alloc]initWithObjectsAndKeys:paths.courseID,@"courseID", paths.classID,@"classID",paths.lessonIndex, @"lessonIndex",paths.year,@"year", nil];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

/*
 设置当前选择班级、课程、单元、年份：
 Course.setClassCourseLesson(["courseID", 班级ID, 单元索引, year]);  //"2451", 1234, 0, 2013
 */
- (void)setClassCourseLesson:(CDVInvokedUrlCommand*)command
{
    PathsClicked *paths = [[PathsClicked alloc]init];
    paths.courseID = [command.arguments objectAtIndex:0];
    paths.classID  = [command.arguments objectAtIndex:1];
    paths.lessonIndex = [command.arguments objectAtIndex:2];
    paths.year     = [command.arguments objectAtIndex:3];
    [PathsClicked getPath:paths];
    
    UserNameDefault([NSDictionary dictionaryWithObjectsAndKeys:paths.courseID,@"courseID",paths.classID,@"classID",paths.lessonIndex,@"lessonIndex",paths.year,@"year", nil],[NSString stringWithFormat:@"setClassCourseLesson_%@",setUserID(nil)], @"setClassCourseLesson") ;
}


#pragma AVPlayer
/*
 播放音频文件：
 Course.play(['filePath']);
 成功回调:callback({"total_duration":1974,"status":2,"duration":1718});  //status：1=准备好播放，2=播放中，3=播放完
 失败回调:callback("播放失败")
 前端js方法：audioPlaying({"total_duration":1974,"status":2,"duration":1718})
 前端js方法：audioStoped({"status":3});//播放完
 */
- (void)play:(CDVInvokedUrlCommand*)command
{
    //    NSString* echo = [command.arguments objectAtIndex:0];
    if (!timer) {
        timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }else
        timer.fireDate=[NSDate distantPast];//恢复定时器
    NSLog(@"音频下载地址：%@",[command.arguments objectAtIndex:0]);
//    [Post downloadFileWithURLString:[command.arguments objectAtIndex:0] Block:^(id result, NSError *error) {
//        if (result) {
//
//            NSString *urlStr=result;
//            NSLog(@"音频播放地址：%@",urlStr);
//
//            NSURL *url=[NSURL fileURLWithPath:urlStr];
//            NSError *error=nil;
//            
//            //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
//            audioPlayer=nil;
//            audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
//            //设置播放器属性
//            audioPlayer.numberOfLoops=0;//设置为0不循环
//            audioPlayer.delegate=self;
//            [audioPlayer prepareToPlay];//加载音频文件到缓存
//            if(error){
//                NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
//                return ;
//            }
//            
//            if ([audioPlayer isPlaying]) {
//                [audioPlayer play];
//            }
//            [audioPlayer play];
//            NSString *duration=[NSString stringWithFormat:@"%f",audioPlayer.duration];
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:duration,@"total_duration",@"2",@"status",audioPlayer.currentTime,@"duration", nil];
//            CDVPluginResult* pluginResult = nil;
//            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
//            
//            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//
//        }
//        else
//        {
//            CDVPluginResult* pluginResult = nil;
//            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"播放失败"];
//            
//            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//            
//        }
//    }];
    
    
}
-(void)updateProgress{

    if(timer)
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"audioPlaying({total_duration:%f,status:2,duration:%f});",audioPlayer.duration,audioPlayer.currentTime]];
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
//    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    pauseBool=YES;
    if ([method isEqualToString:@"pause"]) {
        if ([audioPlayer isPlaying]) {
            [audioPlayer pause];
            timer.fireDate=[NSDate distantFuture];//暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复

        }
    }
}

- (void)stop:(CDVInvokedUrlCommand*)command
{
    if ([audioPlayer isPlaying]) {
        [audioPlayer stop];
        [timer setFireDate:[NSDate distantFuture]];
    }
    [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:audioStoped({status:3});"];
    [audioPlayer stop];
}

#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成...");
    
    //根据实际情况播放完成可以将会话关闭，其他音频应用继续播放
    [[AVAudioSession sharedInstance]setActive:NO error:nil];
    [timer setFireDate:[NSDate distantFuture]];
    [self.webView stringByEvaluatingJavaScriptFromString:@"javascript:audioStoped({status:3})"];
}

/*
 获取上次选择：（电脑/手机进度）
 Course.device()
 回调：callback(1/非1); //1手机端
 设置选择：
 Course.device(1/0);//1手机端
 */
- (void)device:(CDVInvokedUrlCommand*)command
{
    //这里需要一个回调 回调：callback(1/非1); //1手机端
    CDVPluginResult* pluginResult = nil;
//    NSString* echo = [command.arguments objectAtIndex:0];
    NSString* method = command.methodName;
    NSString *backString;
    PathsClicked *paths=[PathsClicked getPath:nil];
    if ([method isEqualToString:@"device"]) {
        //退出webcontroller add  by lf
        if (command.arguments.count) {
            UserDefault([command.arguments objectAtIndex:0], [NSString stringWithFormat:@"device%@%@",paths.courseID,paths.lessonIndex]);
            backString =[command.arguments objectAtIndex:0];
        }else{
            if (UserDefault(nil, [NSString stringWithFormat:@"device%@%@",paths.courseID,paths.lessonIndex])) {
               backString= UserDefault(nil, [NSString stringWithFormat:@"device%@%@",paths.courseID,paths.lessonIndex]);
            }
            else
                backString=@"0";
        }
    }
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:backString];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark User methods
/*
 获取用户信息：
 User.getUser
 回调：callback({"userID":123, "loginName":"xxx", "name":"xx", "telphone":"", "email":"", "token":"", "sex":true});
 */
- (void)getUser:(CDVInvokedUrlCommand*)command
{
    NSLog(@"assadsfdf");

    CDVPluginResult* pluginResult = nil;
    NSString* method = command.methodName;
    
    if ([method isEqualToString:@"getUser"]) {
        LEAccount* account = [LEAccountService sharedService].account;
        BOOL sexbool = ((LEUserSexType)account.sex>0)?true:false;
        NSString * loginname = UserDefault(nil, @"loginname");
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:setUserID(nil),@"userID",loginname,@"loginName",account.userName,@"name",account.phone, @"telphone", account.email ,@"email",account.token,@"token",sexbool,@"sex", nil];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
-(void)sendMsg:(CDVInvokedUrlCommand*)command
{
    NSString *chatter = [NSString stringWithFormat:@"%@",[command.arguments objectAtIndex:0]];
    NSDictionary *dicper  = UserNameDefault(nil,[NSString stringWithFormat:@"usersID_userID%@",setUserID(nil)], @"userIDs");
//    [[EaseMob sharedInstance].chatManager conversationForChatter:chatter conversationType:eConversationTypeChat];
//    ChatViewController *chatController = [[ChatViewController alloc]initWithChatter:chatter  conversationType:eConversationTypeChat];
//    [[RobotManager sharedInstance] addRobotsToMemory:[NSArray arrayWithObject:[[dicper objectForKey:chatter] objectForKey:@"name"]]];
//    chatController.title = [[dicper objectForKey:chatter] objectForKey:@"name"];
//    [[MKMessage shareMessage]postotification:chatController name:NOTIFY_MESSAGECHATVIEW];
}

-(void)findpwd:(CDVInvokedUrlCommand*)command
{
    [[MKMessage shareMessage] postotification:nil name:NOTIFY_WEBFINISH];
//    SHOWHUD([command.arguments objectAtIndex:0]);
}

@end
