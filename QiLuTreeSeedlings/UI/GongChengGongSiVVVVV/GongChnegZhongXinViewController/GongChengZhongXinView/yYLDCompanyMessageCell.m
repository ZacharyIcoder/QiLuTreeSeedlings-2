//
//  yYLDCompanyMessageCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "yYLDCompanyMessageCell.h"

@implementation yYLDCompanyMessageCell
+(yYLDCompanyMessageCell *)yyldCompanyMessageCell
{
    yYLDCompanyMessageCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"yYLDCompanyMessageCell" owner:self options:nil] lastObject];
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