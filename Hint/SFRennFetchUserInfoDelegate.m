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

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    NSLog(@"requestSuccessWithResponse:%@", [[SBJSON new]  stringWithObject:response error:nil]);
}

@end
