//
//  LECourseLessonsViewControllerMenuViewCellTableViewCell.m
//  leiappv2
//
//  Created by Yuhui Zhang on 9/15/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonsViewControllerMenuViewCell.h"

@interface LECourseLessonsViewControllerMenuViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *menuImageView;
@property (strong, nonatomic) IBOutlet UILabel *menuLabel;

@end

@implementation LECourseLessonsViewControllerMenuViewCell

- (void)awakeFromNib {
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor blackColor];
    self.selectedBackgroundView = selectionColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMenuImage:(UIImage *)menuImage {
    _menuImage = menuImage;
    self.menuImageView.image = _menuImage;
}

- (void)setMenuText:(NSString *)menuText {
    _menuText = menuText;
    self.menuLabel.text = menuText;
}

+ (instancetype)courseLessonsViewControllerMenuViewCell {
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LECourseLessonsViewControllerMenuViewCell"
                                                      owner:self
                                                    options:nil];
    return [nibViews objectAtIndex:0];

}

@end
