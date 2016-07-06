//
//  YLDGCZXTouxiangTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/6.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGCZXTouxiangTableViewCell.h"
#import "UIDefines.h"
@implementation YLDGCZXTouxiangTableViewCell
+(YLDGCZXTouxiangTableViewCell *)yldGCZXTouxiangTableViewCell
{
    YLDGCZXTouxiangTableViewCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDGCZXTouxiangTableViewCell" owner:self options:nil] lastObject];
    cell.imagev.layer.masksToBounds=YES;
    cell.imagev.layer.cornerRadius=15;
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
