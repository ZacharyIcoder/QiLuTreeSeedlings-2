//
//  YLDJPGYSInfoLabCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPGYSInfoLabCell.h"

@implementation YLDJPGYSInfoLabCell
+(YLDJPGYSInfoLabCell *)yldJPGYSInfoLabCell
{
    YLDJPGYSInfoLabCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDJPGYSInfoLabCell" owner:self options:nil] firstObject];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)setDic:(NSDictionary *)dic
{
    _dic=dic;
    if (dic) {
        self.companyName.text=dic[@"companyName"];
        [self.companyName sizeToFit];
        self.personNameL.text=dic[@"name"];
        self.addressL.text=dic[@"area"];
        NSInteger moneyNub=[dic[@"creditMargin"] integerValue];
        self.moneyL.text=[NSString stringWithFormat:@"%ld元",moneyNub];
    }
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
