//
//  LECourseLessonSectionItemLEIAudioResponseItemView.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/27/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSectionItemLEIAudioResponseItemView.h"
#import "LEProgressImageButton.h"
#import "LECourseLessonLEIAudioResponse.h"
#import "LEDefines.h"
#import "LECourseLessonSectionItemView.h"
#import "NSString+Addition.h"
#import <AVFoundation/AVFoundation.h>
#import "RTLabel.h"
#import "LECourseService.h"
#import "LECourse.h"
#define kHeight          80
#define kHeightExpanded  150

@interface LECourseLessonSectionItemLEIAudioResponseItemView()
{
    LECourse *course;
}
@property (strong, nonatomic) IBOutlet RTLabel *titleLabel;
@property (strong, nonatomic) IBOutlet LEProgressImageButton *voiceImageButton;
@property (strong, nonatomic) IBOutlet LEProgressImageButton *recordImageButton;
@property (strong, nonatomic) IBOutlet LEProgressImageButton *playImageButton;
@property (strong, nonatomic) IBOutlet UIView *dashboardView;
@property (strong, nonatomic) IBOutlet UIView *performanceView;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameView;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UIImageView *finishImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTrailingConstraint;
- (IBAction)handleTabGesture:(UITapGestureRecognizer*)recognizer;

@property (strong, nonatomic) NSString* words;
@property (strong, nonatomic) NSString* instructions;

- (void)updateImageButtonStatus;
- (void)updateLabelDisplay;
@end

@implementation LECourseLessonSectionItemLEIAudioResponseItemView

- (void)setResponse:(LECourseLessonLEIAudioResponse *)response {
    _response = response;
    self.audioPlayPath = [LECourseLessonSectionItemView pathForAsset:self.response.audio];
    if (!self.response.record || [response.record isEmptyOrWhitespace]) {
        self.response.record = [LECourseLessonSectionItemView generateAudioPath];
    }
    //本地是否有录音文件
    if (self.audioRecord.filePath) {
        NSString* audioPath = [[self.audioRecord.filePath componentsSeparatedByString:@"/"] lastObject];
        self.audioRecord.filePath = [NSString stringWithFormat:@"%@/%@", [LECourseLessonSectionItemView pathForAsset:[LECourseLessonSectionItemView audioPath]], audioPath];
    }
    if ([LECourseLessonSectionItemView existAssetPath:self.audioRecord.filePath]) {
        self.audioRecordPath = [LECourseLessonSectionItemView pathForAsset:self.audioRecord.filePath];
        self.audioEvaluatePath = [LECourseLessonSectionItemView pathForAsset:self.audioRecord.filePath];
    }else if (self.audioRecord.mediaUrl){//网络是否有录音文件
        NSString* remoteFilePath = [NSString stringWithFormat:@"%@/%@",@"http://leicloud.qiniudn.com/",self.audioRecord.mediaUrl];
        self.audioRecordPath = remoteFilePath;
        self.audioEvaluatePath = remoteFilePath;
    }else{
        self.audioRecordPath = nil;//[LECourseLessonSectionItemView pathForAsset:self.audioRecord.filePath];
        self.audioEvaluatePath = nil;//[LECourseLessonSectionItemView pathForAsset:self.audioRecord.filePath];
    }


//    NSError *error = nil;
//    NSRegularExpression *regex = [NSRegularExpression
//                                  regularExpressionWithPattern:@"^[a-zA-Z:;()'’\"\\s-?!.,]*"
//                                  options:0
//                                  error:&error];
//    NSRange range = [regex rangeOfFirstMatchInString:self.response.text
//                                               options:0
//                                                 range:NSMakeRange(0, [self.response.text length])];

//    self.words  = [[self.response.text substringWithRange:range] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    self.instructions = [[self.response.text substringWithRange:NSMakeRange(range.length + range.location, [self.response.text length] - range.length)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    self.audioEvaluateScript = self.words;
    
    self.words = self.response.text;

    self.audioEvaluateScript = self.response.prototype;
    self.instructions = self.response.prototype;
    
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:self.audioPlayPath ] options:nil];
    NSTimeInterval audioDuration =  CMTimeGetSeconds(audioAsset.duration);
    self.audioRecordDuration = audioDuration;
    self.shouldAudioRecordWarnStop = NO;
    [self updateImageButtonStatus];
    [self updateLabelDisplay];
}

