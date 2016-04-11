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
        [self addSubview:iamgeV];
        UIImageView *iamgeVV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-50, 20, 33, 33)];
        [iamgeVV setImage:[UIImage imageNamed:@"editngChange"]];
        [self addSubview:iamgeVV];
        [iamgeV setImage:[UIImage imageNamed:@"nuseryBase"]];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(70, 20, kWidth-105, 30)];
        [titleLab setTextColor:[UIColor blackColor]];
        [self addSubview:titleLab];
        self.titleLab=titleLab;
        UILabel *addressLab=[[UILabel alloc]initWithFrame:CGRectMake(33, 60, kWidth-40, 20)];
        [self addSubview:addressLab];
        self.addressLab=addressLab;
        UILabel *chargePersonLab=[[UILabel alloc]initWithFrame:CGRectMake(33, 85, kWidth-40, 20)];
        self.chargelPersonLab=chargePersonLab;
        [self addSubview:chargePersonLab];
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
    self.addressLab.text=[NSString stringWithFormat:@"地址：%@",model.nurseryAddress];
    self.chargelPersonLab.text=[NSString stringWithFormat:@"负责人：%@",model.chargelPerson];
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
