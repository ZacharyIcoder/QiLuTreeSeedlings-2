//
//  BuyOtherInfoTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/8.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "BuyOtherInfoTableViewCell.h"
#import "UIDefines.h"
#import "BuyDetialModel.h"
@implementation BuyOtherInfoTableViewCell
-(instancetype)init {
    self = [super init];
    if(self) {
//        UIButton *showBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, kWidth, 40)];
//        [showBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//        [showBtn setTitleColor:NavColor forState:UIControlStateNormal];
//        [showBtn setTitleColor:NavColor forState:UIControlStateSelected];
//        [self addSubview:showBtn];
//        self.showBtn=showBtn;
//        [showBtn setTitle:@"展开隐藏" forState:UIControlStateNormal];
//        [showBtn setTitle:@"点击隐藏" forState:UIControlStateSelected];
//        [showBtn setImage:[UIImage imageNamed:@"rolock"] forState:UIControlStateSelected];
//        [showBtn setImage:[UIImage imageNamed:@"rounlock"] forState:UIControlStateNormal];
    }
    
    return self;
}
-(id)initWithFrame:(CGRect)frame andName:(NSString *)name
{
    self=[super initWithFrame:frame];
    if (self) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 5, kWidth, 30)];
        UILabel *keylab=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 20)];
        keylab.text=@"苗木名称";
        [keylab setTextAlignment:NSTextAlignmentRight];
        [keylab setFont:[UIFont systemFontOfSize:13]];
        [keylab setTextColor:detialLabColor];
        [view addSubview:keylab];
        UILabel *valueLab=[[UILabel alloc]initWithFrame:CGRectMake(130, -5, 185/320.f*kWidth, 40)];
        valueLab.numberOfLines=0;
        valueLab.text=name;
        [valueLab setFont:[UIFont systemFontOfSize:14]];
        [valueLab setTextColor:titleLabColor];
        [view addSubview:valueLab];
        [self addSubview:view];
//        UIButton *showBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 40, kWidth, 40)];
//        [showBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//        [showBtn setTitleColor:NavColor forState:UIControlStateNormal];
//        [showBtn setTitleColor:NavColor forState:UIControlStateSelected];
//        self.showBtn=showBtn;
//        [self addSubview:showBtn];
//        [showBtn setTitle:@"展开隐藏" forState:UIControlStateNormal];
//        [showBtn setTitle:@"点击隐藏" forState:UIControlStateSelected];
//        [showBtn setImage:[UIImage imageNamed:@"rolock"] forState:UIControlStateSelected];
//        [showBtn setImage:[UIImage imageNamed:@"rounlock"] forState:UIControlStateNormal];
    }
    return self;
}
-(void)setAry:(NSArray *)ary
{
    _ary=ary;
    //self.youzhiAry=[NSMutableArray array];
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        [self MackViewWithFrame:CGRectMake(0, i*30+35, kWidth, 30) andDic:dic];
    }
}
-(void)setDingzhiAry:(NSArray *)dingzhiAry
{
    _dingzhiAry=dingzhiAry;
    for (int i=0; i<dingzhiAry.count; i++) {
        NSDictionary *dic=dingzhiAry[i];
        [self MackViewWithFrame:CGRectMake(0, i*30+5, kWidth, 30) andDic:dic];
    }



    CGRect frame=self.showBtn.frame;
    frame.origin.y=_dingzhiAry.count*30;
    self.showBtn.frame=frame;

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
    [keylab setTextColor:detialLabColor];
    [view addSubview:keylab];
    UILabel *valueLab=[[UILabel alloc]initWithFrame:CGRectMake(130, -5, 185/320.f*kWidth, 40)];
    valueLab.numberOfLines=0;
    NSArray *valueAry=[dic objectForKey:@"values"];
    NSMutableString *valueStr;
    if (valueAry.count==1) {
        valueStr=[NSMutableString stringWithFormat:@"%@",valueAry[0]];
        
    }else
    {
        
        if (valueAry.count>1) {
            NSString *type=[dic objectForKey:@"type"];
            valueStr=[NSMutableString stringWithFormat:@"%@",valueAry[0]];
            for (int k=1; k<valueAry.count; k++) {
                if ([type isEqualToString:@"复选"]) {
                    [valueStr appendFormat:@",%@",valueAry[k]];
                }
                if ([type isEqualToString:@"文本"]) {
                    if (k==1) {
                        [valueStr appendFormat:@" - %@",valueAry[k]];
                    }
                    if (k==0) {
                        [valueStr appendFormat:@" %@",valueAry[k]];
                    }

                }
                if ([type isEqualToString:@"单选结合"]) {
                    if (k==2) {
                        [valueStr appendFormat:@" - %@",valueAry[k]];
                    }
                    if (k==1) {
                        [valueStr appendFormat:@" %@",valueAry[k]];
                    }
                    
                }
                
            }
//            valueStr appendFormat:@" %@",
        }
        
    }
    NSString *unit=[dic objectForKey:@"unit"];
    if (unit.length>0) {
        [valueStr appendFormat:@" %@",unit];
    }
    valueLab.text=valueStr;
    [valueLab setFont:[UIFont systemFontOfSize:14]];
    [valueLab setTextColor:titleLabColor];
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
