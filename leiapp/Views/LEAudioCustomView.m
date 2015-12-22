//
//  LEAudioCustomView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/30/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEAudioCustomView.h"
#import <AVFoundation/AVFoundation.h>
#import "iflyMSC/IFlySpeechEvaluator.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "lame.h"
#import "ISEResult.h"
#import "ISEResultXmlParser.h"
#import "IFlyMSC/IFlyMSC.h"
#import "LEDefines.h"
#import "LEConstants.h"
#import "LECourseLessonSectionItemView.h"
#import "AFNetworkReachabilityManager.h"
#import "LECourseLessonSectionItemLEIAudioResponseItemView.h"
#import "MobClick.h"

#define kAudioRecordDurationWarn 15
#define kAudioRecordDurationStop 3
#define kAudioRecordDurationMin  2
//static BOOL isEvaluating;
@interface LEAudioCustomView () <AVAudioPlayerDelegate, AVAudioRecorderDelegate, IFlySpeechEvaluatorDelegate, ISEResultXmlParserDelegate>

@property (nonatomic, strong) AVAudioPlayer* audioPlayer;
@property (nonatomic, assign) NSTimeInterval audioPlayerCurrentTime;
@property (nonatomic, strong) NSTimer* audioPlayerProgressTimer;

@property (nonatomic, strong) AVAudioPlayer* recordPlayer;
@property (nonatomic, assign) NSTimeInterval recordPlayerCurrentTime;
@property (nonatomic, strong) NSTimer* recordPlayerProgressTimer;

@property (nonatomic, strong) AVAudioRecorder* audioRecorder;
@property (nonatomic, strong) NSTimer* raudioRecorderMeteringTimer;
@property (nonatomic, strong) NSTimer* raudioRecorderWarningTimer;
@property (nonatomic, assign) int audioRecordSilientCount;
//@property (nonatomic, readonly) BOOL isEvaluating;

@property (nonatomic, strong) IFlySpeechEvaluator *speechEvaluator;

-(void)updateAudioPlayerProgress:(NSTimer *)timer;
-(void)updateRecordPlayerProgress:(NSTimer *)timer;
-(void)updateAudioRecorderMetering:(NSTimer *)timer;
-(void)performAudioRecorderWarn:(NSTimer *)timer;
-(void)performAudioRecorderStop:(NSTimer *)timer;
-(void)convertToMp3:(NSString*)pcmPath to:(NSString*)mp3Path;
@end

@implementation LEAudioCustomView

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopAudioRecord) name:kLENotificationApplicationWillResignActive object:nil];
    _shouldAudioRecordSmartStop = NO;
    _audioRecordSilientCount = 0;
    _audioRecordDuration = kAudioRecordDurationWarn;
    _audioRecordWarnDuration = kAudioRecordDurationStop;
    _shouldAudioRecordWarnStop = YES;
}
- (void) dealloc{
    if (self.speechEvaluator) {
        self.speechEvaluator.delegate = nil;
    }
    [self stopAudioEvaluate];
    [self stopAudioRecord];
}
- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            __block BOOL requestSuccessed = NO;
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                requestSuccessed = YES;
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                }
            }];
            if (!requestSuccessed) {
                bCanRecord = NO;
            }
        }
    }
    
    return bCanRecord;
}
-(BOOL)isAudioPlaying {
    return (self.audioPlayer && self.audioPlayer.isPlaying);
}

-(BOOL)isAudioPaused {
    return (self.audioPlayer && !self.audioPlayer.isPlaying);
}

-(void)startAudioPlay{
    if ([self isAudioPlaying]) {
        return;
    }
    
    NSError* error;
    NSURL* url = [NSURL fileURLWithPath:self.audioPlayPath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error == nil) {
        self.audioPlayer.delegate=self;
        self.audioPlayer.volume= 0.5;
        [self.audioPlayer prepareToPlay];
        self.audioPlayerCurrentTime = 0;
        self.audioPlayerProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateAudioPlayerProgress:) userInfo:nil repeats:YES];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [self.audioPlayer play];
        [self didAudioPlayStart];
    } else {
        [self didAudioPlayStopped];
    }
}

