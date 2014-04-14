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

@interface SFRennFriendsListDelegate ()

@property (nonatomic, strong)NSMutableArray *mArray;
//@property (nonatomic, strong)NSInteger times;

@end

@implementation SFRennFriendsListDelegate

- (id)init
{
    self = [super init];
    self.friendsListArray = [[NSMutableArray alloc]init];
    self.hasLoadingFriendsListFinished = NO;
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

- (void)loadListForTheTime:(NSUInteger)timeLoaded
{
    static NSUInteger i = 1;
    if (self.hasLoadingFriendsListFinished == NO)
    {
        for (i = 1+10*(timeLoaded-1); i<= 10+10*(timeLoaded-1); i++)
        {
            ListUserFriendParam *param = [[ListUserFriendParam alloc] init];
            param.userId = [RennClient uid];
            param.pageNumber = i;
            param.pageSize = 100;
            
//            以后需要时候直接导入头文件，改param的原始类为SFRennFriendsListWithTag+ ListUserFriendParam即可
//            param.tag = @"1";
            [RennClient sendAsynRequest:param delegate:self];
        }
    }
    else
    {
        
    }
}

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
//    NSLog(@"requestSuccessWithResponse:%@", [[SBJSON new]  stringWithObject:response error:nil]);
    self.mArray = response;
    
    static NSInteger timesProcessed = 0;
    timesProcessed++;
    NSLog(@"self.friendsListArray.count:  %lu  /n  timesProcessed:%li",(unsigned long)self.friendsListArray.count,(long)timesProcessed);
    
    if (_mArray.count == 0)
    {

    }
    else
    {
        [self serializingResponse];
    }
    
}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    NSLog(@"requestFailWithError:%@", [error description]);
    NSString *domain = [error domain];
    NSString *code = [[error userInfo] objectForKey:@"code"];
    NSLog(@"requestFailWithError:Error Domain = %@, Error Code = %@", domain, code);
}

- (void)serializingResponse
{
    for (NSUInteger i = 0; i<100; i++)
    {
        NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
        if ([self.mArray count] > i)
        {
            [tmpArray addObject:[self.mArray objectAtIndex:i]];
            NSDictionary *tmpDict = [[NSDictionary alloc]initWithDictionary:[tmpArray objectAtIndex:0]];
            [self.friendsListArray addObject:[tmpDict objectForKey:@"name"]];
        }
        else
        {
            self.hasLoadingFriendsListFinished = YES;
            
        }
    }
}

@end