- (void)reset {
    if (self.audioRecordPath) {
//        [LECourseLessonSectionItemView destroyAssetPath:self.audioRecordPath];
        self.audioRecordPath = nil;
        self.response.record = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _expanded = NO;
     self.backgroundColor = [UIColor whiteColor];
    
    self.voiceImageButton.image = [UIImage imageNamed:@"courselesson_sectionpageview_voice_normal"];
    self.voiceImageButton.highlightedImage = [UIImage imageNamed:@"courselesson_sectionpageview_voice_highlight"];
    
    self.recordImageButton.image = [UIImage imageNamed:@"courselesson_sectionpageview_record_normal"];
    self.recordImageButton.highlightedImage = [UIImage imageNamed:@"courselesson_sectionpageview_record_highlight"];
    
    self.playImageButton.image = [UIImage imageNamed:@"courselesson_sectionpageview_record_play_normal"];
    self.playImageButton.highlightedImage = [UIImage imageNamed:@"courselesson_sectionpageview_record_pause_highlight"];
    
    [self.voiceImageButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    [self.recordImageButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    [self.playImageButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    
    self.performanceView.layer.cornerRadius = 20;
    
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.clipsToBounds = YES;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTabGesture:)];
    
    [self addGestureRecognizer:tapGestureRecognizer];
//    tapGestureRecognizer.delegate = self;
    
}

- (void)setExpanded:(BOOL)expanded {
    if (_expanded != expanded) {
        _expanded = expanded;
        if (!_expanded) {
            if ([self isAudioPlaying]) {
                [self stopAudioPlay];
            }
            if ([self isAudioRecording]) {
                [self stopAudioRecord];
            }
            if ([self isRecordPlaying]) {
                [self stopRecordPlay];
            }
            if ([self isAudioEvaluating]) {
                [self stopAudioEvaluate];
            }
            if (!expanded) {
                self.recordImageButton.selected = NO;
            }
        }
        
        UIColor* color = _expanded ? UIColorFromRGB(0xf3f3f3) : [UIColor whiteColor];
        self.backgroundColor = color;
    }
}

- (CGFloat)heightForReponse:(BOOL)expanded {
    if (self.viewHeight == 0) {
        self.viewHeight = kHeight;
    }
    if (self.viewHeightExpanded == 0) {
        self.viewHeightExpanded = self.viewHeight + 70;
    }
//    NSLog(@"viewHeight=%d", self.viewHeight);
//    NSLog(@"viewHeightExpanded=%d", self.viewHeightExpanded);
    return expanded ? self.viewHeightExpanded : self.viewHeight;
//    return expanded ? kHeightExpanded : height;
}

- (void)willRemoveSubview:(UIView *)subview {
    [self.voiceImageButton removeObserver:self forKeyPath:@"selected"];
    [self.recordImageButton removeObserver:self forKeyPath:@"selected"];
    [self.playImageButton removeObserver:self forKeyPath:@"selected"];
    [super willRemoveSubview:subview];
}

#pragma mark LEAudioCustomView Hooks
-(void)didAudioPlayStart {
    [self updateImageButtonStatus];
}

-(void)didAudioPlayStopped {
    self.voiceImageButton.selected = NO;
    [self updateImageButtonStatus];
}

-(void)didAudioPlayUpdate:(CGFloat)percentage remainingTime:(NSTimeInterval)remainingTime{
    self.voiceImageButton.progress = percentage;
}

-(void)didRecordPlayStart {
    [self updateImageButtonStatus];
}

-(void)didRecordPlayStopped {
    self.playImageButton.selected = NO;
    [self updateImageButtonStatus];
}

-(void)didRecordPlayUpdate:(CGFloat)percentage {
    self.playImageButton.progress = percentage;
}

-(void)didAudioRecordStart {
    [self updateImageButtonStatus];
}

- (void)didAudioRecordWarned {
    [UIView animateWithDuration:0.5 delay:0.0
                        options:(UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse)
                     animations:^{
                         [self.recordImageButton setAlpha:0.5];
                     }
                     completion:nil];
}

-(void)didAudioRecordStopped {
    self.audioRecord.recordedCount += 1;
    if ([self.response.type intValue] == 9) {
        self.audioRecord.score = 100;
    }else{
        self.audioRecord.score = 0;
    }
//    [self didAudioEvaluateStopped];
    
    _audioRecord.filePath = self.audioRecordPath;
    self.recordImageButton.selected = NO;
    [self.recordImageButton.layer removeAllAnimations];
    [self.recordImageButton setAlpha:1.0];
    [self updateImageButtonStatus];
    
    self.audioRecord.title = self.response.text;
    self.audioRecord.content = self.response.prototype;
    self.audioRecord.type = self.response.type.intValue;
    [self updateLabelDisplay];
}

-(void)didAudioRecordUpdate:(CGFloat)percentage {
    self.recordImageButton.progress = percentage;
}

-(void)didAudioEvaluateStart {
    [self updateImageButtonStatus];
}

-(void)didAudioEvaluateStopped {
    _audioRecord.filePath = self.audioRecordPath;
    self.recordImageButton.selected = NO;
    [self.recordImageButton.layer removeAllAnimations];
    [self.recordImageButton setAlpha:1.0];
    [self updateImageButtonStatus];
//    if (self.audioRecord.recordedCount < self.response.total) {
    self.audioRecord.recordedCount += 1;
    self.audioRecord.title = self.response.text;
    self.audioRecord.content = self.response.prototype;
    self.audioRecord.type = self.response.type.intValue;
//    self.audioRecord.filePath =
    [self updateLabelDisplay];
//    }
}

-(void)didAudioEvaluateUpdate:(CGFloat)percentage {
    self.recordImageButton.progress = percentage;
}

-(void)didAudioEvaluateScored:(CGFloat)score {
//    self.response.score = score/5.0*100.0;
    self.audioRecord.score = score/5.0*100.0;
    [self updateLabelDisplay];
}

-(void)updateImageButtonStatus {
    if ([self isAudioPlaying]) {
        self.recordImageButton.disabled = YES;
        self.playImageButton.disabled = YES;
    } else if ([self isRecordPlaying]) {
        self.recordImageButton.disabled = YES;
        self.voiceImageButton.disabled = YES;
    } else if ([self isAudioRecording]) {
        self.playImageButton.disabled = YES;
        self.voiceImageButton.disabled = YES;
    } else if ([self isAudioEvaluating]) {
        self.playImageButton.disabled = YES;
        self.voiceImageButton.disabled = YES;
    } else {
        //录音按钮始终可用
        self.recordImageButton.disabled = NO;
        //如果音频资源文件不存在禁用按钮
        if (![LECourseLessonSectionItemView existAssetPath:self.audioPlayPath]) {
            self.voiceImageButton.disabled = YES;
        }else{
            self.voiceImageButton.disabled = NO;
        }
        //如果没有录音文件禁用播放录音文件按钮
        if (![LECourseLessonSectionItemView existAssetPath:self.audioRecordPath] || ![LECourseLessonSectionItemView existAssetPath:self.audioEvaluatePath]) {
            self.playImageButton.disabled = YES;
        }else{
            self.playImageButton.disabled = NO;
        }
//        else {
//            self.playImageButton.disabled = NO;
//            self.recordImageButton.disabled = NO;
//            self.voiceImageButton.disabled = NO;
//        }
    }
}

-(void)updateLabelDisplay {
    if (_audioRecord.recordedCount == 0) {
        _scoreView.hidden = YES;
        _scoreLabel.hidden = YES;
        _nameView.hidden = YES;
    }else{
        _scoreView.hidden = NO;
        _scoreLabel.hidden = NO;
        _nameView.hidden = NO;
    }
    if (!self.instructions || [self.instructions isEmptyOrWhitespace]) {
        self.titleLabel.text = self.words;
//    } else if([[self.words stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:[self.instructions stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
//        self.titleLabel.text = self.words;
    } else if([self.words isEqualToString:self.instructions]){
        self.titleLabel.text = self.words;
    }else {
        //words显示
        //instructions评分内容
        //非评分内容加font标签控制大小
        NSMutableString* str = [NSMutableString stringWithString:self.words];
//        [str replaceCharactersInRange:[str rangeOfString:@""] withString:@"%%"];
        //将要读到内容删除掉，只留非读内容
        NSRange range = [str rangeOfString:self.instructions];
        if (range.length != 0) {
            [str replaceCharactersInRange:[str rangeOfString:self.instructions] withString:@""];
        }
        
        NSString* replaceText = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //标签间到内容不能为空，否则闪退
        if ([replaceText isEqualToString:@""]) {
            replaceText = @" ";
        }
        NSMutableString* lableText = [NSMutableString stringWithString:self.words];
        [lableText replaceCharactersInRange:[self.words rangeOfString:str] withString:[NSString stringWithFormat:@"\n<i><font size=14 color='#a0a0a0'>%@</font></i>", replaceText]];
        self.titleLabel.text = lableText;
    }
    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidth = screenRect.size.width;
    CGFloat labelWidth = 240;//screenWidth - self.titleLabelLeadingConstraint.constant - self.titleLabelTrailingConstraint.constant;
    labelWidth = self.titleLabel.frame.size.width;
    CGRect labelRect = [self.words boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil];
    
    CGFloat labelHeight = labelRect.size.height;
    
    labelHeight += 15;
    
    self.titleLabelHeightConstraint.constant = labelHeight;

    if (self.viewHeightExpanded == 0 && self.viewHeight == 0){// labelHeight > 52 && self.viewHeight == 0) {
        CGRect frame = [self frame];
    if (labelHeight > 52) {
        frame.size.height += (labelHeight - 52);
    }
        
        self.frame = frame;
        self.viewHeight = frame.size.height;
//        NSLog(@"%d", self.viewHeight);
        self.viewHeightExpanded = self.viewHeight + 60;
        if (self.titleLabel.constraints) {
            NSLayoutConstraint *c = [self.titleLabel.constraints objectAtIndex:0];
            if (labelHeight > 52) {
                c.constant = labelHeight;
            }
        }
        if ([self.dashboardView superview].constraints) {
            NSLayoutConstraint *c = [[self.dashboardView superview].constraints objectAtIndex:3];
            c.constant = self.viewHeightExpanded - 60;
        }
    }
    
//    self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.response.score];
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.audioRecord.score];
    
    if (_audioRecord.score>=Scoreline(0)&&self.audioRecord.recordedCount>=self.response.total) {
        self.scoreView.backgroundColor = [UIColor colorWithRed:158/255.0 green:220/255.0 blue:108/255.0 alpha:1];
    }else if(_audioRecord.score>=Scoreline(0)&&self.audioRecord.recordedCount<=self.response.total){
        self.scoreView.backgroundColor = [UIColor colorWithRed:1 green:192/255.0 blue:0 alpha:1];
    }else
    {
        self.scoreView.backgroundColor = [UIColor redColor];
    }
    if (self.response.total > 0) {
        self.progressLabel.text = [NSString stringWithFormat:@"%d/%d", self.audioRecord.recordedCount, self.response.total];
        self.progressLabel.hidden = NO;
        if (self.response.count < self.response.total) {
            self.finishImageView.hidden = YES;
        } else {
            self.finishImageView.hidden = NO;
        }
    } else {
        self.progressLabel.hidden = YES;
        self.finishImageView.hidden = YES;
    }
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTabGesture:)];
//    
//    [self addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark Gesture Recognizer
- (IBAction)handleTabGesture:(UITapGestureRecognizer*)recognizer {
    self.expanded = !self.expanded;
}

# pragma mark Observers
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"selected"]) {
        LEProgressImageButton* imageButton = object;
        if (self.voiceImageButton == imageButton) {
            if (self.voiceImageButton.selected) {
                [self startAudioPlay];
            } else {
                [self stopAudioPlay];
            }
        } else if (self.recordImageButton == imageButton) {
            /*if (self.recordImageButton.selected) {
                [self startAudioRecord];
            } else {
                [self stopAudioRecord];
            }*/
            if (self.recordImageButton.selected) {
                if(![self canRecord]){
                    SHOWHUD(@"录音权限被禁止");
                    self.recordImageButton.selected = NO;
                    return;
                }
                if ([super isAudioEvaluating]) {
                    self.recordImageButton.selected = NO;
                    return;
                }
                [self startAudioEvaluate];
            } else {
                [self stopAudioEvaluate];
            }
        } else if (self.playImageButton == imageButton) {
            if (self.playImageButton.selected) {
                [self startRecordPlay];
            } else {
                [self stopRecordPlay];
            }
        }
    }
}

@end