-(void)stopAudioPlay{
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        [self.audioPlayerProgressTimer invalidate];
        self.audioPlayerProgressTimer = nil;
        self.audioPlayer.delegate = nil;
        self.audioPlayer = nil;
        self.audioPlayerCurrentTime = 0;
        [self didAudioPlayStopped];
    }
}

-(void)pauseAudioPlay{
    if ([self isAudioPlaying]) {
        [self.audioPlayer pause];
        [self.audioPlayerProgressTimer invalidate];
        self.audioPlayerProgressTimer = nil;
        [self didAudioPlayPaused];
    }
}

-(void)resumeAudioPlay{
    if ([self isAudioPaused]) {
        [self.audioPlayer play];
        self.audioPlayerProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateAudioPlayerProgress:) userInfo:nil repeats:YES];
        [self didAudioPlayResumed];
    }
}

-(void)updateAudioPlayerProgress:(NSTimer *)timer {
    //    if (self.audioPlayerCurrentTime < self.audioPlayer.currentTime) {
    self.audioPlayerCurrentTime = self.audioPlayer.currentTime;
    //    } else {
    //        self.audioPlayerCurrentTime = self.audioPlayer.duration;
    //    }
    NSLog(@"当前进度：%f,%f", self.audioPlayer.currentTime, self.audioPlayer.duration);
    CGFloat percentage = self.audioPlayerCurrentTime / self.audioPlayer.duration;
    NSTimeInterval remainingTime = self.audioPlayer.duration - self.audioPlayerCurrentTime;
    [self didAudioPlayUpdate:percentage remainingTime:remainingTime];
}

-(BOOL)isRecordPlaying {
    return (self.recordPlayer && self.recordPlayer.isPlaying);
}

-(void)startRecordPlay{
    if ([self isRecordPlaying]) {
        return;
    }
    if(![self canRecord]){
        SHOWHUD(@"录音权限被禁止");
        return;
    }
    
    NSError* error;
    NSURL* url = [NSURL fileURLWithPath:self.audioRecordPath];
    self.recordPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.recordPlayer.delegate=self;
    self.recordPlayer.volume= 0.5;
    self.recordPlayerCurrentTime = 0;
    [self.recordPlayer prepareToPlay];
    self.recordPlayerProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateRecordPlayerProgress:) userInfo:nil repeats:YES];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.recordPlayer play];
    [self didRecordPlayStart];
}

-(void)stopRecordPlay{
    if (self.recordPlayer) {
        [self.recordPlayer pause];
        [self.recordPlayerProgressTimer invalidate];
        self.recordPlayerProgressTimer = nil;
        self.recordPlayer.delegate = nil;
        self.recordPlayer = nil;
        self.recordPlayerCurrentTime = 0;
        [self didRecordPlayStopped];
    }
}

-(BOOL)isRecordPlayPaused {
    return (self.recordPlayer && !self.recordPlayer.isPlaying);
}

-(void)pauseRecordPlay {
    if ([self isRecordPlaying]) {
        [self.recordPlayer pause];
        [self.recordPlayerProgressTimer invalidate];
        self.recordPlayerProgressTimer = nil;
        [self didRecordPlayPaused];
    }
}

-(void)resumeRecordPlay {
    if ([self isRecordPlayPaused]) {
        [self.recordPlayer play];
        self.recordPlayerProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateRecordPlayerProgress:) userInfo:nil repeats:YES];
        [self didRecordPlayResumed];
    }
}

-(BOOL)hasAudioRecord {
    NSError* error;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.audioRecordPath error:&error];
    if (!error) {
        NSNumber *number = [fileAttributes objectForKey:NSFileSize];
        return [number longLongValue] > 0;
    }
    return NO;
}

