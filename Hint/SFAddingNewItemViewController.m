//
//  SFAddingNewItemViewController.m
//  Hint
//
//  Created by 孙培峰 on 14-3-16.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import "SFAddingNewItemViewController.h"
#import "SFRennFriendsListDelegate.h"
#import "SFAddingNewItemTableViewCell.h"


@interface SFAddingNewItemViewController ()

@property (nonatomic, strong) UITableView *theNewItemTableView;
//@property (nonatomic, strong) SFRennFriendsListDelegate *rennFriendsListDelegate;
@property (nonatomic, strong) NSMutableArray *friendsListArray;

@end


@implementation SFAddingNewItemViewController
@synthesize theNewItemTableView = _theNewItemTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
//    [RennClient cancelForDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.theNewItemTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarWithStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.theNewItemTableView registerNib:[UINib nibWithNibName:@"SFAddingNewItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"SFAddingNewItemTableViewCell"];
    self.theNewItemTableView.delegate = self;
    self.theNewItemTableView.dataSource = self;
    self.theNewItemTableView.contentInset = UIEdgeInsetsMake(0, 0, kNavigationBarWithStatusBarHeight+kTabBarHeight, 0);
    [self.view addSubview:self.theNewItemTableView];
    
    
//    BOOL i = YES;
//    i = self.rennFriendsListDelegate.hasLoadingFriendsListFinished;
    self.friendsListArray = [SFRennFriendsListDelegate sharedManager].friendsListArray;
    if (self.friendsListArray.count == 0)
    {
        NSLog(@"Array is Nil!");
        [SFRennFriendsListDelegate sharedManager];
    }
    else
    {
        [self.theNewItemTableView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.friendsListArray.count == 0)
    {
        self.friendsListArray = [SFRennFriendsListDelegate sharedManager].friendsListArray;
        [self.theNewItemTableView reloadData];
    }
    
    static NSString *cellIdentifier = @"SFAddingNewItemTableViewCell";
    SFAddingNewItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[SFAddingNewItemTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.nameLabel.text = [self.friendsListArray objectAtIndex:indexPath.row];
    NSLog(@"%@",[self.friendsListArray objectAtIndex:indexPath.row]);
    NSLog(@"%li:%@",(long)indexPath.row,cell.nameLabel.text);
    return cell;
}




























@end
