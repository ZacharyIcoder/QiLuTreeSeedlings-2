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
-(void)setModel:(YLDJPGYSListModel *)model{
    _model=model;
    self.nameL.text=model.companyName;
    self.addressL.text=model.areaall;
    self.personL.text=[NSString stringWithFormat:@"%@ %@",model.name,model.phone];
    if (model.goldsupplier==1) {
        self.shenfenV.image=[UIImage imageNamed:@"列表-金牌供应商2"];
    }
    if (model.goldsupplier==2) {
        self.shenfenV.image=[UIImage imageNamed:@"列表-银牌供应商2"];
    }
    if (model.goldsupplier==3) {
        self.shenfenV.image=[UIImage imageNamed:@"列表-铜牌供应商2"];
    }
    [self.phoneBtn addTarget:self action:@selector(callAcion) forControlEvents:UIControlEventTouchUpInside];
}
-(void)callAcion
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
