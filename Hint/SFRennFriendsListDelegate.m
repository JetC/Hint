//
//  SFRennFriendsListDelegate.m
//  Hint
//
//  Created by 孙培峰 on 3/28/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "SFRennFriendsListDelegate.h"
#import "SBJSON.h"

@interface SFRennFriendsListDelegate ()

@property (nonatomic, strong)NSMutableArray *mArray;
@property (nonatomic, weak)SFSettingViewController *settingViewController;

@end

@implementation SFRennFriendsListDelegate

- (id)init
{
    self = [super init];
    self.friendsListArray = [[NSMutableArray alloc]init];
    self.hasLoadingFriendsListFinished = NO;
    [self loadList];
    return self;
}

- (void)loadList
{
    ListUserFriendParam *param = [[ListUserFriendParam alloc] init];
    param.userId = [RennClient uid];
    param.pageNumber = 1;
    param.pageSize = 100;
    [RennClient sendAsynRequest:param delegate:self];
}

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    NSLog(@"requestSuccessWithResponse:%@", [[SBJSON new]  stringWithObject:response error:nil]);
    self.mArray = response;
    if ([self.mArray count] != 0 && self.hasLoadingFriendsListFinished == NO)
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
    else
    {
        self.hasLoadingFriendsListFinished = YES;
    }
    
    
}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    NSLog(@"requestFailWithError:%@", [error description]);
    NSString *domain = [error domain];
    NSString *code = [[error userInfo] objectForKey:@"code"];
    NSLog(@"requestFailWithError:Error Domain = %@, Error Code = %@", domain, code);
}



@end
