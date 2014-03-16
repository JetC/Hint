//
//  SFSettingViewController.m
//  Hint
//
//  Created by 孙培峰 on 14-3-15.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import "SFSettingViewController.h"
#import "RennSDK/RennSDK.h"

@interface SFSettingViewController ()


@end

@implementation SFSettingViewController
@synthesize renRenConnectionStatusLabel = _renRenConnectionStatusLabel;
@synthesize renRenLoginButton = _renRenLoginButton;
@synthesize friendsListTable = _friendsListTable;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RennClient initWithAppId:@"265614"
                       apiKey:@"c9a6042a7b3247fd8522a53ebd0e322d"
                    secretKey:@"44950bc9d45a402c8e96242df84281e3"];
    
    [ RennClient setScope:@"read_user_blog,read_user_checkin,read_user_feed,read_user_guestbook,read_user_invitation,read_user_like_history,read_user_message,read_user_notification,read_user_photo,read_user_status,read_user_album,read_user_comment,read_user_share,read_user_request,publish_blog,publish_checkin,publish_feed,publish_share,write_guestbook,send_invitation,send_request,send_message,send_notification,photo_upload,status_update,create_album,publish_comment,operate_like,admin_page"];
    
//    SCOPE = "read_user_blog,read_user_checkin,read_user_feed,read_user_guestbook,read_user_invitation,read_user_like_history,read_user_message,read_user_notification,read_user_photo,read_user_status,read_user_album,read_user_comment,read_user_share,read_user_request,publish_blog,publish_checkin,publish_feed,publish_share,write_guestbook,send_invitation,send_request,send_message,send_notification,photo_upload,status_update,create_album,publish_comment,operate_like,admin_page";
    if ([RennClient isLogin])
    {
        self.renRenConnectionStatusLabel.text = @"注销";
    }
    else
    {
        self.renRenConnectionStatusLabel.text = @"登录";
    }
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
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    }
    switch (row) {
        case 0:
            cell.textLabel.text = @"相册";
            break;
        case 1:
            cell.textLabel.text = @"评论";
            break;
        case 2:
            cell.textLabel.text = @"新鲜事";
            break;
        case 3:
            cell.textLabel.text = @"通知";
            break;
        case 4:
            cell.textLabel.text = @"照片";
            break;
        case 5:
            cell.textLabel.text = @"个人资料";
            break;
        case 6:
            cell.textLabel.text = @"分享";
            break;
        case 7:
            cell.textLabel.text = @"状态";
            break;
        case 8:
            cell.textLabel.text = @"表情";
            break;
        case 9:
            cell.textLabel.text = @"用户";
            break;
        case 10:
            cell.textLabel.text = @"应用";
            break;
        case 11:
            cell.textLabel.text = @"日志";
            break;
        case 12:
            cell.textLabel.text = @"赞";
            break;
        default:
            break;
    }
    return cell;
}


- (IBAction)login:(id)sender
{
    if ([RennClient isLogin])
    {
        [RennClient logoutWithDelegate:self];
    }
    else {
        [RennClient loginWithDelegate:self];
    }
}


- (IBAction)fetchFriendsList:(id)sender
{
    PutFeedParam *param = [[PutFeedParam alloc] init];
    param.title = @"新鲜事Title";
    param.description = @"新鲜事Description";
    param.message = @"这是一条新鲜事";
    param.targetUrl = @"http://www.56.com/u72/v_OTAyNTkxMDk.html";
    
    [RennClient sendAsynRequest:param delegate:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (![RennClient isLogin]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSInteger row = indexPath.row;
//    switch (row) {
//        case 0:
//        {
//            AlbumViewController *controller = [[AlbumViewController alloc] initWithNibName:@"ApiViewController" bundle:nil];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 1:
//        {
//            CommentViewController *controller = [[[CommentViewController alloc] initWithNibName:@"ApiViewController" bundle:nil] autorelease];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 2:
//        {
//            FeedViewController *controller = [[[FeedViewController alloc] initWithNibName:@"ApiViewController" bundle:nil] autorelease];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 3:
//        {
//            NotificationViewController *controller = [[[NotificationViewController alloc] initWithNibName:@"ApiViewController" bundle:nil] autorelease];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 4:
//        {
//            PhotoViewController *controller = [[[PhotoViewController alloc] initWithNibName:@"ApiViewController" bundle:nil] autorelease];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 5:
//        {
//            ProfileViewController *controller = [[[ProfileViewController alloc] initWithNibName:@"ApiViewController" bundle:nil] autorelease];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 6:
//        {
//            ShareViewController *controller = [[[ShareViewController alloc] initWithNibName:@"ApiViewController" bundle:nil] autorelease];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 7:
//        {
//            StatusViewController *controller = [[[StatusViewController alloc] initWithNibName:@"ApiViewController" bundle:nil] autorelease];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 8:
//        {
//            UbbViewController *controller = [[[UbbViewController alloc] initWithNibName:@"ApiViewController" bundle:nil] autorelease];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 9:
//        {
//            UserViewController *controller = [[[UserViewController alloc] initWithNibName:@"ApiViewController" bundle:nil] autorelease];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 10:
//        {
//            AppViewController *controller = [[[AppViewController alloc] initWithNibName:@"ApiViewController" bundle:nil] autorelease];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 11:
//        {
//            BlogViewController *controller = [[[BlogViewController alloc] initWithNibName:@"ApiViewController" bundle:nil] autorelease];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 12:
//        {
//            LikeViewController *controller = [[[LikeViewController alloc] initWithNibName:@"ApiViewController" bundle:nil] autorelease];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//            break;
//        default:
//            break;
//    }
}
- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    
}
- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    
}
#pragma mark login



- (void)rennLoginSuccess
{
    self.renRenConnectionStatusLabel.text = @"注销";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)rennLogoutSuccess
{
    self.renRenConnectionStatusLabel.text = @"登录";
}

- (void)dealloc
{
    self.renRenConnectionStatusLabel = nil;
    self.renRenLoginButton = nil;
    self.friendsListTable = nil;
    self.friendsListArray = nil;
}

@end
