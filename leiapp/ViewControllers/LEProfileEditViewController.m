//
//  LEProfileEditViewController.m
//  leiappv2
//
//  Created by Yuhui Zhang on 10/26/15.
//  Copyright © 2015 Yuhui Zhang. All rights reserved.
//

#import "LEProfileEditViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LEDefines.h"

#define kPageTitle  @"编辑个人资料"
#define kItemKeyUserName @"user_name"
#define kItemKeyLoginName @"login_name"
#define kItemKeyGender @"gender"
#define kItemKeySerialNumber @"serial_number"
#define kItemKeyEmail @"email"
#define kItemKeyPhone @"phone"
@interface LEProfileEditViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *displayNameTextFieldView;
@property (strong, nonatomic) IBOutlet UITextField *displayNameTextField;
@property (strong, nonatomic) IBOutlet UITableView *sexTypesTableView;

@property (strong, nonatomic) UIBarButtonItem *saveButton;

@property (strong, nonatomic) NSString* originalDisplayName;
@property (strong, nonatomic) NSString* updatedDisplayName;

@property (assign, nonatomic) LEUserSexType originalSexType;
@property (assign, nonatomic) LEUserSexType updatedSexType;
@property (strong, nonatomic) NSArray* sexTypes;

@end

@implementation LEProfileEditViewController

-(instancetype)initWithDisplayName:(NSString*)displayName {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.originalDisplayName = displayName;
        self.originalSexType = LEUserSexTypeUnknown;
    }
    return self;
}

-(instancetype)initWithGender:(LEUserSexType)sexType {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.originalSexType = sexType;
        self.updatedSexType = sexType;
    }
    return self;
}
-(instancetype)initWithDictionary:(NSDictionary *)account
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.originalDisplayName = @"aa";
        self.account = account;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = kPageTitle;
    
    self.displayNameTextFieldView.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    self.displayNameTextFieldView.layer.borderWidth= 1.0f;
    //    self.displayNameTextField.text = self.originalDisplayName;
    //    NSString *value ;
    //    NSString *type ;
    //    type = [_account objectForKey:@"key"];
    //    if ([value isEqualToString:kItemKeyDisplayName]) {
    //        value = [_account objectForKey:@"value"];
    //    }else if ([value isEqualToString:kItemKeySerialNumber]) {
    //        value = [_account objectForKey:@"value"];
    //    }else if ([value isEqualToString:kItemKeyEmail]) {
    //        value = [_account objectForKey:@"value"];
    //    }else if ([value isEqualToString:kItemKeyPhone]) {
    //        value = [_account objectForKey:@"value"];
    //    }
    self.displayNameTextField.placeholder = [NSString stringWithFormat:@"请输入%@",[_account objectForKey:@"label"]];
    
    self.sexTypes = @[@{ @"label": @"男", @"value": [NSNumber numberWithInteger:LEUserSexTypeMale] },
                      @{ @"label": @"女", @"value": [NSNumber numberWithInteger:LEUserSexTypeFemale] }];
    
    if (self.originalDisplayName != nil ){
        self.sexTypesTableView.hidden = YES;
        self.displayNameTextFieldView.hidden = NO;
        [self.displayNameTextField becomeFirstResponder];
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveButton:)];
        
        saveButton.tintColor = [UIColor grayColor];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = 5;
        
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: negativeSpacer, saveButton, nil]];
        
        self.saveButton = saveButton;
        [self.saveButton setEnabled:NO];
    } else {
        self.sexTypesTableView.hidden = NO;
        self.displayNameTextFieldView.hidden = YES;
    }
}

- (void)clickSaveButton:(id)sender {
    [self.displayNameTextField resignFirstResponder];
    if (self.originalDisplayName != nil) {
        NSString *type ;
        type = [_account objectForKey:@"key"];
        if ([type isEqualToString:kItemKeyEmail]) {
            if ([_displayNameTextField.text isEqualToString:@""]||![self isValidateEmail:_displayNameTextField.text])
            {
                SHOWHUD(@"邮箱格式错误");
                return;
            }
        }else if ([type isEqualToString:kItemKeyPhone]) {
            if (_displayNameTextField.text.length!=11) {
                SHOWHUD(@"电话格式错误，如不为空请检查是否11位");
                return;
            }
        }
        if ([self.delegate respondsToSelector:@selector(confirmProfileDictionary:)]) {
            NSMutableDictionary *account = [NSMutableDictionary dictionaryWithDictionary:_account];
            [account setObject:_displayNameTextField.text forKey:@"value"];
            _account = account;
            [self.delegate confirmProfileDictionary:_account];
        }
    } else if (self.originalSexType != LEUserSexTypeUnknown) {
        if ([self.delegate respondsToSelector:@selector(confirmProfileGenderEdit:)]) {
            [self.delegate confirmProfileGenderEdit:self.updatedSexType];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (IBAction)changeTextEditValue:(id)sender {
    self.updatedDisplayName = [self.displayNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([self.updatedDisplayName length] > 0 || ![self.updatedDisplayName isEqualToString:self.originalDisplayName]) {
        [self.saveButton setEnabled:YES];
    } else {
        [self.saveButton setEnabled:NO];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sexTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LEProfileEditViewControllerCellView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.tintColor = [UIColor grayColor];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSDictionary* sexType = [self.sexTypes objectAtIndex:indexPath.row];
    cell.textLabel.text = [sexType objectForKey:@"label"];
    
    NSNumber* value = [sexType objectForKey:@"value"];
    if (self.updatedSexType == [value intValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    NSDictionary* sexType = [self.sexTypes objectAtIndex:indexPath.row];
    NSNumber* value = [sexType objectForKey:@"value"];
    
    int sexTypeValue = [value intValue];
    if (self.updatedSexType != sexTypeValue) {
        self.updatedSexType = sexTypeValue;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.sexTypesTableView reloadData];
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.2*NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self clickSaveButton:nil];
            });
        });
    }
}


@end
