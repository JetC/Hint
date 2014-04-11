//
//  SFRennFriendsListWithTag+ ListUserFriendParam.h
//  Hint
//
//  Created by 孙培峰 on 4/11/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import <RennSDK/RennSDK.h>

@interface SFRennFriendsListWithTag__ListUserFriendParam : ListUserFriendParam

@property (nonatomic, strong)NSString *tag;

- (ListUserFriendParam *)setupParamWithTag:(NSString *)tag;


@end
