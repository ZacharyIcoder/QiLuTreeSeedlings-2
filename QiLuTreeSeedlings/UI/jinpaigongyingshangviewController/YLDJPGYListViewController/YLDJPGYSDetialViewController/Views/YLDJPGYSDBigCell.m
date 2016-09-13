//
//  YLDJPGYSDBigCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPGYSDBigCell.h"

@implementation YLDJPGYSDBigCell
+(id)YLDJPGYSDBigCell
{
    YLDJPGYSDBigCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDJPGYSDBigCell" owner:self options:nil] firstObject];
    cell.touxiangImgV.layer.masksToBounds=YES;
    cell.touxiangImgV.layer.cornerRadius=40;
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
