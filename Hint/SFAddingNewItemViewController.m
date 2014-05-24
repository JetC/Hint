//
//  SFAddingNewItemViewController.m
//  Hint
//
//  Created by 孙培峰 on 14-3-16.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import "SFAddingNewItemViewController.h"
#import "SFRennFriendsListDelegate.h"
#import "SFAddingNewItemTableViewCell.h"
#import "SFRennFetchUserInfoDelegate.h"

@interface SFAddingNewItemViewController ()<NSURLSessionDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *theNewItemTableView;
@property (strong, nonatomic) SFRennFetchUserInfoDelegate *rennFetchUserInfoDelegate;
@property BOOL hasCurrentUserInfoLoaded;
@property (strong, nonatomic)NSURLSession *session;
@property NSInteger indexClicked;
@end


@implementation SFAddingNewItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self configView];

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 15;
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];

    self.hasCurrentUserInfoLoaded = NO;
    self.indexClicked = 0;

    [[SFRennFriendsListDelegate sharedManager] loadListForTheTime:1];
    self.rennFetchUserInfoDelegate = [[SFRennFetchUserInfoDelegate alloc]init];

    [self.rennFetchUserInfoDelegate loadCurrentUserInfo];
    [self checkUserInfo];
    [self checkLovingPersonHistory];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableViewData) name:@"iconsLoadingFinished" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableViewData) name:@"currentUserInfoLoaded" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableViewData) name:@"reloadTableViewData" object:nil];

}



#pragma mark TableView


- (void)reloadTableViewData
{
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [_theNewItemTableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SFRennFriendsListDelegate sharedManager].friendsListInfoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SFAddingNewItemTableViewCell";
    SFAddingNewItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[SFAddingNewItemTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    cell.nameLabel.text = [[[SFRennFriendsListDelegate sharedManager].friendsListInfoArray objectAtIndex:indexPath.row] objectForKey:@"name"];

    if ([SFRennFriendsListDelegate sharedManager].hasIconLoadingFinished == YES)
    //当icon都加载完成之后
    {
        cell.iconImageView.image = [[[SFRennFriendsListDelegate sharedManager].friendsListInfoArray objectAtIndex:indexPath.row] objectForKey:@"iconImage"];
    }
    cell.backgroundColor = [UIColor clearColor];

    NSLog(@"IndexPath.row : %ld",(long)indexPath.row);
    NSLog(@"Now On Screen: %li",(long)indexPath.row);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认选择吗" message:[NSString stringWithFormat:@"确认选择%@为喜欢的对象吗",[[[SFRennFriendsListDelegate sharedManager].friendsListInfoArray objectAtIndex:indexPath.row] objectForKey:@"name"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是的", nil];
    self.indexClicked = indexPath.row;
    [alertView show];

}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"Canceled");
    }
    else if (buttonIndex == 1)
    {
        [self sendLovingHintOfUserID:[[[SFRennFriendsListDelegate sharedManager].friendsListInfoArray objectAtIndex:self.indexClicked] objectForKey:@"id"]];
    }
}


- (void)sendLovingHintOfUserID:(NSString *)lovingUserID
{
    NSURL *url = [NSURL URLWithString:@"http://192.168.2.186/newlover"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *params = [NSString stringWithFormat:@"hint_id=%@&lover_id=%@",self.rennFetchUserInfoDelegate.currentUserID,lovingUserID];
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:data];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask * dataTask = [self.session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if(error == nil)
        {
            NSString *recievedDataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if ([recievedDataString rangeOfString:@"status\": 1"].location != NSNotFound)
            {
                [self showAlertViewWithTitle:@"已经点过这个人啦" message:@"我们理解您的心情，耐心静候啦" cancelButtonTitle:@"嗯哪！"];
            }
            else
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *infoRecieved = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                [userDefaults setValue:[infoRecieved objectForKey:@"hint_loved_num"] forKey:@"numberUserBeLoved"];
                [userDefaults setValue:[infoRecieved objectForKey:@"hint_have_love_num"] forKey:@"numberUserLoved"];

                NSString *loverName;
                for (id personInfo in [SFRennFriendsListDelegate sharedManager].friendsListInfoArray)
                {
                    if ([[personInfo objectForKey:@"id"]isEqualToString:lovingUserID])
                    {
                        loverName = [personInfo objectForKey:@"name"];
                    }

                }

                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshLovingNumbers" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addedLovingPerson" object:nil];


                [self notifyUserAfterClickedLoverWithloverName:loverName
                                                         Match:[[infoRecieved objectForKey:@"match"] integerValue]
                                            currentUserBeLoved:[[infoRecieved objectForKey:@"hint_loved_num"] integerValue]
                                                  loverBeloved:[[infoRecieved objectForKey:@"lover_loved_num"] integerValue]];
                
                
            }
        }
    }];
    [dataTask resume];



