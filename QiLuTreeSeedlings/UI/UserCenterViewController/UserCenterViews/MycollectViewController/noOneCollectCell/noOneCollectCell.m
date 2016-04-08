//
//  noOneCollectCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/12.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "noOneCollectCell.h"
#import "UIDefines.h"
@implementation noOneCollectCell
-(id)initWithFrame:(CGRect)frame andType:(NSInteger)type
{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-45, 20, 90, 90)];
        image.layer.cornerRadius=45;
        [image setImage:[UIImage imageNamed:@"myCollectEmpy"]];
        [self addSubview:image];
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame)+5, kWidth, 20)];
        [lab1 setTextAlignment:NSTextAlignmentCenter];
        [lab1 setTextColor:detialLabColor];
        lab1.text=@"收藏夹里什么都没有啊～";
        [self addSubview:lab1];
        
        UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lab1.frame)+5, kWidth, 20)];
        [lab2 setTextAlignment:NSTextAlignmentCenter];
        [lab2 setTextColor:detialLabColor];
        lab2.text=@"点击查看更多信息～";
        [self addSubview:lab2];
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-35, CGRectGetMaxY(lab2.frame)+10, 60, 20)];
        NSString *str=@"更多信息";
        if (type==1) {
            str=@"更多供应";
        }else if(type==2)
        {
            str=@"更多求购";
        }
        [btn setTitle:str forState:UIControlStateNormal];
        btn.layer.borderWidth=0.5;
        [btn setTitleColor:detialLabColor forState:UIControlStateNormal];
        btn.layer.borderColor=detialLabColor.CGColor;
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        btn.layer.cornerRadius=3;
        self.actionBtn=btn;
        [self addSubview:btn];
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-50, kWidth, 50)];
        [view setBackgroundColor:BGColor];
        [self addSubview:view];
        
        UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 24.5, kWidth, 0.5)];
        [lineView setBackgroundColor:kLineColor];
        [view addSubview:lineView];
        UILabel *likeLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-30, 0, 60, 50)];
        [likeLab setText:@"猜你喜欢"];
        [likeLab setFont:[UIFont systemFontOfSize:13]];
        [likeLab setBackgroundColor:BGColor];
        [likeLab setTextAlignment:NSTextAlignmentCenter];
        [likeLab setTextColor:detialLabColor];
        [view addSubview:likeLab];
        
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