-(BOOL)isAudioEvaluating {
//    IFlySpeechEvaluator* evaluator = [IFlySpeechEvaluator sharedInstance];
//    if (evaluator.delegate) {
//        return true;
//    }
//    return self.speechEvaluator != nil && self.speechEvaluator.delegate;
    NSLog(@"%@-%d", self.audioEvaluateScript, isEvaluating);
    return isEvaluating;
}

-(void)startAudioEvaluate {
    if ([self isAudioEvaluating]) {
        return;
    }
    
    //无网，启动不评分录音
    int type = 1;
    if ([self isKindOfClass:[LECourseLessonSectionItemLEIAudioResponseItemView class]]) {
        type = [((LECourseLessonSectionItemLEIAudioResponseItemView*)self).response.type intValue];
    }
    if (type == 9 || ![AFNetworkReachabilityManager sharedManager].isReachable) {
        //评分文件路径动态生成，录音加mp3后缀会导致不能正常录音
        //存绝对路径会变
        self.audioEvaluatePath = [LECourseLessonSectionItemView pathForAsset:[LECourseLessonSectionItemView generateAudioPath]];
        self.audioEvaluatePath = [NSString stringWithFormat:@"%@", self.audioEvaluatePath];
        NSLog(@"无网");
        self.audioRecordPath = nil;
        [self startAudioRecord];
        return;
    }
    
    self.audioEvaluatePath = [LECourseLessonSectionItemView pathForAsset:[LECourseLessonSectionItemView generateAudioPath]];
    self.audioEvaluatePath = [NSString stringWithFormat:@"%@", self.audioEvaluatePath];
    
    self.speechEvaluator = [IFlySpeechEvaluator sharedInstance];
    self.speechEvaluator.delegate = self;
    [self.speechEvaluator setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    [self.speechEvaluator setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [self.speechEvaluator setParameter:@"xml" forKey:[IFlySpeechConstant ISE_RESULT_TYPE]];
    [self.speechEvaluator setParameter:@"5000" forKey:[IFlySpeechConstant VAD_BOS]];
    [self.speechEvaluator setParameter:@"1800" forKey:[IFlySpeechConstant VAD_EOS]];
    [self.speechEvaluator setParameter:@"read_sentence" forKey:[IFlySpeechConstant ISE_CATEGORY]];
    [self.speechEvaluator setParameter:@"en_us" forKey:[IFlySpeechConstant LANGUAGE]];
    [self.speechEvaluator setParameter:@"complete" forKey:[IFlySpeechConstant ISE_RESULT_LEVEL]];
    [self.speechEvaluator setParameter:@"-1" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
    //友盟事件记录，录音练习评分
    [MobClick event:@"SpeechEvaluator"];
    isEvaluating = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onBeginOfSpeech" object:nil];
    [self.speechEvaluator setParameter:self.audioEvaluatePath forKey:[IFlySpeechConstant ISE_AUDIO_PATH]];
    NSMutableData *buffer= [NSMutableData dataWithData:[self.audioEvaluateScript dataUsingEncoding:NSUTF8StringEncoding]];
    [self.speechEvaluator startListening:buffer params:nil];
}
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
-(void)stopAudioEvaluate {
    if (self.speechEvaluator) {
        @try {
            [self.speechEvaluator stopListening];
        }
        @catch (NSException *exception) {
            isEvaluating = NO;
        }
        @finally {
            
        }

//        self.speechEvaluator.delegate = nil;
//        self.speechEvaluator = nil;
    }else{
        if (self.audioRecordPath) {
            return;
        }
        if([self fileSizeAtPath:self.audioEvaluatePath] > 0){
            NSMutableString* str = [NSMutableString stringWithString:self.audioEvaluatePath];
            NSRange range = [str rangeOfString:@".mp3"];
            if (range.length <= 0) {
                self.audioEvaluatePath = str;
                [self transformCAFToMP3];
            }
        }
        
        [self stopAudioRecord];
    }
}

-(BOOL)hasAudioEvaluate {
    NSError* error;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.audioEvaluatePath error:&error];
    if (!error) {
        NSNumber *number = [fileAttributes objectForKey:NSFileSize];
        return [number longLongValue] > 0;
    }
    return NO;
}

-(void)updateRecordPlayerProgress:(NSTimer *)timer {
    if (self.recordPlayerCurrentTime < self.recordPlayer.currentTime) {
        self.recordPlayerCurrentTime = self.recordPlayer.currentTime;
    } else {
        self.recordPlayerCurrentTime = self.recordPlayer.duration;
    }
    CGFloat percentage = self.recordPlayerCurrentTime / self.recordPlayer.duration;
    if (percentage >= 0.95) {
        percentage = 1.0;
    }
    [self didRecordPlayUpdate:percentage];
}

-(BOOL)isAudioRecording {
    return (self.audioRecorder && self.audioRecorder.isRecording);
}

-(void)startAudioRecord {
    if ([self isAudioRecording]) {
        return;
    }
    
    NSMutableDictionary* recordSetting = [NSMutableDictionary new];
    //    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithInt:44100] forKey:AVSampleRateKey];
    if (self.audioEvaluatePath) {
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    }else{
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    }
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSURL* url = nil;
    if (self.audioEvaluatePath) {//不评分录音
        url = [NSURL fileURLWithPath:self.audioEvaluatePath];
    }else{
        url = [NSURL fileURLWithPath:self.audioRecordPath];
    }
    
    NSError* error;
   
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    self.audioRecorder.meteringEnabled = YES;
    self.audioRecorder.delegate = self;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    self.audioRecordSilientCount = 0;
    
    if ([self.audioRecorder prepareToRecord]) {
        [self.audioRecorder record];
        self.raudioRecorderMeteringTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateAudioRecorderMetering:) userInfo:nil repeats:YES];
        
        
        int interval = self.shouldAudioRecordWarnStop ? (self.audioRecordDuration - self.audioRecordWarnDuration) : self.audioRecordDuration;
        
        if (interval < kAudioRecordDurationMin) {
            interval = kAudioRecordDurationMin;
        }
        if (self.audioEvaluatePath) {//不评分录音
            
        }else if (self.shouldAudioRecordWarnStop) {
            self.raudioRecorderWarningTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(performAudioRecorderWarn:) userInfo:nil repeats:NO];
        } else {
            self.raudioRecorderWarningTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(performAudioRecorderStop:) userInfo:nil repeats:NO];
        }
        
        [self didAudioRecordStart];
    } else {
        [self stopAudioRecord];
    }
}

