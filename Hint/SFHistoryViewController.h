//
//  SFHistoryViewController.h
//  Hint
//
//  Created by 孙培峰 on 14-3-16.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFHistoryViewController : UIViewController<TimelineViewDataSource, TimelineViewDelegate>

- (IBAction)deleteButtonPush:(id)sender;
- (IBAction)swapButtonPush:(id)sender;
- (IBAction)insertTopButtonPush:(id)sender;

@property (weak, nonatomic) IBOutlet TimelineView *timelineView;

@end
