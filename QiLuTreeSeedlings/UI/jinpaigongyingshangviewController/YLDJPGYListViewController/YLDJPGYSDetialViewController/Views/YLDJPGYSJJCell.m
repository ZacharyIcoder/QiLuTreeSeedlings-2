//
//  YLDJPGYSJJCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPGYSJJCell.h"
#import "UIDefines.h"
@implementation YLDJPGYSJJCell
+(YLDJPGYSJJCell *)yldJPGYSJJCell
{
    YLDJPGYSJJCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"YLDJPGYSJJCell" owner:self options:nil] firstObject];
    [cell.chakanBtn setTitle:@"隐藏更多" forState:UIControlStateSelected];
    [cell.chakanBtn setTitleColor:NavColor forState:UIControlStateSelected];
    [cell.chakanBtn setImage:[UIImage imageNamed:@"rolock"] forState:UIControlStateSelected];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setJianjieStr:(NSString *)jianjieStr
{
    _jianjieStr=jianjieStr;
    self.jianjieL.text=jianjieStr;
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
