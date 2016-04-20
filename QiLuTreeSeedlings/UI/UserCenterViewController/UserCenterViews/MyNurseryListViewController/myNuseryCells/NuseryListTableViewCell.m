//
//  NuseryListTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/26.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "NuseryListTableViewCell.h"
#import "UIDefines.h"
@interface NuseryListTableViewCell ()
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *addressLab;
@property (nonatomic,strong)UILabel *chargelPersonLab;

@end
@implementation NuseryListTableViewCell
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setRestorationIdentifier:@"NuseryListTableViewCell"];
        UIImageView *iamgeV=[[UIImageView alloc]initWithFrame:CGRectMake(30, 20, 30, 30)];
        [self.contentView addSubview:iamgeV];
        UIImageView *iamgeVV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-50, 20, 33, 33)];
        [iamgeVV setImage:[UIImage imageNamed:@"editngChange"]];
        [self addSubview:iamgeVV];
        [iamgeV setImage:[UIImage imageNamed:@"nuseryBase"]];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(70, 20, kWidth-105, 30)];
        [titleLab setTextColor:titleLabColor];
        [self.contentView addSubview:titleLab];
        self.titleLab=titleLab;
        UILabel *addressLab=[[UILabel alloc]initWithFrame:CGRectMake(33, 60, kWidth-40, 20)];
        [addressLab setFont:[UIFont systemFontOfSize:14]];
        [addressLab setTextColor:detialLabColor];
        [self.contentView addSubview:addressLab];
        self.addressLab=addressLab;
        UILabel *chargePersonLab=[[UILabel alloc]initWithFrame:CGRectMake(33, 85, kWidth-40, 20)];
        self.chargelPersonLab=chargePersonLab;
        [chargePersonLab setTextColor:detialLabColor];
        [self.contentView addSubview:chargePersonLab];
         [chargePersonLab setFont:[UIFont systemFontOfSize:14]];
        UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(20, frame.size.height-0.5, kWidth-40, 0.5)];
        [lineView setBackgroundColor:kLineColor];
        [self.contentView addSubview:lineView];
    }
    return self;
}


+(NSString *)IdStr
{
    return @"NuseryListTableViewCell";
}
-(void)setModel:(NurseryModel *)model
{
    _model=model;
    self.titleLab.text=model.nurseryName;
       NSString *contentStr1 = [NSString stringWithFormat:@"地址：%@",model.nurseryAddress];
    NSMutableAttributedString *addressLabstr = [[NSMutableAttributedString alloc]initWithString:contentStr1];
    //设置：在0-3个单位长度内的内容显示成红色
    [addressLabstr addAttribute:NSForegroundColorAttributeName value:titleLabColor range:NSMakeRange(0, 3)];
    self.addressLab.attributedText=addressLabstr;

    
    NSString *contentStr2 = [NSString stringWithFormat:@"负责人：%@",model.chargelPerson];
    NSMutableAttributedString *chargelPersonLabstr = [[NSMutableAttributedString alloc]initWithString:contentStr2];
    //设置：在0-3个单位长度内的内容显示成红色
    [chargelPersonLabstr addAttribute:NSForegroundColorAttributeName value:titleLabColor range:NSMakeRange(0, 3)];
    self.chargelPersonLab.attributedText=chargelPersonLabstr;
    if (model.isSelect==YES) {
        self.selected=YES;
        self.isSelect=YES;
    }
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