//    }

}

#pragma mark Config Kits

- (void)configView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundWithout64"]];

}

- (void)setupTableView
{
    [self.theNewItemTableView registerNib:[UINib nibWithNibName:@"SFAddingNewItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"SFAddingNewItemTableViewCell"];
    self.theNewItemTableView.delegate = self;
    self.theNewItemTableView.dataSource = self;
    self.theNewItemTableView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:self.theNewItemTableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [RennClient cancelForDelegate:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


- (void)currentUserInfoLoaded
{
    self.hasCurrentUserInfoLoaded = YES;
}


- (void)notifyUserAfterClickedLoverWithloverName:(NSString *)loverName Match:(NSInteger)match currentUserBeLoved:(NSInteger)currentUserBeLoved loverBeloved:(NSInteger)loverBeloved
{
    NSString *matchInfo;
//    NSString *currentUserBeLovedInfo;
//    NSString *loverBelovedInfo;

    if (match != 0)
    {
        matchInfo = [NSString stringWithFormat:@"恭喜，%@妹子早就看上你了！\n 还不快发一条私信？",loverName];
    }
    else
    {
        matchInfo = [NSString stringWithFormat:@"你喜欢的%@妹子目前已经有%ld 个人暗暗喜欢了哟\n 还不快快动?",loverName,(long)loverBeloved];
    }

    [self showAlertViewWithTitle:@"结果" message:matchInfo cancelButtonTitle:nil];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    if (title == nil || [title  isEqual: @""])
    {
        title = @"提示";
    }
    if (cancelButtonTitle == nil || [cancelButtonTitle  isEqual: @""])
    {
        cancelButtonTitle = @"知道啦！";
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles: nil];
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [alertView show];
    }];
}

- (void)checkUserInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSURL *url = [NSURL URLWithString:@"http://192.168.2.186/updata"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *params = [NSString stringWithFormat:@"hint_id=%@",[userDefaults objectForKey:@"currentUserID"]];
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:data];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask * dataTask = [self.session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if(error == nil)
        {
            NSDictionary *infoRecieved = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *numberUserLoved;
            NSString *numberUserBeLoved;
            numberUserLoved = [infoRecieved objectForKey:@"hint_have_love_num"];
            numberUserBeLoved = [infoRecieved objectForKey:@"hint_loved_num"];
            [userDefaults setObject:numberUserLoved forKey:@"numberUserLoved"];
            [userDefaults setObject:numberUserLoved forKey:@"numberUserBeLoved"];
        }
    }];
    [dataTask resume];
}

- (void)checkLovingPersonHistory
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSURL *url = [NSURL URLWithString:@"http://192.168.2.186/havelove"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *params = [NSString stringWithFormat:@"user_id=%@",[userDefaults objectForKey:@"currentUserID"]];
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:data];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask * dataTask = [self.session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if(error == nil)
        {
            NSDictionary *infoRecieved = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSMutableArray *lovedPeopleIDArray = [[NSMutableArray alloc]initWithArray:[infoRecieved objectForKey:@"have_love_id_list"]];
            [lovedPeopleIDArray removeObjectAtIndex:0];
            [SFRennFriendsListDelegate sharedManager].lovedPeopleIDArray = lovedPeopleIDArray;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"historyFinished" object:nil];

        }
    }];
    [dataTask resume];


}



@end
