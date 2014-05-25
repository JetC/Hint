//
//  SFHistoryViewController.m
//  Hint
//
//  Created by 孙培峰 on 14-3-16.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import "SFHistoryViewController.h"
#import "SFRennFriendsListDelegate.h"
#import "SFHistoryCollectionViewCell.h"
#warning 把.pch里面的人人SDK放到合适的文件里


@interface SFHistoryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *lovedPeopleIconImageArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SFHistoryViewController



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

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.lovedPeopleIconImageArray = [[NSMutableArray alloc]init];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadLovedPeopleIcons) name:@"iconsLoadingFinished" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadLovedPeopleIcons) name:@"historyFinished" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadLovedPeopleIcons
{
    self.lovedPeopleIconImageArray = [[NSMutableArray alloc]init];

    for (NSString *lovedPeopleID in [SFRennFriendsListDelegate sharedManager].lovedPeopleIDArray)
    {
        for (id friendInfo in [SFRennFriendsListDelegate sharedManager].friendsListInfoArray)
        {
            if ([[friendInfo objectForKey:@"id"] isEqualToString:lovedPeopleID])
            {
                [self.lovedPeopleIconImageArray addObject:[friendInfo objectForKey:@"iconImage"]];
            }
        }
    }
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [self.collectionView reloadData];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.lovedPeopleIconImageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SFHistoryCollectionViewCell *historyCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    if (historyCollectionViewCell == nil)
    {
        historyCollectionViewCell = [[SFHistoryCollectionViewCell alloc]init];
    }
    if (self.lovedPeopleIconImageArray.count > 0)
    {
        historyCollectionViewCell.imageView.image = [self.lovedPeopleIconImageArray objectAtIndex:indexPath.row];
    }
    return historyCollectionViewCell;
}














@end
