//
//  SFSettingViewController.h
//  Hint
//
//  Created by 孙培峰 on 14-3-15.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRennFetchUserInfoDelegate.h"

@interface SFSettingViewController : UIViewController<RennLoginDelegate>

@property (weak, nonatomic) IBOutlet UILabel *renRenConnectionStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *renRenLoginButton;



- (IBAction)login:(id)sender;



@end