-(void)stopAudioRecord {
    if (self.audioRecorder) {
        [self.audioRecorder stop];
        [self.raudioRecorderMeteringTimer invalidate];
        self.raudioRecorderMeteringTimer = nil;
        [self.raudioRecorderWarningTimer invalidate];
        self.raudioRecorderWarningTimer = nil;
        self.audioRecorder.delegate = nil;
        self.audioRecorder = nil;
        [self didAudioRecordStopped];
    }
}
//录音音量计算
-(void)updateAudioRecorderMetering:(NSTimer *)timer {
    [self.audioRecorder updateMeters];
    float power = [self.audioRecorder averagePowerForChannel:0];
    float max = 0;
    float min = -70;
    
    double percentage = (power - min)/(max-min);
    [self didAudioRecordUpdate:percentage];
    if (self.audioEvaluatePath) {
        return;
    }
    if (self.shouldAudioRecordSmartStop) {
        if ((power - min) <= 10) {
            self.audioRecordSilientCount += 1;
        } else {
            self.audioRecordSilientCount = 0;
        }
        if (self.audioRecordSilientCount >= 30) {
            [self stopAudioRecord];
        }
    }
}

-(void)performAudioRecorderWarn:(NSTimer *)timer {
    self.raudioRecorderWarningTimer = [NSTimer scheduledTimerWithTimeInterval:self.audioRecordWarnDuration target:self selector:@selector(performAudioRecorderStop:) userInfo:nil repeats:YES];
    [self didAudioRecordWarned];
}

