//
//  SFSettingViewController.m
//  Hint
//
//  Created by 孙培峰 on 14-3-15.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import "SFSettingViewController.h"
#import "ROConnect.h"

@interface SFSettingViewController ()


@end

@implementation SFSettingViewController
@synthesize renRenConnectionStatusLabel = _renRenConnectionStatusLabel;
@synthesize renRenLoginButton = _renRenLoginButton;
@synthesize friendsListTable = _friendsListTable;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![[Renren sharedRenren] isSessionValid]) {//未登录状态，Lable显示"请登录",登录按钮的背景图片为"用人人账号登录"的图片.
        self.renRenConnectionStatusLabel.text = [NSString stringWithFormat:@"请登录"];
        self.renRenLoginButton.frame = CGRectMake(self.renRenLoginButton.frame.origin.x, self.renRenLoginButton.frame.origin.y, 150, 30);
        [self.renRenLoginButton setImage:[UIImage imageNamed:@"RenRenLogin.png"] forState:UIControlStateNormal];
        
        
    }
    else
    {//已登录状态,Lable显示"登录成功",登录按钮的背景图片为"退出"的图片.
        self.renRenConnectionStatusLabel.text = [NSString stringWithFormat:@"登录成功"];
        self.renRenLoginButton.frame = CGRectMake(self.renRenLoginButton.frame.origin.x, self.renRenLoginButton.frame.origin.y, 90, 30);
        [self.renRenLoginButton setImage:[UIImage imageNamed:@"logout_90X30.png"] forState:UIControlStateNormal];
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

- (IBAction)login:(id)sender
{
    if(![[Renren sharedRenren] isSessionValid]){//未登录的情况,进行授权登录
        [[Renren sharedRenren] authorizationWithPermisson:nil andDelegate:self];
    } else {//已登录的情况，退出登录
        [[Renren sharedRenren] logout:self];
}
}

/**
 * 授权登录成功时被调用，第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的Renren类型对象。
 */
- (void)renrenDidLogin:(Renren *)renren
{
    self.renRenConnectionStatusLabel.text = [NSString stringWithFormat:@"登陆成功"];
    self.renRenLoginButton.frame = CGRectMake(self.renRenLoginButton.frame.origin.x, self.renRenLoginButton.frame.origin.y, 90, 30);
    [self.renRenLoginButton setImage:[UIImage imageNamed:@"logout_90X30.png"] forState:UIControlStateNormal];
}

/**
 * 用户登出成功后被调用 第三方开发者实现这个方法
 * @param renren 传回代理登出接口请求的Renren类型对象。
 */
- (void)renrenDidLogout:(Renren *)renren
{
    self.renRenConnectionStatusLabel.text = [NSString stringWithFormat:@"请登陆"];
    self.renRenLoginButton.frame = CGRectMake(self.renRenLoginButton.frame.origin.x, self.renRenLoginButton.frame.origin.y, 150, 30);
    [self.renRenLoginButton setImage:[UIImage imageNamed:@"normal_150X30.png"] forState:UIControlStateNormal];
}

/**
 * 授权登录失败时被调用，第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的Renren类型对象。
 */
- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error
{
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"错误提示" message:@"授权失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}


- (IBAction)fetchFriendsList:(id)sender
{
    if([[Renren sharedRenren] isSessionValid]){//已登录状态,设置requestParam,设置请求参数:好友列表第1页,500条,name字段的数据.
        ROGetFriendsInfoRequestParam *requestParam = [[ROGetFriendsInfoRequestParam alloc] init];
        requestParam.page = @"1";
        requestParam.count = @"500";
        requestParam.fields = @"name";
        
        [[Renren sharedRenren] getFriendsInfo:requestParam andDelegate:self];
    }
    else
    {
        //未登录状态提示用户"您还没有授权"
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有授权" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

/**
 * 接口请求成功，第三方开发者实现这个方法
 * @param renren 传回代理服务器接口请求的Renren类型对象。
 * @param response 传回接口请求的响应。
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    //创建好友数组.
    self.friendsListArray = [[NSMutableArray alloc] init];
    //取得请求结果.
    NSMutableArray *friendsArray = (NSMutableArray *)response.rootObject;
    
    //将请求结果对象中的name信息放到数组中.
    for (ROUserResponseItem *friend in friendsArray) {
        [self.friendsListArray addObject:friend.name];
    }
    
    //Table View重新加载数据.
    [self.friendsListTable reloadData];
}

/**
 * 接口请求失败，第三方开发者实现这个方法
 * @param renren 传回代理服务器接口请求的Renren类型对象。
 * @param response 传回接口请求的错误对象。
 */
- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"错误提示" message:@"API请求错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friendsListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.friendsListArray.count) {
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"friendsListCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendsListCell"];
        }
        
        cell.textLabel.text = (NSString *)[self.friendsListArray objectAtIndex:indexPath.row];
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (void)dealloc
{
    self.renRenConnectionStatusLabel = nil;
    self.renRenLoginButton = nil;
    self.friendsListTable = nil;
    self.friendsListArray = nil;
}

@end
