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
    frame.origin.y=116;
    frame.size.width=kWidth;
    frame.size.height=kHeight-116;
    yldBaoJiaMiaoMuView.frame=frame;
    [yldBaoJiaMiaoMuView setBackgroundColor:[UIColor whiteColor]];
    yldBaoJiaMiaoMuView.shuomingLab.userInteractionEnabled=NO;
    return yldBaoJiaMiaoMuView;
}
-(void)setModel:(YLDBaoJiaMiaoMuModel *)model
{
    _model=model;
    self.titleLab.text=model.orderName;
    self.nameLab.text=model.name;
    self.timeLab.text=model.endDate;
    
      self.numLab.text=[NSString stringWithFormat:@"%@棵(株)",model.quantity];
    
    
    self.areaLab.text=model.area;
    [self.areaLab sizeToFit];
    self.priceLab.text=model.quote;
    self.shuomingLab.text=model.descriptions;
    CGRect frame=self.frame;
    frame.origin.y=116;
    frame.size.width=kWidth;
    CGFloat HH  =  CGRectGetMaxY(self.ShUOlAB.frame)+40;
    frame.size.height=HH;
    self.frame=frame;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