-(void)performAudioRecorderStop:(NSTimer *)timer {
    [self stopAudioRecord];
}

-(void)convertToMp3:(NSString*)pcmPath to:(NSString*)mp3Path {
    if ([self fileSizeAtPath:pcmPath] <= 0) {
        return;
    }
    int read, write;
    
    //    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:pcmPath];
    FILE *pcm = fopen([pcmPath cStringUsingEncoding:1], "rb");
    FILE *mp3 = fopen([mp3Path cStringUsingEncoding:1], "wb");
    
    const int PCM_SIZE = 8192;
    const int MP3_SIZE = 8192;
    
    short int pcm_buffer[PCM_SIZE*2];
    
    unsigned char mp3_buffer[MP3_SIZE];
    
    lame_t lame = lame_init();
    
    lame_set_in_samplerate(lame, 8000);
    
    lame_set_VBR(lame, vbr_default);
    
    lame_init_params(lame);
    
    do {
        read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
        if (read == 0) {
            write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
        } else {
            write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
        }
        fwrite(mp3_buffer, write, 1, mp3);
        
    } while (read != 0);
    
    lame_close(lame);
    
    fclose(mp3);
    fclose(pcm);
}

- (void)transformCAFToMP3 {
    if ([self fileSizeAtPath:self.audioEvaluatePath] <= 0) {
        return;
    }
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    @try {
        int read, write;
        NSString* tempAudioEvaluatePath = [NSString stringWithFormat:@"%@.mp3", self.audioEvaluatePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        [fileManager copyItemAtPath:self.audioEvaluatePath toPath:tempAudioEvaluatePath error:&error];
        
        FILE *pcm = fopen([self.audioEvaluatePath cStringUsingEncoding:1], "rb");   //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                                   //skip file header
        FILE *mp3 = fopen([tempAudioEvaluatePath cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
        [fileManager removeItemAtPath:self.audioEvaluatePath error:&error];
        self.audioEvaluatePath = tempAudioEvaluatePath;
        self.audioRecordPath = tempAudioEvaluatePath;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"转mp3格式成功!!!!!");
    }
    
    //    });
}

-(void)didAudioPlayStart {}
-(void)didAudioPlayStopped {}
-(void)didAudioPlayPaused {}
-(void)didAudioPlayResumed {}
-(void)didAudioPlayUpdate:(CGFloat)percentage {}
-(void)didAudioPlayUpdate:(CGFloat)percentage remainingTime:(NSTimeInterval)remainingTime {}

-(void)didAudioRecordStart {}
-(void)didAudioRecordStopped {}
-(void)didAudioRecordWarned {}
-(void)didAudioRecordUpdate:(CGFloat)percentage {}

-(void)didRecordPlayStart {}
-(void)didRecordPlayStopped {}
-(void)didRecordPlayPaused {}
-(void)didRecordPlayResumed {}
-(void)didRecordPlayUpdate:(CGFloat)percentage {}

-(void)didAudioEvaluateStart {}
-(void)didAudioEvaluateStopped {}
-(void)didAudioEvaluateUpdate:(CGFloat)percentage {}
-(void)didAudioEvaluateScored:(CGFloat)score {}

#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (player == self.audioPlayer) {
        [self stopAudioPlay];
    } else if (player == self.recordPlayer){
        [self stopRecordPlay];
    }
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    if (player == self.audioPlayer) {
        [self stopAudioPlay];
    } else if (player == self.recordPlayer){
        [self stopRecordPlay];
    }
}


