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

- (void)dealloc
{
    self.renRenConnectionStatusLabel = nil;
    self.renRenLoginButton = nil;
}

@end
