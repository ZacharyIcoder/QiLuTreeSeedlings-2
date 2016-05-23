//
//  MySupplyOtherInfoTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MySupplyOtherInfoTableViewCell.h"
#import "UIDefines.h"

@interface MySupplyOtherInfoTableViewCell ()
@property (nonatomic,strong)UIView *addressView;
@property (nonatomic,strong)UILabel *creatTimeLab;
@property (nonatomic,strong)UILabel *endTimeLab;
@property (nonatomic,strong)UILabel *phoneLab;
@end
@implementation MySupplyOtherInfoTableViewCell
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setRestorationIdentifier:@"MySupplyOtherInfoTableViewCell"];
        UILabel *dizhiLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 30)];
        [dizhiLab setFont:[UIFont systemFontOfSize:13]];
        [dizhiLab setTextAlignment:NSTextAlignmentRight];
        [dizhiLab setTextColor:detialLabColor];
        dizhiLab.text=@"苗圃基地";
        [self addSubview:dizhiLab];
        
        self.addressView=[[UIView alloc]initWithFrame:CGRectMake(130, 0, kWidth-140, 40)];
        //[self.addressLab setFont:[UIFont systemFontOfSize:13]];
        
       // self.addressLab.numberOfLines=0;
        
        //[self.addressLab setTextColor:[UIColor grayColor]];
        [self addSubview:self.addressView];
        
        
        
        self.creatTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(130, 35, 200, 20)];
        [self.creatTimeLab setFont:[UIFont systemFontOfSize:13]];
        [self.creatTimeLab setTextColor:titleLabColor];
        [self addSubview:self.creatTimeLab];
        
        
        
        self.endTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(130, 65, 200, 20)];
        [self.endTimeLab setFont:[UIFont systemFontOfSize:13]];
        [self.endTimeLab setTextColor:titleLabColor];
        [self addSubview:self.endTimeLab];
        
        self.phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(130, 95, 200, 20)];
        [self.phoneLab setFont:[UIFont systemFontOfSize:13]];
        [self.phoneLab setTextColor:titleLabColor];
        [self addSubview:self.phoneLab];
    }
    return self;
}
+(NSString *)IDStr
{
    return @"MySupplyOtherInfoTableViewCell";
}
-(void)setModel:(SupplyDetialMode *)model
{
    _model=model;
    self.creatTimeLab.text=model.createTime;
    self.endTimeLab.text=model.endTime;
    self.phoneLab.text=model.phone;
}
-(void)setNuseryAry:(NSArray *)nuseryAry
{
    _nuseryAry=nuseryAry;
    if (self.addressView.subviews.count>0) {
        return;
    }
    for (int i=0; i<nuseryAry.count; i++) {
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, i*30+5, kWidth-140, 30)];
        [lab setFont:[UIFont systemFontOfSize:13]];
        
         lab.numberOfLines=0;
        lab.text=nuseryAry[i];
        [lab setTextColor:[UIColor grayColor]];
        [self.addressView addSubview:lab];
        
    }
    CGRect tempFrame=self.addressView.frame;
    tempFrame.size.height=nuseryAry.count*30;
    if (tempFrame.size.height<30) {
        tempFrame.size.height=30;
    }
    self.addressView.frame=tempFrame;
    tempFrame.size.height=30;
    tempFrame.origin.y=CGRectGetMaxY(self.addressView.frame);
    
    UILabel *fabuTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(20, tempFrame.origin.y, 80, 30)];
    [fabuTimeLab setFont:[UIFont systemFontOfSize:13]];
    [fabuTimeLab setTextAlignment:NSTextAlignmentRight];
    [fabuTimeLab setTextColor:detialLabColor];
    fabuTimeLab.text=@"发布日期";
    [self addSubview:fabuTimeLab];
    self.creatTimeLab.frame=tempFrame;
    tempFrame.origin.y+=30;
    UILabel *youxiaoTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(20,tempFrame.origin.y, 80, 30)];
    [youxiaoTimeLab setFont:[UIFont systemFontOfSize:13]];
    [youxiaoTimeLab setTextAlignment:NSTextAlignmentRight];
    [youxiaoTimeLab setTextColor:detialLabColor];
    youxiaoTimeLab.text=@"有效期至";
    [self addSubview:youxiaoTimeLab];
    self.endTimeLab.frame=tempFrame;
    tempFrame.origin.y+=30;
    UILabel *lianxiLab=[[UILabel alloc]initWithFrame:CGRectMake(20, tempFrame.origin.y, 80, 30)];
    [lianxiLab setFont:[UIFont systemFontOfSize:13]];
    [lianxiLab setTextAlignment:NSTextAlignmentRight];
    [lianxiLab setTextColor:detialLabColor];
    lianxiLab.text=@"联系方式";
    [self addSubview:lianxiLab];

    self.phoneLab.frame=tempFrame;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
