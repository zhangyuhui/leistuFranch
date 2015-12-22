//
//  LEMainViewControlerCellViewTableViewCell.m
//  leiapp
//
//  Created by Yuhui Zhang on 9/1/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LEMainViewControlerCellViewTableViewCell.h"
#import "LECourseService.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LEConstants.h"
#import "LECourseStudyRecord.h"
#import "LELessonRecord.h"
#import "LEDefines.h"
#import "UIButton+UIButton_SetBgState.h"

#define DOWNLOAD_BUTTON_MARGIN_X 30

@interface LEMainViewControlerCellViewTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;

@property (strong, nonatomic) IBOutlet UIButton *overlayButton;

@property (strong, nonatomic) IBOutlet UIView  *labelView;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *expirationLabel;
@property (strong, nonatomic) IBOutlet UIView  *expried_view;

@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *downloadButtonWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *downloadButtonHeightConstraint;


-(IBAction)clickDownload:(id)sender;

- (void)updateDisplay:(LECourse*)course;
- (void)updateStatus:(LECourse*)course;

@end
static int completeCount, score, studyTime;
@implementation LEMainViewControlerCellViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    CGSize imageSize = self.overlayButton.frame.size;
    UIColor *fillColor = [UIColor blackColor];
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [fillColor setFill];
    CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.overlayButton.alpha = 0.3;
    [self.overlayButton setBackgroundImage:backgroundImage forState:  UIControlStateHighlighted];
}

- (void)dealloc {
    if (self.course != nil) {
        [self.course removeObserver:self forKeyPath:@"status"];
        [self.course removeObserver:self forKeyPath:@"download"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (instancetype)mainViewControlerCellViewTableViewCell {
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LEMainViewControlerCellViewTableViewCell"
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];
}

- (void)setCourse:(LECourse *)course {
    if (_course != course) {
        if (self.course != nil) {
            [self.course removeObserver:self forKeyPath:@"status"];
            [self.course removeObserver:self forKeyPath:@"download"];
        }
        _course = course;
        [self updateDisplay:course];
        [self updateStatus:course];
        [self.course addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self.course addObserver:self forKeyPath:@"download" options:NSKeyValueObservingOptionNew context:nil];
    }
}

-(IBAction)clickDownload:(id)sender {
    LECourseStatus status = self.course.status;
    if (status == LECourseStatusDownloadReady ||
        status == LECourseStatusDownloadPaused ||
        status == LECourseStatusExtractPaused ||
        status == LECourseStatusParsePaused ){
        if ([self.delegate respondsToSelector:@selector(mainViewControlerCellViewTableViewCell:downloadCourse:)]) {
            [self.delegate mainViewControlerCellViewTableViewCell:self downloadCourse:self.course];
        }
    } else if (status == LECourseStatusStudyReady || status == LECourseStatusStudying) {
        if ([self.delegate respondsToSelector:@selector(mainViewControlerCellViewTableViewCell:studyCourse:)]) {
            [self.delegate mainViewControlerCellViewTableViewCell:self studyCourse:self.course];
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (!self.scrolling) {
        if([keyPath isEqualToString:@"status"]) {
            [self updateStatus:self.course];
        } else if([keyPath isEqualToString:@"download"]) {
            [self updateStatus:self.course];
        }
    }
}

- (void)updateDisplay:(LECourse*)course {
    self.nameLabel.text = _course.title;
//    CGRect lframe = self.expirationLabel.frame ;
//    lframe.origin.x -= 10;
//    lframe.size.width +=20;
//    self.expirationLabel.frame = lframe;
    self.expirationLabel.text = [NSString stringWithFormat:@"到期时间:%@", course.limit];
    self.expirationLabel.backgroundColor = [UIColor colorWithRed:28/255.0 green:157/255.0 blue:201/255.0 alpha:0.3];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:course.cover]
                           placeholderImage:[UIImage imageNamed:kLEImageCoverPlaceholder]];
    if(self.course.status == LECourseStatusExprised){
        self.expirationLabel.text = @"课程已过期";
        self.expirationLabel.backgroundColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:0.8];
    }
}
- (void) initStudyTiem{
    completeCount = 0;
    score = 0;
    studyTime = 0;
}
-(void) countCompleteSizeAndScore:(LECourseStudyRecord*) record{
//    NSDictionary* result = [[NSDictionary alloc] init];
    if (record) {
        NSArray* lessons = record.lessons;
        if (lessons) {
            [lessons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LELessonRecord* lessonRecord = obj;
                if (lessonRecord) {
                    NSArray* sections = lessonRecord.sections;
                    if (sections) {
                        [sections enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            LESectionRecord* sectionRecord = obj;
                            if (sectionRecord) {
                                NSArray* pages = sectionRecord.pages;
                                if (pages) {
                                    [pages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        LEPageRecord* pageRecord = obj;
                                        if (pageRecord && pageRecord.isCompleted) {
                                            completeCount+=1;
                                        }
                                        if (pageRecord) {
                                            score += pageRecord.score;
                                            studyTime += pageRecord.duration;
                                        }
                                    }];
                                }
                            }
                        }];
                    }
                }
            }];
        }
    }
