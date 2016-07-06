//
//  YLDGCZXInfoTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/6.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGCZXInfoTableViewCell.h"
#import "UIDefines.h"
@implementation YLDGCZXInfoTableViewCell
+(YLDGCZXInfoTableViewCell *)yldGCZXInfoTableViewCell
{
    YLDGCZXInfoTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDGCZXInfoTableViewCell" owner:self options:nil] lastObject];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    UIImageView *imaLine=[[UIImageView alloc]initWithFrame:CGRectMake(10, 49, kWidth-20, 1)];
    [cell addSubview:imaLine];
    [imaLine setBackgroundColor:kLineColor];
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
