//
//  YLDJPGYSDBigCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/9/12.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDJPGYSDBigCell.h"
#import "UIImageView+AFNetworking.h"
@implementation YLDJPGYSDBigCell
+(id)YLDJPGYSDBigCell
{
    YLDJPGYSDBigCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDJPGYSDBigCell" owner:self options:nil] firstObject];
    cell.touxiangImgV.layer.masksToBounds=YES;
    cell.touxiangImgV.layer.cornerRadius=40;
    return cell;
}
-(void)setDic:(NSDictionary *)dic{
    _dic=dic;
    NSInteger goldsupplier=[dic[@"goldsupplier"] integerValue];
    if (goldsupplier==2) {
        self.shenfenLab.text=@"金牌供应商";
    }
    if (goldsupplier==1) {
        self.shenfenLab.text=@"银牌供应商";
    }
    if (goldsupplier==1) {
        self.shenfenLab.text=@"铜牌供应商";
    }
    self.companyNameL.text=dic[@"companyName"];
    self.nameLab.text=dic[@"name"];
    NSString *headUrl=dic[@"headUrl"];
    if (headUrl.length>0) {
        [self.touxiangImgV setImageWithURL:[NSURL URLWithString:headUrl]];
    }
}
-(void)setMyDic:(NSDictionary *)myDic
{
    _myDic=myDic;
    self.shenfenLab.text=@"金牌中心";
    [self.backBtn setImage:nil forState:UIControlStateNormal];
    [self.backBtn setTitle:@"苗信通" forState:UIControlStateNormal];
    self.backBtnW.constant=65;
    [self.backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.companyNameL.text=myDic[@"companyName"];
    self.nameLab.text=myDic[@"name"];
    NSString *headUrl=myDic[@"headUrl"];
    if (headUrl.length>0) {
        [self.touxiangImgV setImageWithURL:[NSURL URLWithString:headUrl]];
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
