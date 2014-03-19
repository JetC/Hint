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
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.timeLineTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarWithStatusBarHeight, 320, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.timeLineTableView registerNib:[UINib nibWithNibName:@"SFHistoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SFHistoryTableViewCell"];
    self.timeLineTableView.dataSource = self;
    self.timeLineTableView.delegate = self;
    self.timeLineTableView.separatorStyle = NO;
    
//    self.labelIngredientsArray = [[NSArray alloc]init];
//    self.messagesArray = [[NSMutableArray alloc]init];

    
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
    return 33;
}

-(SFHistoryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SFHistoryTableViewCell";
    SFHistoryTableViewCell *cell = [self.timeLineTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[SFHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:cellIdentifier owner:nil options:nil];
    cell = [nib objectAtIndex:0];
    cell.imageOnTableCell.image = [UIImage imageNamed:@"1"];
    cell.labelOnTableCell.text = @"Test";
    NSLog(@"%ld   %@",(long)indexPath.row,cell.labelOnTableCell.text);
    
    return cell;

    
}

//调整行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
