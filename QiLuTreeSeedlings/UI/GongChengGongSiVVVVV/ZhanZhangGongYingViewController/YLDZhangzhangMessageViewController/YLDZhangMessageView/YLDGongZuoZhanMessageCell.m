//
//  YLDGongZuoZhanMessageCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGongZuoZhanMessageCell.h"

@implementation YLDGongZuoZhanMessageCell
+(YLDGongZuoZhanMessageCell *)yldGongZuoZhanMessageCell
{
    YLDGongZuoZhanMessageCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDGongZuoZhanMessageCell" owner:self options:nil] lastObject];
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