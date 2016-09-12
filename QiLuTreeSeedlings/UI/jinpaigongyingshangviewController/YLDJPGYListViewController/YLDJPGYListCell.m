//
//  YLDJPGYListCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPGYListCell.h"

@implementation YLDJPGYListCell
+(YLDJPGYListCell *)yldJPGYListCell
{
    YLDJPGYListCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDJPGYListCell" owner:self options:nil] firstObject];
    
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
