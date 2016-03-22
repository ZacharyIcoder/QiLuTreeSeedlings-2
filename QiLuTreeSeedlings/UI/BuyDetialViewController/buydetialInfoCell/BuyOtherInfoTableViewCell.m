//
//  BuyOtherInfoTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/8.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "BuyOtherInfoTableViewCell.h"
#import "UIDefines.h"
@implementation BuyOtherInfoTableViewCell
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)setAry:(NSArray *)ary
{
    _ary=ary;
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        [self MackViewWithFrame:CGRectMake(0, i*30+5, kWidth, 30) andDic:dic];
    }
}
-(void)MackViewWithFrame:(CGRect)frame andDic:(NSDictionary *)dic
{
    
//        name = "\U80f8\U5f84";
//        unit = "\U7c73";
//        value =1
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UILabel *keylab=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 20)];
    keylab.text=[dic objectForKey:@"name"];
    [keylab setTextAlignment:NSTextAlignmentRight];
    [keylab setFont:[UIFont systemFontOfSize:13]];
    [keylab setTextColor:[UIColor lightGrayColor]];
    [view addSubview:keylab];
    
    UILabel *valueLab=[[UILabel alloc]initWithFrame:CGRectMake(130, 5, 200, 20)];
    NSArray *valueAry=[dic objectForKey:@"value"];
    NSString *valueStr;
    if (valueAry.count==1) {
        valueStr=[NSString stringWithFormat:@"%@ %@",valueAry[0],[dic objectForKey:@"unit"]];
    }else
    {
        valueStr=[NSString stringWithFormat:@"%@~%@ %@",valueAry[0],[valueAry lastObject],[dic objectForKey:@"unit"]];
    }
    
    valueLab.text=valueStr;
    [valueLab setFont:[UIFont systemFontOfSize:13]];
    [valueLab setTextColor:[UIColor grayColor]];
    [view addSubview:valueLab];
    [self addSubview:view];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
