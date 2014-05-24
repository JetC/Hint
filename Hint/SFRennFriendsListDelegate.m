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

@interface SFRennFriendsListDelegate ()

@property BOOL needToLoadAgain;
@property NSInteger timesFriendsListLoaded;

@end

@implementation SFRennFriendsListDelegate

- (id)init
{
    self = [super init];
    _friendsNameArray = [[NSMutableArray alloc]init];
    _friendsIconURLArray = [[NSMutableArray alloc]init];

    _needToLoadAgain = YES;
    _timesFriendsListLoaded = 0;
//    [self loadListForTheTime:1];
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
        [_friendsNameArray addObject:[singlePersonInfo objectForKey:@"name"]];

        NSArray *iconURLArray = [[NSArray alloc]initWithArray:[singlePersonInfo objectForKey:@"avatar"]];
        for (NSDictionary *singlePersonIconArray in iconURLArray)
        {
            if ([[singlePersonIconArray objectForKey:@"size"] isEqualToString:@"HEAD"])
            {
                [_friendsIconURLArray addObject:[singlePersonIconArray objectForKey:@"url"]];
            }

        }

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
    }
}
@end
