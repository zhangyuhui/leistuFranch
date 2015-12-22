//
//  MoreServiceViewController.h
//  CEBCredit_3.04
//
//  Created by David King on 14-7-18.
//
//

#import "BrowserViewController.h"

@interface MoreServiceViewController : BrowserViewController

@property (nonatomic, assign) BOOL noShowHomeBtn;
@property (nonatomic, assign) BOOL scaleFit;
@property (nonatomic, assign) BOOL myBackAndHomeButtonAndFrame;
@property (nonatomic, assign) BOOL popTag;
-(void)setMineBackAndHomeButtonAndFrame;

@end
