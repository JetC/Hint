//
//  SFRennFetchUserInfoDelegate.h
//  Hint
//
//  Created by 孙培峰 on 5/6/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import <RennSDK/RennSDK.h>

@interface SFRennFetchUserInfoDelegate : RennClient

@property (nonatomic, strong) NSString *currentUserName;
@property (nonatomic, strong) NSString *currentUserID;
@property (nonatomic, strong) NSString *currentUserIcon;

- (void)loadCurrentUserInfo;



@end
