//
//  SFSettingViewController.m
//  Hint
//
//  Created by 孙培峰 on 14-3-15.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import "SFSettingViewController.h"

@interface SFSettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *pushNotificationSwitcher;

@end

@implementation SFSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