//    return result;
}
- (void)updateStatus:(LECourse*)course {
    LECourseStatus status = course.status;
    if (status == LECourseStatusStudying) {
        self.overlayButton.hidden = NO;
        if (self.labelView.hidden == YES) {
            self.labelView.alpha = 0;
            self.labelView.hidden = NO;
            [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
                self.labelView.alpha = 1.0;
                self.buttonView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.buttonView.hidden = YES;
                self.buttonView.alpha = 1.0;
            }];
        }
        
        NSArray* records = [LECourseService sharedService].records;
        [self initStudyTiem];
        NSLog(@"%d%@", course.identifier, course.title);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"courseId == %d", course.identifier];
        NSArray *filtered = [records filteredArrayUsingPredicate:predicate];
        if ([filtered count] > 0) {
            LECourseStudyRecord* studyRecord = [filtered objectAtIndex:0];
            [self countCompleteSizeAndScore:studyRecord];
        }

        int seconds = studyTime % 60;
        int minutes = (studyTime / 60) % 60;
        int hours = studyTime / 3600;
        self.durationLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
        int progress = completeCount * 100 / course.mPageCount.intValue;
        self.progressLabel.text =  [NSString stringWithFormat:@"%d%%", progress];
        int _score = score / course.mPageCount.intValue;
        self.scoreLabel.text = [NSString stringWithFormat:@"%d分", _score];
    }else if(status == LECourseStatusExprised)
    {
        self.expried_view.hidden = NO;
        self.expried_view.alpha = 1;
        self.buttonView.hidden = YES;
        self.buttonView.alpha = 0;
        self.labelView.hidden = YES;
    }else {
        self.overlayButton.hidden = YES;
        if (self.buttonView.hidden == YES) {
            self.buttonView.alpha = 0;
            self.buttonView.hidden = NO;
            [UIView animateWithDuration:0.6 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
                self.buttonView.alpha = 1.0;
                self.labelView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.labelView.hidden = YES;
                self.labelView.alpha = 1.0;
            }];
        }
        NSString* title = nil;
        NSString* alert = nil;
        
        if (status == LECourseStatusDownloading) {
            title = [NSString stringWithFormat:@"正在下载(%d%%)...", course.download];
        } else if (status == LECourseStatusDownloadReady) {
            title = @"下载课程";
        } else if (status == LECourseStatusDownloadPaused) {
            title = [NSString stringWithFormat:@"继续下载"];
        } else if (status == LECourseStatusExtractReady) {
            title = @"解压课程";
        } else if (status == LECourseStatusExtracting) {
            title = @"正在解压...";
        } else if (status == LECourseStatusParseReady) {
            title = @"解析课程";
        } else if (status == LECourseStatusParsing) {
            title = @"正在解析...";
        } else if (status == LECourseStatusStudyReady) {
            title = @"开始学习";
        } else if (status == LECourseStatusExtractPaused) {
            title = @"正在解压...";
            alert = @"解压课程出错.";
        } else if (status == LECourseStatusParsePaused) {
            title = @"正在解析...";
            alert = @"解析课程出错.";
        } else if (status == LECourseStatusDownloadError) {
            alert = @"下载课程出错.";
            title = [NSString stringWithFormat:@"正在下载(%d%%)...", course.download];
        } else {
            title = @"下载课程";
        }
        
        if (alert) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下载出错"
                                                                message:alert
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
        [UIView performWithoutAnimation:^{
            NSDictionary *attributes = @{NSFontAttributeName: self.downloadButton.titleLabel.font};
            CGRect titleRect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.downloadButtonHeightConstraint.constant)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:attributes
                                                   context:nil];
            
            self.downloadButtonWidthConstraint.constant = titleRect.size.width + DOWNLOAD_BUTTON_MARGIN_X*2.0;
            
            
            [self.downloadButton setTitle:title forState:UIControlStateNormal];
            [self.downloadButton setTitle:title forState:UIControlStateHighlighted];
            [self.downloadButton setTitle:title forState:UIControlStateSelected];
            [self.downloadButton layoutIfNeeded];
        }];
    }
}

-(void)setScrolling:(BOOL)scrolling {
    if (_scrolling != scrolling) {
        _scrolling = scrolling;
        if (!scrolling) {
            [self updateStatus:self.course];
        }
    }
}

@end