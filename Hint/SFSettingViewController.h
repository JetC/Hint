//
//  SFSettingViewController.h
//  Hint
//
//  Created by 孙培峰 on 14-3-15.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRennFetchUserInfoDelegate.h"

@interface SFSettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,RennLoginDelegate>

@property (weak, nonatomic) IBOutlet UILabel *renRenConnectionStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *renRenLoginButton;
@property (weak, nonatomic) IBOutlet UISwitch *pushNotificationSwitcher;
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *friendsListArray;
@property (strong, nonatomic) SFRennFetchUserInfoDelegate *rennFetchUserInfoDelegate;



- (IBAction)login:(id)sender;
//- (IBAction)fetchFriendsList:(id)sender;



@end
