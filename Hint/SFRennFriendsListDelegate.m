//
//  SFRennFriendsListDelegate.m
//  Hint
//
//  Created by 孙培峰 on 3/28/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "SFRennFriendsListDelegate.h"
#import "SBJSON.h"

@implementation SFRennFriendsListDelegate

- (id)init
{
    self = [super init];
    self.friendsListArray = [[NSMutableArray alloc]init];
    return self;
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
