//
//  SellQiyeInfoTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/14.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SellQiyeInfoTableViewCell.h"
#import "UIDefines.h"
@interface SellQiyeInfoTableViewCell ()
@property (nonatomic,strong)UILabel *addressLab;
@property (nonatomic,strong)UILabel *creatTimeLab;
@property (nonatomic,strong)UILabel *endTimeLab;
@property (nonatomic,strong)UILabel *phoneLab;
@end
@implementation SellQiyeInfoTableViewCell
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        UILabel *dizhiLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 20)];
        [dizhiLab setFont:[UIFont systemFontOfSize:13]];
        [dizhiLab setTextAlignment:NSTextAlignmentRight];
        [dizhiLab setTextColor:detialLabColor];
        dizhiLab.text=@"苗圃基地";
        [self addSubview:dizhiLab];
        
        self.addressLab=[[UILabel alloc]initWithFrame:CGRectMake(130, 0, kWidth-140, 40)];
        [self.addressLab setFont:[UIFont systemFontOfSize:13]];
    
        self.addressLab.numberOfLines=0;
    
        [self.addressLab setTextColor:[UIColor grayColor]];
        [self addSubview:self.addressLab];
        
        UILabel *fabuTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 35, 80, 20)];
        [fabuTimeLab setFont:[UIFont systemFontOfSize:13]];
        [fabuTimeLab setTextAlignment:NSTextAlignmentRight];
        [fabuTimeLab setTextColor:detialLabColor];
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
        [youxiaoTimeLab setTextColor:detialLabColor];
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
        [lianxiLab setTextColor:detialLabColor];
        lianxiLab.text=@"联系方式";
        [self addSubview:lianxiLab];
        
        self.phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(130, 95, 200, 20)];
        [self.phoneLab setFont:[UIFont systemFontOfSize:13]];
        [self.phoneLab setTextColor:[UIColor grayColor]];
        [self addSubview:self.phoneLab];
    }
    return self;
}

-(void)setModel:(SupplyDetialMode *)model
{
    _model=model;
    self.addressLab.text=model.address;
    
    self.creatTimeLab.text=model.createTime;
    self.endTimeLab.text=model.endTime;
    self.phoneLab.text=model.phone;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
