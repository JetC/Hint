//
//  SFAddingNewItemViewController.m
//  Hint
//
//  Created by 孙培峰 on 14-3-16.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import "SFAddingNewItemViewController.h"
#import "RennSDK/RennSDK.h"
#import "SBJSON.h"


@interface SFAddingNewItemViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSURLSessionDataTask *refreshDataTask;
@property (nonatomic, strong) NSMutableArray *friendsListArray;


@end

@implementation SFAddingNewItemViewController

@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [RennClient cancelForDelegate:self];
}

- (void)loadView
{
    [super loadView];
    
    if (SCREEN_HEIGHT>480)
    {
        self.view.frame = CGRectMake(0, 0, 320, 548);
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44-120) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.friendsListArray = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
            ListUserFriendParam *param = [[ListUserFriendParam alloc] init];
            param.userId = [RennClient uid];
            param.pageNumber = 1;
            param.pageSize = 20;
            [RennClient sendAsynRequest:param delegate:self];
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
        default:
            break;
    }
}

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    NSLog(@"requestSuccessWithResponse:%@", [[SBJSON new]  stringWithObject:response error:nil]);
    NSMutableArray *mArray = response;
    for (NSUInteger i = 0; i<20; i++)
    {
        NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
        [tmpArray addObject:[mArray objectAtIndex:i]];
 
        NSDictionary *tmpDict = [[NSDictionary alloc]initWithDictionary:[tmpArray objectAtIndex:0]];
        
        [self.friendsListArray addObject:[tmpDict objectForKey:@"name"]];
        
//        self.friendsListArray addObject:<#(id)#>
        
    }

}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    //NSLog(@"requestFailWithError:%@", [error description]);
    NSString *domain = [error domain];
    NSString *code = [[error userInfo] objectForKey:@"code"];
    NSLog(@"requestFailWithError:Error Domain = %@, Error Code = %@", domain, code);
//    AppLog(@"请求失败: %@", domain);
}



@end
