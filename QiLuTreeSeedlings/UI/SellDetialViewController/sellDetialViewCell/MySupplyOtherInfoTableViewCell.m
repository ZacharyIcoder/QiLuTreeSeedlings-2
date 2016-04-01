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
        [dizhiLab setTextColor:[UIColor lightGrayColor]];
        dizhiLab.text=@"苗圃基地";
        [self addSubview:dizhiLab];
        
        self.addressView=[[UIView alloc]initWithFrame:CGRectMake(130, 0, kWidth-140, 40)];
        //[self.addressLab setFont:[UIFont systemFontOfSize:13]];
        
       // self.addressLab.numberOfLines=0;
        
        //[self.addressLab setTextColor:[UIColor grayColor]];
        [self addSubview:self.addressView];
        
        
        
        self.creatTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(130, 35, 200, 20)];
        [self.creatTimeLab setFont:[UIFont systemFontOfSize:13]];
        //        [self.creatTimeLab setTextAlignment:NSTextAlignmentRight];
        [self.creatTimeLab setTextColor:[UIColor grayColor]];
        //        dizhiLab.text=@"地址";
        [self addSubview:self.creatTimeLab];
        
        
        
        self.endTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(130, 65, 200, 20)];
        [self.endTimeLab setFont:[UIFont systemFontOfSize:13]];
        //        [self.endTimeLab setTextAlignment:NSTextAlignmentRight];
        [self.endTimeLab setTextColor:[UIColor grayColor]];
        //        dizhiLab.text=@"地址";
        [self addSubview:self.endTimeLab];
        
        self.phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(130, 95, 200, 20)];
        [self.phoneLab setFont:[UIFont systemFontOfSize:13]];
        [self.phoneLab setTextColor:[UIColor grayColor]];
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
    //self.addressLab.text=model.address;
    
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
    self.addressView.frame=tempFrame;
    tempFrame.size.height=30;
    tempFrame.origin.y=CGRectGetMaxY(self.addressView.frame);
    
    UILabel *fabuTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(20, tempFrame.origin.y, 80, 30)];
    [fabuTimeLab setFont:[UIFont systemFontOfSize:13]];
    [fabuTimeLab setTextAlignment:NSTextAlignmentRight];
    [fabuTimeLab setTextColor:[UIColor lightGrayColor]];
    fabuTimeLab.text=@"发布日期";
    [self addSubview:fabuTimeLab];
    self.creatTimeLab.frame=tempFrame;
    tempFrame.origin.y+=30;
    UILabel *youxiaoTimeLab=[[UILabel alloc]initWithFrame:CGRectMake(20,tempFrame.origin.y, 80, 30)];
    [youxiaoTimeLab setFont:[UIFont systemFontOfSize:13]];
    [youxiaoTimeLab setTextAlignment:NSTextAlignmentRight];
    [youxiaoTimeLab setTextColor:[UIColor lightGrayColor]];
    youxiaoTimeLab.text=@"有效日期";
    [self addSubview:youxiaoTimeLab];
    self.endTimeLab.frame=tempFrame;
    tempFrame.origin.y+=30;
    UILabel *lianxiLab=[[UILabel alloc]initWithFrame:CGRectMake(20, tempFrame.origin.y, 80, 30)];
    [lianxiLab setFont:[UIFont systemFontOfSize:13]];
    [lianxiLab setTextAlignment:NSTextAlignmentRight];
    [lianxiLab setTextColor:[UIColor lightGrayColor]];
    lianxiLab.text=@"联系方式";
    [self addSubview:lianxiLab];

    self.phoneLab.frame=tempFrame;
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
