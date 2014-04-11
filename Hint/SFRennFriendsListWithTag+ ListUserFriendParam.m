//
//  SFRennFriendsListWithTag+ ListUserFriendParam.m
//  Hint
//
//  Created by 孙培峰 on 4/11/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "SFRennFriendsListWithTag+ ListUserFriendParam.h"

@interface SFRennFriendsListWithTag__ListUserFriendParam()



@end


@implementation SFRennFriendsListWithTag__ListUserFriendParam


-(id)init
{
    self = [super init];
    self.tag = [NSString stringWithFormat:@""];
    return self;
}


-(SFRennFriendsListWithTag__ListUserFriendParam *)setupParamWithTag:(NSString *)tag
{
    SFRennFriendsListWithTag__ListUserFriendParam *param = [[SFRennFriendsListWithTag__ListUserFriendParam alloc]init];
    param.tag = tag;
    return param;
    
}


@end
