//
//  WaitDialogFullS.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//

@class Task;

@interface WaitDialogFullS : UIView {
    Task                        *currentTask_;
    BOOL                        noCancel_;
    
    //UIToolbar                   *toolBar_;
    //UIBarButtonItem             *spaceItem_;
    //UIBarButtonItem             *cancelButton_;
	id							appDelegate_;
}

@property (nonatomic, assign) id appDelegate_;
/*! return a instance of WaitDialogFullS    */
+ (WaitDialogFullS *) sharedWaitDialog;

+ (UIImageView *) createBackgroundView;
+ (UIActivityIndicatorView *) createActivityIndicatorView;

- (void) startLoading;
- (void) endLoading;
- (void) cancelLoading;
- (void) startLoadingWithOutBar;
- (void) startLoadingWithOutBarAndLoadingStr:(NSString *)string;

- (void) setTask:(Task *)task noCancel:(BOOL) noCancel;
- (void) setTask:(Task *)task;
- (void) createBarAndCancelButton;

@end
