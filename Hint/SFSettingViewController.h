//
//  SFSettingViewController.h
//  Hint
//
//  Created by 孙培峰 on 14-3-15.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFSettingViewController : UIViewController<RenrenDelegate>

@property (weak, nonatomic) IBOutlet UILabel *renRenConnectionStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *renRenLoginButton;
@property (weak, nonatomic) IBOutlet UISwitch *pushNotificationSwitcher;

- (IBAction)login:(id)sender;


@end
