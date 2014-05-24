//
//  SFRennFriendsListDelegate.h
//  Hint
//
//  Created by 孙培峰 on 3/28/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import <RennSDK/RennSDK.h>
#import "SFSettingViewController.h"

@interface SFRennFriendsListDelegate : ListUserFriendParam


@property (strong, nonatomic) NSMutableArray *friendsNameArray;
@property (strong, nonatomic) NSMutableArray *friendsIconURLArray;


+ (instancetype)sharedManager;
- (void)loadListForTheTime:(NSInteger)timeLoaded;

@end
