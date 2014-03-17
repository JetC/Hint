//
//  SFHistoryTableViewCell.m
//  Hint
//
//  Created by 孙培峰 on 14-3-16.
//  Copyright (c) 2014年 孙培峰. All rights reserved.
//

#import "SFHistoryTableViewCell.h"

@interface SFHistoryTableViewCell()

@end

@implementation SFHistoryTableViewCell
@synthesize imageOnTableCell;
@synthesize labelOnTableCell;
@synthesize image;
@synthesize title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImage:(NSString *)image
{
    self.imageOnTableCell.image = [UIImage imageNamed:[image copy]];
}

- (void)setTitle:(NSString *)title
{
    self.labelOnTableCell.text = [self.title copy];
    //此时对“title”的修改就被变为了直接修改Lable的标题
}

@end
