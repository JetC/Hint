//
//  SFRennFetchUserInfoDelegate.m
//  Hint
//
//  Created by 孙培峰 on 5/6/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "SFRennFetchUserInfoDelegate.h"
#import "SBJSON.h"

@implementation SFRennFetchUserInfoDelegate

- (void)loadCurrentUserInfo
{
    GetUserParam *param = [[GetUserParam alloc] init] ;
    param.userId = [RennClient uid];
    [RennClient sendAsynRequest:param delegate:self];
}

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    NSLog(@"requestSuccessWithResponse:%@", [[SBJSON new]  stringWithObject:response error:nil]);
    NSMutableDictionary *arrayForResponse = [[NSMutableDictionary alloc]init];
    arrayForResponse = response;
    self.currentUserName = [arrayForResponse objectForKey:@"name"];
    self.currentUserID = [arrayForResponse objectForKey:@"id"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.currentUserID forKey:@"currentUserID"];
    [userDefaults setObject:self.currentUserName forKey:@"currentUserName"];
}

@end
