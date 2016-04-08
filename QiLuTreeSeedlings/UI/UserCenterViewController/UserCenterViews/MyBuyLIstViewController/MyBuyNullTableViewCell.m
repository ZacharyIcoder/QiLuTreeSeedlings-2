//
//  MyBuyNullTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/30.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MyBuyNullTableViewCell.h"
#import "UIDefines.h"
@implementation MyBuyNullTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setRestorationIdentifier:@"MyBuyNullTableViewCell"];
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        [imageV setImage:[UIImage imageNamed:@"myBuyNull"]];
        imageV.center=CGPointMake(kWidth/2, frame.size.height/2-55);
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-110, CGRectGetMaxY(imageV.frame)+10, 220, 20)];
        [lab1 setTextColor:detialLabColor];
        [lab1 setTextAlignment:NSTextAlignmentCenter];
        [lab1 setText:@"您还没有发布任何求购信息"];
        [self addSubview:lab1];
        
        UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-100, CGRectGetMaxY(lab1.frame)+10, 200, 20)];
        [lab2 setTextColor:detialLabColor];
        [lab2 setTextAlignment:NSTextAlignmentCenter];
        [lab2 setText:@"点击按钮发布"];
        [self addSubview:lab2];
        [self addSubview:imageV];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        UIButton *fabuBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-40, CGRectGetMaxY(lab2.frame)+10, 80, 30)];
        fabuBtn.layer.cornerRadius=4;
        [fabuBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        fabuBtn.layer.borderColor=kLineColor.CGColor;
        fabuBtn.layer.borderWidth=0.5;
        [fabuBtn setTitle:@"发布求购" forState:UIControlStateNormal];
        
        self.fabuBtn=fabuBtn;
        [self addSubview:fabuBtn];
        [fabuBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    }
    return self;
}
+(NSString*)IdStr
{
    return @"MyBuyNullTableViewCell";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
