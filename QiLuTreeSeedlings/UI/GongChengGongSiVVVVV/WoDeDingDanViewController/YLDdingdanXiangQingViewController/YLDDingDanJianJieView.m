//
//  YLDDingDanJianJieView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDDingDanJianJieView.h"
#import "UIDefines.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@implementation YLDDingDanJianJieView
+(YLDDingDanJianJieView *)yldDingDanJianJieView
{
    YLDDingDanJianJieView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDDingDanJianJieView" owner:self options:nil] lastObject];
    CGRect frame=view.frame;
    frame.size.width=kWidth;
    frame.size.height=kHeight-115;
    view.frame=frame;
    view.shuomingTextField.editable=NO;
    [view.shuomingTextField setTextColor:DarkTitleColor];
    [view.shuomingTextField setFont:[UIFont systemFontOfSize:15]];
    [view.callBtn setEnlargeEdgeWithTop:0 right:10 bottom:5 left:150];
    
    return view;
}
-(void)callAction
{
    if (self.model.phone.length>0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.hezuomodel.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
   
    //            NSLog(@"str======%@",str);
    
}
-(void)setModel:(YLDDingDanDetialModel *)model
{
    _model=model;
    self.nameLab.text=model.orderName;
    [self.nameLab sizeToFit];
    self.dingdanTypeLab.text=model.orderType;
    NSArray *timeAry=[model.endDate componentsSeparatedByString:@" "];
    self.companyLab.text=model.company;
    self.endTimeLab.text=[timeAry firstObject];
    self.baojiaTypeLab.text=model.quotationRequired;
    self.zhiliangLab.text=model.quantityRequired;
    NSString *oldStr=[NSString stringWithFormat:@"胸径离地面%@CM处，地径离地面%@CM处",model.dbh,model.groundDiameter];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:oldStr];
    [str addAttribute:NSForegroundColorAttributeName value:NavColor range:NSMakeRange(5,model.dbh.length+2)];
    [str addAttribute:NSForegroundColorAttributeName value:NavColor range:NSMakeRange(14+model.dbh.length,model.groundDiameter.length+2)];
    
    self.ciliangLab.attributedText=str;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.ciliangLab.font,NSFontAttributeName, nil];
    CGSize sizeOne = [model.measureRequired boundingRectWithSize:CGSizeMake(self.ciliangLab.frame.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    self.celiangHeight.constant=sizeOne.height+5;
   //    self.companyLab.text=model.
    self.shuomingTextField.text=model.descriptionzz;
    self.areaLab.text=model.area;
    [self.areaLab sizeToFit];
    self.phoneLab.text=model.phone;
    if (model.auditStatus==0) {
        [self.logoImageV setImage:[UIImage imageNamed:@"待审核"]];
    }else
    {
        if ([model.status isEqualToString:@"报价中"]) {
            [self.logoImageV setImage:[UIImage imageNamed:@"zt报价中"]];
        }
        if ([model.status isEqualToString:@"已结束"]) {
            [self.logoImageV setImage:[UIImage imageNamed:@"zt已结束"]];
        }
    }
   
    [self.callBtn addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setHezuomodel:(YLDHeZuoDetial *)hezuomodel
{
    _hezuomodel=hezuomodel;
    self.nameLab.text=hezuomodel.orderName;
    self.dingdanTypeLab.text=hezuomodel.orderType;
    NSArray *timeAry=[hezuomodel.endDate componentsSeparatedByString:@" "];
    self.endTimeLab.text=[timeAry firstObject];
    self.baojiaTypeLab.text=hezuomodel.quotationRequired;
    self.zhiliangLab.text=[NSString stringWithFormat:@"%@",hezuomodel.quantityRequired];
    
    NSString *oldStr=[NSString stringWithFormat:@"胸径离地面%@CM处，地径离地面%@CM处",hezuomodel.dbh,hezuomodel.groundDiameter];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:oldStr];
     	[str addAttribute:NSForegroundColorAttributeName value:NavColor range:NSMakeRange(5,hezuomodel.dbh.length+2)];
     	[str addAttribute:NSForegroundColorAttributeName value:NavColor range:NSMakeRange(14+hezuomodel.dbh.length,hezuomodel.groundDiameter.length+2)];

    self.ciliangLab.attributedText=str;
    self.companyLab.text=hezuomodel.company;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.ciliangLab.font,NSFontAttributeName, nil];
    CGSize sizeOne = [[NSString stringWithFormat:@"胸径离地面%@CM处，地径离地面%@CM处",hezuomodel.dbh,hezuomodel.groundDiameter] boundingRectWithSize:CGSizeMake(self.ciliangLab.frame.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    self.celiangHeight.constant=sizeOne.height+5;
    //    self.companyLab.text=model.
    self.shuomingTextField.text=hezuomodel.descriptions;
    self.areaLab.text=hezuomodel.area;
    [self.areaLab sizeToFit];
    self.phoneLab.text=hezuomodel.phone;
   
    if ([hezuomodel.status isEqualToString:@"已结束"]) {
        [self.logoImageV setImage:[UIImage imageNamed:@"zt已结束"]];
    }
    if ([hezuomodel.status isEqualToString:@"报价中"]) {
        [self.logoImageV setImage:[UIImage imageNamed:@"zt报价中"]];
    }
    [self.callBtn addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];     

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
