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

#define kNumberOfPagesLoadEachTime 1
#define kPageSize 50

@interface SFRennFriendsListDelegate ()


//@property (nonatomic, strong)NSMutableArray *mArray;
@property BOOL needToLoadAgain;
@property NSInteger timesFriendsListLoaded;

@end

@implementation SFRennFriendsListDelegate

- (id)init
{
    self = [super init];
    _friendsListArray = [[NSMutableArray alloc]init];
    _needToLoadAgain = YES;
    _timesFriendsListLoaded = 0;
    [self loadListForTheTime:1];
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
    for (i = 1+kNumberOfPagesLoadEachTime*(timeLoaded-1); i<= kNumberOfPagesLoadEachTime+kNumberOfPagesLoadEachTime*(timeLoaded-1); i++)
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
//    NSLog(@"requestSuccessWithResponse:%@", [[SBJSON new]  stringWithObject:response error:nil]);
//    NSLog(@"%@",_mArray);
    NSMutableArray *arrayForResponse = [[NSMutableArray alloc]init];
    arrayForResponse = response;
    static NSInteger timesProcessed = 0;
    timesProcessed++;
    NSLog(@"self.friendsListArray.count:  %lu  /n  timesProcessed:%li\n\n\n\n",(unsigned long)self.friendsListArray.count,(long)timesProcessed);
    
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
    NSInteger i;
    for (i = 0; i<arrayForResponse.count ; i++)
    {
        NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
        [tmpArray addObject:[arrayForResponse objectAtIndex:i]];
        NSDictionary *tmpDict = [[NSDictionary alloc]initWithDictionary:[tmpArray objectAtIndex:0]];
        [self.friendsListArray addObject:[tmpDict objectForKey:@"name"]];

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
