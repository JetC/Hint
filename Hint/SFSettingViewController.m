//
//  SFSettingViewController.m
//  Hint
//
//  Created by 孙培峰 on 14-3-15.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import "SFSettingViewController.h"
#import "RennSDK/RennSDK.h"
#import "SBJSON.h"
#import "SFRennFriendsListDelegate.h"

@interface SFSettingViewController ()

@property (strong, nonatomic)SFRennFriendsListDelegate *friendsListDelegate;
@property (weak, nonatomic) IBOutlet UILabel *userBelovedCount;
@property (weak, nonatomic) IBOutlet UILabel *userLovedCount;

@end

@implementation SFSettingViewController
@synthesize renRenConnectionStatusLabel = _renRenConnectionStatusLabel;
@synthesize renRenLoginButton = _renRenLoginButton;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    if (SCREEN_HEIGHT>480)
    {
        self.view.frame = CGRectMake(0, 0, 320, 548);
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RennClient initWithAppId:@"265615" apiKey:@"c1ae143617cf43138056d90c62461a83" secretKey:@"6d407586023f4db996cc243fa1e4e8f6"];
    
    [RennClient setScope:@"read_user_blog,read_user_checkin,read_user_feed,read_user_guestbook,read_user_invitation,read_user_like_history,read_user_message,read_user_notification,read_user_photo,read_user_status,read_user_album,read_user_comment,read_user_share,read_user_request,publish_blog,publish_checkin,publish_feed,publish_share,write_guestbook,send_invitation,send_request,send_message,send_notification,photo_upload,status_update,create_album,publish_comment,operate_like,admin_page"];
    [RennClient setTokenType:@"mac"];
    if ([RennClient isLogin])
    {
        self.renRenConnectionStatusLabel.text = @"要注销吗？点击下面按钮";
    }
    else
    {
        self.renRenConnectionStatusLabel.text = @"要登录吗？点击下面按钮";
        [RennClient loginWithDelegate:self];
    }

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.userBelovedCount.text = [userDefaults stringForKey:@"numberUserBeLoved"];
    NSLog(@"%@",[userDefaults stringForKey:@"numberUserBeLoved"]);
    self.userLovedCount.text = [userDefaults stringForKey:@"numberUserLoved"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshLovingNumbers) name:@"refreshLovingNumbers" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




- (IBAction)login:(id)sender
{
    if ([RennClient isLogin])
    {
        [RennClient logoutWithDelegate:self];
    }
    else
    {
        [RennClient loginWithDelegate:self];
    }
}


#pragma mark login



- (void)rennLoginSuccess
{
    self.renRenConnectionStatusLabel.text = @"现在要注销吗？点击下面按钮";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)setupFriendsListDelegate
{
//    self.friendsListArray = [[NSMutableArray alloc]init];
//    self.friendsListArray = [SFRennFriendsListDelegate sharedManager].friendsNameArray;
}

- (void)rennLogoutSuccess
{
    self.renRenConnectionStatusLabel.text = @"现在要登录吗？点击下面按钮";
}


- (void)dealloc
{
    self.renRenConnectionStatusLabel = nil;
    self.renRenLoginButton = nil;
    [RennClient cancelForDelegate:self];

}

- (void)refreshLovingNumbers
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        self.userBelovedCount.text = [userDefaults stringForKey:@"numberUserBeLoved"];
        NSLog(@"%@",[userDefaults stringForKey:@"numberUserBeLoved"]);
        self.userLovedCount.text = [userDefaults stringForKey:@"numberUserLoved"];
    }];
}



@end
