//
//  YLDHeZuoDEMessageCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDHeZuoDEMessageCell.h"
#import "YLDHeZuoDetialGZZView.h"
#import "UIDefines.h"
@implementation YLDHeZuoDEMessageCell
+(YLDHeZuoDEMessageCell *)yldHeZuoDEMessageCell
{
    YLDHeZuoDEMessageCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDHeZuoDEMessageCell" owner:self options:nil] lastObject];

    return cell;
}
-(void)setDic:(NSDictionary *)dic
{
    _dic=dic;
    self.nameLab.text=[dic objectForKey:@"name"];
    self.shuliangLab.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"quantity"]];
    NSString *shuomingStr=[dic objectForKey:@"description"];
    if (shuomingStr.length>0) {
        self.shuomingLab.text=[NSString stringWithFormat:@"规格要求：%@",shuomingStr];
        CGFloat height=[self getHeightWithContent:self.shuomingLab.text width:kWidth-41 font:15];
        self.shuomingH.constant=height+5;
    }else{
        self.shuomingLab.text=@"规格要求：";
        self.shuomingH.constant=20;
    }
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YLDHeZuoDetialGZZView class]]) {
            [obj removeFromSuperview];
        }
    }];
    NSArray *gongzuozhanAry=dic[@"cooperateQuoteList"];
    for (int i=0; i<gongzuozhanAry.count; i++) {
        YLDHeZuoDetialGZZView *zzview =[YLDHeZuoDetialGZZView yldHeZuoDetialGZZView];
        CGRect frame=zzview.frame;
        frame.origin.y=55+self.shuomingH.constant+i*85;
        frame.size.width=self.contentView.frame.size.width;
        zzview.frame=frame;
        zzview.dic=gongzuozhanAry[i];
        [self.contentView addSubview:zzview];
//        zzview.hidden=YES;
    }
    
    if (gongzuozhanAry.count>0) {
        CGRect frame=self.frame;
         frame.origin.y=85+gongzuozhanAry.count*85;
        self.frame=frame;
    }else{
        CGRect frame=self.frame;
        frame.size.height=80;
        self.frame=frame;
    }
   
}
//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
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
