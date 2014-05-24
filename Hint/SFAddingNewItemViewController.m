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

@property (weak, nonatomic) IBOutlet UITableView *theNewItemTableView;

@end


@implementation SFAddingNewItemViewController

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
    [RennClient cancelForDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.theNewItemTableView registerNib:[UINib nibWithNibName:@"SFAddingNewItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"SFAddingNewItemTableViewCell"];
    self.theNewItemTableView.delegate = self;
    self.theNewItemTableView.dataSource = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    [self.view addSubview:self.theNewItemTableView];

    [[SFRennFriendsListDelegate sharedManager] loadListForTheTime:1];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableViewData) name:@"reloadTableViewData" object:nil];
}

- (void)reloadTableViewData
{
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [_theNewItemTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SFRennFriendsListDelegate sharedManager].friendsListInfoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SFAddingNewItemTableViewCell";
    SFAddingNewItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[SFAddingNewItemTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    cell.nameLabel.text = [[[SFRennFriendsListDelegate sharedManager].friendsListInfoArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    if ([SFRennFriendsListDelegate sharedManager].hasIconLoadingFinished == YES)
    {
        cell.iconImageView.image = [[[SFRennFriendsListDelegate sharedManager].friendsListInfoArray objectAtIndex:indexPath.row] objectForKey:@"iconImage"];
    }

    NSLog(@"IndexPath.row : %d",indexPath.row);

//    NSLog(@"Icon : %@",[[SFRennFriendsListDelegate sharedManager].iconImagesArray objectAtIndex:indexPath.row]);
//    NSLog(@"iconImagesArrayCount : %d",[SFRennFriendsListDelegate sharedManager].iconImagesArray.count);

    NSLog(@"Now On Screen: %li",(long)indexPath.row);
    return cell;
}




























@end
