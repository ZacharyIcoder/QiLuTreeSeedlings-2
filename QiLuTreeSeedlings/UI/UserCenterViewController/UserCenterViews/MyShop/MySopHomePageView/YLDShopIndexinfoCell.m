//
//  YLDShopIndexinfoCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/25.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShopIndexinfoCell.h"
#import "UIDefines.h"
#import "UIImageView+AFNetworking.h"
@implementation YLDShopIndexinfoCell
@synthesize shenfenImageV;
+(YLDShopIndexinfoCell *)yldShopIndexinfoCell
{
    YLDShopIndexinfoCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDShopIndexinfoCell" owner:self  options:nil] firstObject];
    cell.touxiangImageV.layer.masksToBounds=YES;
    cell.touxiangImageV.layer.cornerRadius=35;
    cell.rifangWigth.constant=kWidth/2-1;
    return cell;
}
-(void)setModel:(YLDShopIndexModel *)model
{
    _model=model;
    if (model.shopBackgroundUrl.length>0) {
        [self.backImageV setImageWithURL:[NSURL URLWithString:model.shopBackgroundUrl] placeholderImage:[UIImage imageNamed:@"SHOPBACKVIEW"]];
    }
    if (model.shopHeadUrl.length>0) {
        [self.touxiangImageV setImageWithURL:[NSURL URLWithString:model.shopHeadUrl] placeholderImage:[UIImage imageNamed:@"Store.png"]];
    }
    CGRect rect = [model.goldsupplier boundingRectWithSize:CGSizeMake(999, 21)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                        context:nil];
    self.shenfenLab.text=model.goldsupplier;
    self.shenfenLabW.constant=rect.size.width;
    self.moneyLab.text=[NSString stringWithFormat:@"%ld元",model.creditMargin];
    self.fangwenRiLab.text=[NSString stringWithFormat:@"%ld",model.visitDay];
    self.fengxhangZongLab.text=[NSString stringWithFormat:@"%ld",model.visitCount];
    self.fenxhangNumLab.text=[NSString stringWithFormat:@"%ld",model.shareCount];
    if (model.goldsupplierflag == 0 || model.goldsupplierflag == 10) {
        
        shenfenImageV.image = [UIImage imageNamed:@"列表-普通供应商"];
    } else if (model.goldsupplierflag == 1) {
       
        shenfenImageV.image = [UIImage imageNamed:@"列表-金牌供应商"];
    } else if (model.goldsupplierflag == 2) {
        
        shenfenImageV.image = [UIImage imageNamed:@"列表-银牌供应商"];
    } else if (model.goldsupplierflag == 3) {
        
        shenfenImageV.image = [UIImage imageNamed:@"列表-铜牌牌供应商"];
    } else if (model.goldsupplierflag == 4) {
        
        shenfenImageV.image = [UIImage imageNamed:@"列表-认证供应商"];
    } else if (model.goldsupplierflag == 5) {
        
        shenfenImageV.image = [UIImage imageNamed:@"列表-总站"];
    } else if (model.goldsupplierflag == 6) {
        shenfenImageV.image = [UIImage imageNamed:@"列表-分站"];
    } else if (model.goldsupplierflag == 7) {
        shenfenImageV.image = [UIImage imageNamed:@"列表-工程公司"];
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
