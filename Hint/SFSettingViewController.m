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

@end

@implementation SFSettingViewController
@synthesize renRenConnectionStatusLabel = _renRenConnectionStatusLabel;
@synthesize renRenLoginButton = _renRenLoginButton;
@synthesize tableView = _tableView;



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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 194, 320, self.view.frame.size.height-44-120) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RennClient initWithAppId:@"265615"
                       apiKey:@"c1ae143617cf43138056d90c62461a83"
                    secretKey:@"6d407586023f4db996cc243fa1e4e8f6"];
    
    [RennClient setScope:@"read_user_blog,read_user_checkin,read_user_feed,read_user_guestbook,read_user_invitation,read_user_like_history,read_user_message,read_user_notification,read_user_photo,read_user_status,read_user_album,read_user_comment,read_user_share,read_user_request,publish_blog,publish_checkin,publish_feed,publish_share,write_guestbook,send_invitation,send_request,send_message,send_notification,photo_upload,status_update,create_album,publish_comment,operate_like,admin_page"];
    
    if ([RennClient isLogin])
    {
        self.renRenConnectionStatusLabel.text = @"要注销吗？点击下面按钮";
    }
    else
    {
        self.renRenConnectionStatusLabel.text = @"要登录吗？点击下面按钮";
        [RennClient loginWithDelegate:self];
    }
//    self.friendsListArray = [[NSMutableArray alloc]init];
//    self.friendsListDelegate = [[SFRennFriendsListDelegate alloc]init];
//    self.friendsListArray = self.friendsListDelegate.friendsListArray;
//    self.friendsListDelegate.settingViewController = self;
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    }
    switch (row) {
        case 0:
            cell.textLabel.text = @"批量获取用户信息";
            break;
        case 1:
            cell.textLabel.text = @"以分页的方式获取某个用户与当前登录用户的共同好友";
            break;
        case 2:
            cell.textLabel.text = @"获取用户信息";
            break;
        case 3:
            cell.textLabel.text = @"获取某个用户的好友列表";
            break;
        case 4:
            cell.textLabel.text = @"获取当前登录用户在某个应用里的好友列表";
            break;
        case 5:
            cell.textLabel.text = @"验证登录是否过期";
            break;
        case 6:
            cell.textLabel.text = @"验证登录是否有效";
            break;
        case 7:
            cell.textLabel.text = @"获取登录信息";
            break;
        case 8:
            cell.textLabel.text = @"获取未安装该应用好友列表";
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
        {
            BatchUserParam *param = [[BatchUserParam alloc] init];
            param.userIds = [NSArray arrayWithObjects:[RennClient uid], nil];
            [RennClient sendAsynRequest:param delegate:self];
        }
            break;
        case 1:
        {
            ListUserFriendMutualParam *param = [[ListUserFriendMutualParam alloc] init] ;
            param.userId = [RennClient uid];
            [RennClient sendAsynRequest:param delegate:self];
        }
            break;
        case 2:
        {
            GetUserParam *param = [[GetUserParam alloc] init] ;
            param.userId = [RennClient uid];
            [RennClient sendAsynRequest:param delegate:self];
        }
            break;
        case 3:
        {
            [self setupFriendsListDelegate];
        }
            break;
        case 4:
        {
            ListUserFriendAppParam *param = [[ListUserFriendAppParam alloc] init];
            [RennClient sendAsynRequest:param delegate:self];
            
        }
            break;
        case 5:
        {
            //            AppLog(@"过期:%@",[RennClient isAuthorizeExpired] ? @"YES":@"NO");
        }
            break;
        case 6:
        {
            //            AppLog(@"有效:%@",[RennClient isAuthorizeValid] ? @"YES":@"NO");
        }
            break;
        case 7:
        {
            GetUserLoginParam *param = [[GetUserLoginParam alloc] init];
            [RennClient sendAsynRequest:param delegate:self];
        }
            break;
        case 8:
        {
            //            ListUserFriendUninstallAppParam *param = [[[ListUserFriendUninstallAppParam alloc] init] autorelease];
            //            [RennClient sendAsynRequest:param delegate:self];
        }
            break;
        default:
            break;
    }
}


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
    SFRennFriendsListDelegate *fetchingFriendsListManager = [[SFRennFriendsListDelegate alloc]init];
    self.friendsListArray = [[NSMutableArray alloc]init];
    self.friendsListDelegate = fetchingFriendsListManager;
    self.friendsListArray = self.friendsListDelegate.friendsListArray;
    self.friendsListDelegate.settingViewController = self;
    
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

@end
