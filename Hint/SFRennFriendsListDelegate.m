//
//  SFRennFriendsListDelegate.m
//  Hint
//
//  Created by 孙培峰 on 3/28/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "SFRennFriendsListDelegate.h"
//#import "SFRennFriendsListWithTag+ ListUserFriendParam.h"
#import "SBJSON.h"

#define kNumberOfPagesLoadEachTime 5
#define kPageSize 100

@protocol SFRennFriendsIconDelegate <NSObject>

//- (void)

@end


@interface SFRennFriendsListDelegate ()<NSURLSessionDelegate>

@property BOOL needToLoadAgain;
@property NSInteger timesFriendsListLoaded;
@property (strong, nonatomic) id <SFRennFriendsIconDelegate>rennFriendsIconDelegate;
@property (strong, nonatomic) NSURLSession *iconSession;

@end

@implementation SFRennFriendsListDelegate

- (id)init
{
    self = [super init];
    _friendsNameArray = [[NSMutableArray alloc]init];
    _friendsIconURLArray = [[NSMutableArray alloc]init];
    self.friendsListInfoArray = [[NSMutableArray alloc]init];
    
    _needToLoadAgain = YES;
    _timesFriendsListLoaded = 0;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 15;
    self.iconSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    self.hasIconLoadingFinished = NO;

    return self;
}

+ (instancetype)sharedManager
{
    static SFRennFriendsListDelegate *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]init];
    });
    return sharedManager;
}

- (void)loadListForTheTime:(NSInteger)timeLoaded
{
    static NSInteger i = 1;
    for (i = 1+kNumberOfPagesLoadEachTime*(timeLoaded-1); i <=  kNumberOfPagesLoadEachTime+kNumberOfPagesLoadEachTime*(timeLoaded-1); i++)
    {
        ListUserFriendParam *param = [[ListUserFriendParam alloc] init];
        param.userId = [RennClient uid];
        param.pageNumber = i;
        param.pageSize = kPageSize;

        //            以后需要时候直接导入头文件，改param的原始类为SFRennFriendsListWithTag+ ListUserFriendParam即可
        //            param.tag = @"1";
        [RennClient sendAsynRequest:param delegate:self];
    }

    _timesFriendsListLoaded++;
}

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    NSLog(@"requestSuccessWithResponse:%@", [[SBJSON new]  stringWithObject:response error:nil]);
    NSMutableArray *arrayForResponse = [[NSMutableArray alloc]init];
    arrayForResponse = response;
    static NSInteger timesProcessed = 0;
    timesProcessed++;
    NSLog(@"self.friendsListArray.count:  %lu  /n  timesProcessed:%li\n\n\n\n",(unsigned long)self.friendsNameArray.count,(long)timesProcessed);
    
    if (arrayForResponse.count != 0)
    {
        [self serializingResponseArray:arrayForResponse];
    }

    if (arrayForResponse.count != kPageSize)
    {
        _needToLoadAgain = NO;
    }
    if (timesProcessed == kNumberOfPagesLoadEachTime*(_timesFriendsListLoaded))
    {
        [self checkWhetherNeedToLoadFriendsListAgain];
    }


}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    NSLog(@"requestFailWithError:%@", [error description]);
    NSString *domain = [error domain];
    NSString *code = [[error userInfo] objectForKey:@"code"];
    NSLog(@"requestFailWithError:Error Domain = %@, Error Code = %@", domain, code);
}

- (void)serializingResponseArray:(NSMutableArray *)arrayForResponse
{
    for (id singlePersonInfo in arrayForResponse)
    {
        NSMutableDictionary *friendInfoDictionary = [[NSMutableDictionary alloc]initWithObjects:@[@"name",@"iconImage",@"iconImageUrl"] forKeys:@[@"name",@"iconImage",@"iconImageUrl"]];
        [friendInfoDictionary setValue:[singlePersonInfo objectForKey:@"name"] forKey:@"name"];
        NSArray *iconURLArray = [[NSArray alloc]initWithArray:[singlePersonInfo objectForKey:@"avatar"]];
        for (NSDictionary *singlePersonIconArray in iconURLArray)
        {
            if ([[singlePersonIconArray objectForKey:@"size"] isEqualToString:@"HEAD"])
            {
                [friendInfoDictionary setValue:[singlePersonIconArray objectForKey:@"url"] forKey:@"iconImageUrl"];
            }
        }
        [self.friendsListInfoArray addObject:friendInfoDictionary];
    }

}

- (void)checkWhetherNeedToLoadFriendsListAgain
{
    if (_needToLoadAgain == YES)
    {
        [self loadListForTheTime:_timesFriendsListLoaded+1];
    }
    else
    {
        NSLog(@"结束啦！");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadTableViewData" object:nil];
        [self loadFriendsIcon];
    }
}

- (void)loadFriendsIcon
{
    self.iconImagesArray = [[NSMutableArray alloc]initWithCapacity:self.friendsNameArray.count];
    for (NSInteger i = 0; i<self.friendsNameArray.count ;i++)
    {
        self.iconImagesArray[i] = [NSNull null];
    }
    for (NSString *iconUrlString in self.friendsIconURLArray)
    {
        NSURL *url = [NSURL URLWithString:iconUrlString];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setHTTPMethod:@"GET"];
        NSURLSessionDataTask * dataTask = [self.iconSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
            if(error == nil)
            {
                static NSInteger iconLoaded = 0;
                NSLog(@"response.URL:%@",response.URL);
                NSLog(@"friendsIconURLArray 0:%@",[self.friendsIconURLArray objectAtIndex:0]);
                NSLog(@"URL is at index:%lu",(unsigned long)[self.friendsIconURLArray indexOfObject:response.URL]);
                [self.iconImagesArray replaceObjectAtIndex:[self.friendsIconURLArray indexOfObject:[response.URL absoluteString]] withObject:[UIImage imageWithData:data]];

                iconLoaded++;
                NSLog(@"Icon Loaded: %ld",(long)iconLoaded);
                if (iconLoaded >= self.friendsIconURLArray.count)
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadTableViewData" object:nil];
                    for (NSInteger i = 0; i<self.iconImagesArray.count ;i++)
                    {
                        if ([self.iconImagesArray objectAtIndex:i]==[NSNull null])
                        {
                            [self.iconImagesArray replaceObjectAtIndex:i withObject:[UIImage imageNamed:@"1"]];
                        }
                    }
                    self.hasIconLoadingFinished = YES;
                }
            }
        }];
        [dataTask resume];

    }
}













@end
