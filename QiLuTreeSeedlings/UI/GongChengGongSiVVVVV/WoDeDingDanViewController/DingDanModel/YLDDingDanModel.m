//
//  YLDDingDanModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDDingDanModel.h"
#import "UIDefines.h"
@implementation YLDDingDanModel
+(YLDDingDanModel *)yldDingDanModelWithDic:(NSDictionary *)dic
{
    YLDDingDanModel *model=[YLDDingDanModel new];
    model.area=[dic objectForKey:@"area"];
    model.endDate=[dic objectForKey:@"endDate"];
    model.miaomu=[dic objectForKey:@"miaomu"];
    model.orderDate=[dic objectForKey:@"orderDate"];
    model.orderName=[dic objectForKey:@"orderName"];
    model.orderType=[dic objectForKey:@"orderType"];
    model.quotation=[dic objectForKey:@"quotation"];
    model.status=[dic objectForKey:@"status"];
    model.uid=[dic objectForKey:@"uid"];
    model.showHeight=250-18+[YLDDingDanModel getHeightWithContent:model.miaomu width:kWidth-140 font:14];
    model.isShow=NO;
    return model;
}
+(NSArray *)YLDDingDanModelAryWithAry:(NSArray *)ary{
    NSMutableArray *Ary=[NSMutableArray array];
    for (int i=0; i<ary.count ; i++) {
        NSDictionary *dic=ary[i];
        YLDDingDanModel *model=[YLDDingDanModel yldDingDanModelWithDic:dic];
        [Ary addObject:model];
    }
    return Ary;
}
//获取字符串的高度
+(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
}
@end
