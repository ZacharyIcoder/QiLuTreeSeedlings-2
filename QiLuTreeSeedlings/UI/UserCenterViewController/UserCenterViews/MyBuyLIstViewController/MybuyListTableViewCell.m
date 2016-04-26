//
//  MybuyListTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/26.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MybuyListTableViewCell.h"

@implementation MybuyListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(NSString *)IDStr
{
    return @"SellSearchTableViewCell2";
}
-(void)setHotBuyModel:(HotBuyModel *)hotBuyModel
{
    _hotBuyModel=hotBuyModel;
    self.titleLab.text=hotBuyModel.title;
    self.cityLab.text=hotBuyModel.area;
    
    self.timeLab.text=hotBuyModel.timeAger;
    
    
    NSArray *priceAry=[hotBuyModel.price componentsSeparatedByString:@"."];
    self.priceLab.text=[priceAry firstObject];
    if (hotBuyModel.isSelect) {
        self.selected = YES;
        self.isSelect = YES;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.timeimage setBackgroundColor:[UIColor whiteColor]];
    [self.dingweiimage setBackgroundColor:[UIColor whiteColor]];
    // Configure the view for the selected state
}

@end
