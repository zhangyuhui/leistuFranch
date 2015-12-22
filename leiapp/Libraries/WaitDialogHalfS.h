//
//  WaitDialogHalfS.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//

@class Task;

@interface WaitDialogHalfS : UIView {
    
    Task                    *currentTask_;
    BOOL                    noCancel_;
    
    CGPoint                 cancelButtonLocation_;
	id						appDelegate_;
}

@property (nonatomic, assign) id appDelegate_;
/** return a instance of WaitDialogFullS    */
+ (WaitDialogHalfS *) sharedWaitDialog;

- (void) createActivityIndicatorView;

- (void) startLoading;
- (void) endLoading;
- (void) cancelLoading;
- (void) startLoadingWithOutBar;

- (void) setTask:(Task *)task noCancel:(BOOL) noCancel;
- (void) setTask:(Task *)task;

@end
