//
//  SFHistoryViewController.m
//  Hint
//
//  Created by 孙培峰 on 14-3-16.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import "SFHistoryViewController.h"
#import "SFHistoryTableViewCell.h"

@interface SFHistoryViewController ()

@end

@implementation SFHistoryViewController
@synthesize timeLineTableView = _timeLineTableView;



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
    self.view.backgroundColor = [UIColor whiteColor];
    self.timeLineTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewCellStyleDefault];
    self.timeLineTableView.dataSource = self;
    self.timeLineTableView.delegate = self;
    [self.view addSubview:self.timeLineTableView];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SFHistoryTableViewCell";
    SFHistoryTableViewCell *cell = [self.timeLineTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SFHistoryTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.image = @"1";
    cell.title = @"Test";
    
    return cell;
}

@end
