//
//  GuiGeModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "GuiGeModel.h"
@implementation Propers
-(id)initWithDic:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.number=[[dic objectForKey:@"number"] integerValue];
        self.operation=[[dic objectForKey:@"operation"] integerValue];
        self.range=[[dic objectForKey:@"range"] integerValue];
        self.relation=[dic objectForKey:@"relation"];
        self.relationName=[dic objectForKey:@"relationName"];
        self.value=[dic objectForKey:@"value"];
        self.numberType=[dic objectForKey:@"numberType"];
        self.unit=[dic objectForKey:@"unit"];
    }
    return self;
}
@end
@implementation GuiGeModel
+(GuiGeModel *)creatGuiGeModelWithDic:(NSDictionary *)dic
{
    GuiGeModel *model=[GuiGeModel new];
    model.propertyLists=[NSMutableArray array];
    model.alert=[dic objectForKey:@"alert"];
    model.check=[[dic objectForKey:@"check"] integerValue];
    model.name=[dic objectForKey:@"name"];
    model.main=[[dic objectForKey:@"main"] integerValue];
    model.sort=[[dic objectForKey:@"sort"] integerValue];
    model.type=[dic objectForKey:@"type"];
    model.uid=[dic objectForKey:@"uid"];
    NSArray *propertyAry=[dic objectForKey:@"propertyLists"];
    model.values=[dic objectForKey:@"values"];
    model.propertyLists=[NSMutableArray array];
    model.answerAry=[NSMutableArray array];
    for (int i =0; i<propertyAry.count; i++) {
       NSDictionary *dic =propertyAry[i];
        Propers *propes=[[Propers alloc]initWithDic:dic];
        [model.propertyLists addObject:propes];
    }
    
    return model;
}
@end
