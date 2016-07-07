//
//  YLDGongZuoZhanJianJieCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGongZuoZhanJianJieCell.h"
#import "UIDefines.h"
@implementation YLDGongZuoZhanJianJieCell
+(YLDGongZuoZhanJianJieCell *)yldGongZuoZhanJianJieCell
{
    YLDGongZuoZhanJianJieCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDGongZuoZhanJianJieCell" owner:self options:nil] lastObject];
    [cell.moreBtn setTitle:@"隐藏更多" forState:UIControlStateSelected];
    [cell.moreBtn setTitleColor:NavColor forState:UIControlStateSelected];
    return cell;
}
-(void)setJianjieStr:(NSString *)jianjieStr
{
    _jianjieStr=jianjieStr;
    self.jianjieLab.text=jianjieStr;
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
