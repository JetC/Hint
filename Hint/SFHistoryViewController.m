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

//@property (nonatomic, strong) NSMutableArray *messagesArray;
//@property (nonatomic, strong) NSArray *labelIngredientsArray;
@property (nonatomic,strong) UITableView *timeLineTableView;

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
    
    cell.imageOnTableCell.image = [UIImage imageNamed:@"1"];
    cell.labelOnTableCell.text = @"Test";
    

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
