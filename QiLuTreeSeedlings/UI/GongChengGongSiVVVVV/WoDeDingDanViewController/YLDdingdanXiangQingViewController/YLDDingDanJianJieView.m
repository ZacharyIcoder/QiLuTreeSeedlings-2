//
//  YLDDingDanJianJieView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDDingDanJianJieView.h"
#import "UIDefines.h"
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
   
      return view;
}
-(void)setModel:(YLDDingDanDetialModel *)model
{
    _model=model;
    self.nameLab.text=model.orderName;
    self.dingdanTypeLab.text=model.orderType;
    NSArray *timeAry=[model.endDate componentsSeparatedByString:@" "];
    self.endTimeLab.text=[timeAry firstObject];
    self.baojiaTypeLab.text=model.quotationRequired;
    self.zhiliangLab.text=model.quantityRequired;
    self.ciliangLab.text=model.measureRequired;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.ciliangLab.font,NSFontAttributeName, nil];
    CGSize sizeOne = [model.measureRequired boundingRectWithSize:CGSizeMake(self.ciliangLab.frame.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    self.celiangHeight.constant=sizeOne.height+5;
   //    self.companyLab.text=model.
    self.shuomingTextField.text=model.descriptionzz;
    self.areaLab.text=model.area;
    self.phoneLab.text=model.phone;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
