//
//  SFHistoryViewController.m
//  Hint
//
//  Created by 孙培峰 on 14-3-16.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import "SFHistoryViewController.h"
#import "SFHistoryTableViewCell.h"
#warning 把.pch里面的人人SDK放到合适的文件里


@interface SFHistoryViewController ()

@property (nonatomic,strong) UITableView *timeLineTableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

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
//老黄说这里没问题
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.timeLineTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarWithStatusBarHeight, 320, SCREEN_HEIGHT) ];
    [self.timeLineTableView registerNib:[UINib nibWithNibName:@"SFHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"SFHistoryTableViewCell"];
    self.timeLineTableView.dataSource = self;
    self.timeLineTableView.delegate = self;
    
    self.timeLineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.timeLineTableView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight+kNavigationBarWithStatusBarHeight, 0);
    
    
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

#pragma mark TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//FIXME:应该为return  count类型，随时变化
    return 323;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SFHistoryTableViewCell";
    SFHistoryTableViewCell *cell = [self.timeLineTableView dequeueReusableCellWithIdentifier:cellIdentifier];

//TODO:查这两句的意思
//    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:nil options:nil];
//    cell = [nib objectAtIndex:0];
    if (indexPath.row % 2 == 0)
    {
        cell.imageOnTableCell.image = [UIImage imageNamed:@"UP TimeLine"];
    }
    else
    {
        cell.imageOnTableCell.image = [UIImage imageNamed:@"Down TimeLine"];
    }
    
    cell.labelOnTableCell.text = [NSString stringWithFormat:@"Test %ld",(long)indexPath.row];
    

    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



//调整行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
