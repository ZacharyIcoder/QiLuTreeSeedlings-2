//
//  YLDShenFenShuoMingCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShenFenShuoMingCell.h"

@implementation YLDShenFenShuoMingCell
+(YLDShenFenShuoMingCell *)yldShenFenShuoMingCell
{
    YLDShenFenShuoMingCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDShenFenShuoMingCell" owner:self options:nil] lastObject];
    return cell;
    
}
-(void)setDic:(NSDictionary *)dic
{
    _dic=dic;
    self.titleLab.text=dic[@"title"];
    self.detialLab.text=dic[@"detial"];
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
