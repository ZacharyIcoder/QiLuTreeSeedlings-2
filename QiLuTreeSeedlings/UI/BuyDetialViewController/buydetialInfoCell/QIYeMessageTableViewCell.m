//
//  QIYeMessageTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/8.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "QIYeMessageTableViewCell.h"
@interface QIYeMessageTableViewCell ()
@property (nonatomic,strong)UILabel *addressLab;
@property (nonatomic,strong)UILabel *creatTimeLab;
@property (nonatomic,strong)UILabel *endTimeLab;
@property (nonatomic,strong)UILabel *phoneLab;
@end
@implementation QIYeMessageTableViewCell

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        UILabel *dizhiLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 20)];
        [dizhiLab setFont:[UIFont systemFontOfSize:13]];
        [dizhiLab setTextAlignment:NSTextAlignmentRight];
        [dizhiLab setTextColor:[UIColor lightGrayColor]];
         dizhiLab.text=@"地址";
        [self addSubview:dizhiLab];
       
        self.addressLab=[[UILabel alloc]initWithFrame:CGRectMake(130, 5, 200, 20)];
        [self.addressLab setFont:[UIFont systemFontOfSize:13]];
//        [self.addressLab setTextAlignment:NSTextAlignmentRight];
        [self.addressLab setTextColor:[UIColor grayColor]];
//        dizhiLab.text=@"地址";
        [self addSubview:self.addressLab];
        
        UILabel *fabuTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 35, 80, 20)];
        [fabuTimeLab setFont:[UIFont systemFontOfSize:13]];
        [fabuTimeLab setTextAlignment:NSTextAlignmentRight];
        [fabuTimeLab setTextColor:[UIColor lightGrayColor]];
        fabuTimeLab.text=@"发布日期";
        [self addSubview:fabuTimeLab];
        
        self.creatTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(130, 35, 200, 20)];
        [self.creatTimeLab setFont:[UIFont systemFontOfSize:13]];
//        [self.creatTimeLab setTextAlignment:NSTextAlignmentRight];
        [self.creatTimeLab setTextColor:[UIColor grayColor]];
        //        dizhiLab.text=@"地址";
        [self addSubview:self.creatTimeLab];
        
        UILabel *youxiaoTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 65, 80, 20)];
        [youxiaoTimeLab setFont:[UIFont systemFontOfSize:13]];
        [youxiaoTimeLab setTextAlignment:NSTextAlignmentRight];
        [youxiaoTimeLab setTextColor:[UIColor lightGrayColor]];
        youxiaoTimeLab.text=@"有效日期";
        [self addSubview:youxiaoTimeLab];
        
        self.endTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(130, 65, 200, 20)];
        [self.endTimeLab setFont:[UIFont systemFontOfSize:13]];
//        [self.endTimeLab setTextAlignment:NSTextAlignmentRight];
        [self.endTimeLab setTextColor:[UIColor grayColor]];
        //        dizhiLab.text=@"地址";
        [self addSubview:self.endTimeLab];
        
        UILabel *lianxiLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 95, 80, 20)];
        [lianxiLab setFont:[UIFont systemFontOfSize:13]];
        [lianxiLab setTextAlignment:NSTextAlignmentRight];
        [lianxiLab setTextColor:[UIColor lightGrayColor]];
        lianxiLab.text=@"联系方式";
        [self addSubview:lianxiLab];
        
        self.phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(130, 95, 200, 20)];
        [self.phoneLab setFont:[UIFont systemFontOfSize:13]];
        [self.phoneLab setTextColor:[UIColor grayColor]];
        [self addSubview:self.phoneLab];
    }
    return self;
}

-(void)setDic:(NSDictionary *)dic
{
    _dic=dic;
    self.addressLab.text=[dic objectForKey:@"address"];
    self.creatTimeLab.text=[dic objectForKey:@"createTime"];
    self.endTimeLab.text=[dic objectForKey:@"endTime"];
    self.phoneLab.text=[dic objectForKey:@"phone"];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