#pragma mark AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [self stopAudioRecord];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    [self stopAudioRecord];
}



#pragma mark - IFlySpeechEvaluatorDelegate
- (void)onVolumeChanged:(int)volume buffer:(NSData *)buffer {
    float max = 100;
    float min = 0;
    double percentage = (volume - min)/(max-min);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:self.audioEvaluatePath]) {
        [buffer writeToFile:self.audioEvaluatePath options:NSDataWritingAtomic error:nil];
    } else {
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForWritingAtPath:self.audioEvaluatePath];
        [fileHandler seekToEndOfFile];
        [fileHandler writeData:buffer];
    }
    
    [self didAudioRecordUpdate:percentage];
}

- (void)onBeginOfSpeech {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onBeginOfSpeech" object:nil];
    [self didAudioEvaluateStart];
}

- (void)onEndOfSpeech {
    NSString* tempAudioEvaluatePath = [NSString stringWithFormat:@"%@.mp3", self.audioEvaluatePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager copyItemAtPath:self.audioEvaluatePath toPath:tempAudioEvaluatePath error:&error];
    //    [fileManager removeItemAtPath:self.audioEvaluatePath error:&error];
    [self convertToMp3:self.audioEvaluatePath to:tempAudioEvaluatePath];
    [fileManager removeItemAtPath:self.audioEvaluatePath error:&error];
    //删除上一次的录音文件
    BOOL isDocuments = NO;
    if (self.audioRecordPath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([self.audioRecordPath isEqualToString:[paths lastObject]]) {
            isDocuments = YES;
        }
    }
    
    if (!isDocuments && [fileManager fileExistsAtPath:self.audioRecordPath]) {
        [fileManager removeItemAtPath:self.audioRecordPath error:&error];
    }
    self.audioEvaluatePath = tempAudioEvaluatePath;
    self.audioRecordPath = tempAudioEvaluatePath;
    isEvaluating = NO;
    [self didAudioEvaluateStopped];
    
    //评分结束才允许离开当前页面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onEndOfSpeech" object:nil];
}

- (void)onCancel {
    [self didAudioEvaluateStopped];
}

- (void)onError:(IFlySpeechError *)errorCode {
    if(errorCode && errorCode.errorCode!=0){
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        NSString* errMsg = [NSString stringWithFormat:@"错误码：%@，评分内容：%@", [NSNumber numberWithInt:errorCode.errorCode], self.audioEvaluateScript];
        [dic setValue:errMsg forKey:@"errorDesc"];
        [dic setValue:[NSString stringWithFormat:@"%d", errorCode.errorCode] forKey:@"errorCode"];
        [MobClick event:@"SpeechEvaluator_EVENT_ID_START_FAIL" attributes:dic];
        if (self.speechEvaluator) {
            self.speechEvaluator.delegate = nil;
            self.speechEvaluator = nil;
        }
        isEvaluating = NO;
        //评测失败，但累计次数，分数不变。是否要变待确认？
    }
    //    NSLog(@"%@", errorCode);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onEndOfSpeech" object:nil];
}
- (void)onResults:(NSData *)data isLast:(BOOL)isLast{
    if (data) {
        NSString* result=[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        ISEResultXmlParser* parser=[[ISEResultXmlParser alloc] init];
        if (self) {
            parser.delegate=self;
            [parser parserXml:result];
        }
        
    }
}

#pragma mark - ISEResultXmlParserDelegate

-(void)onISEResultXmlParser:(NSXMLParser *)parser Error:(NSError*)error{
    
}

-(void)onISEResultXmlParserResult:(ISEResult*)result{
    if (self.speechEvaluator) {
        self.speechEvaluator.delegate = nil;
        self.speechEvaluator = nil;
    }
//    NSLog(@"onISEResultXmlParserResult %@", [result toString]);
    [self didAudioEvaluateScored:result.total_score];
}

@end
