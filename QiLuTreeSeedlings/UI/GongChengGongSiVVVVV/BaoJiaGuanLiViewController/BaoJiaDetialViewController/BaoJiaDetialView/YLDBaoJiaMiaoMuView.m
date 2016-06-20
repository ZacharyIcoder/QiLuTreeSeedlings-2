//
//  YLDBaoJiaMiaoMuView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDBaoJiaMiaoMuView.h"
#import "UIDefines.h"
@implementation YLDBaoJiaMiaoMuView
+(YLDBaoJiaMiaoMuView *)yldBaoJiaMiaoMuView
{
    YLDBaoJiaMiaoMuView *yldBaoJiaMiaoMuView=[[[NSBundle mainBundle]loadNibNamed:@"YLDBaoJiaMiaoMuView" owner:self options:nil] lastObject];
    CGRect frame=yldBaoJiaMiaoMuView.frame;
    frame.origin.y=115;
    frame.size.width=kWidth;
    frame.size.height=kHeight-115;
    yldBaoJiaMiaoMuView.frame=frame;
    return yldBaoJiaMiaoMuView;
}
-(void)setModel:(YLDBaoJiaMiaoMuModel *)model
{
    _model=model;
    self.timeLab.text=model.orderName;
    self.nameLab.text=model.name;
    self.timeLab.text=model.endDate;
    self.numLab.text=model.quantity;
    self.areaLab.text=model.area;
    self.priceLab.text=model.quote;
    self.shuomingLab.text=model.descriptions;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
