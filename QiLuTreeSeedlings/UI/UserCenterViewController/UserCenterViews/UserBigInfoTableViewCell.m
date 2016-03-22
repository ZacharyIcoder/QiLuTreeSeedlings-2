//
//  UserBigInfoTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/11.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "UserBigInfoTableViewCell.h"
#import "UIDefines.h"
#import "UIImageView+AFNetworking.h"
@interface UserBigInfoTableViewCell()
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIImageView *userImageV;
@property (nonatomic,strong) UILabel *phoneLab;
@property (nonatomic,strong) UILabel *gongyiDLab;
@property (nonatomic,weak) UILabel *coloectLab;
@property (nonatomic,strong) UILabel *integralLab;
@end
@implementation UserBigInfoTableViewCell
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setAccessibilityIdentifier:@"UserBigInfoTableViewCell"];
        UIImageView *backImageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, frame.size.height-60)];
        [backImageV setImage:[UIImage imageNamed:@"userBigInfoBack"]];
        [self addSubview:backImageV];
        UIButton *setingBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-40, 10, 30, 30)];
        [setingBtn setImage:[UIImage imageNamed:@"settingBtnImage"] forState:UIControlStateNormal];
        [self addSubview:setingBtn];
        self.setingBtn=setingBtn;
//        UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
//        [self addSubview:backBtn];
//        [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        [backBtn setImage:[UIImage imageNamed:@"BackBtn"] forState:UIControlStateNormal];
//        
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-60, 10, 120, 30)];
        [titleLab setTextColor:[UIColor whiteColor]];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        self.titleLab=titleLab;
        [titleLab setText:@"未登录"];
        [self addSubview:titleLab];
        [titleLab setFont:[UIFont systemFontOfSize:19]];
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
        btn.center=CGPointMake(kWidth/2, frame.size.height/2-30);
        self.userImageV=[[UIImageView alloc]initWithFrame:btn.frame];
        self.userImageV.layer.masksToBounds=YES;
        self.userImageV.layer.cornerRadius=self.userImageV.frame.size.width/2;
        self.userImageV.layer.borderWidth=1.0;
        
        self.userImageV.layer.borderColor=[[UIColor whiteColor] CGColor];
        [self.userImageV setImage:[UIImage imageNamed:@"UserImageV"]];
        [self addSubview:self.userImageV];
        [self addSubview:btn];
        //[btn setImage:[UIImage imageNamed:@"UserImageV"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(userImageBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-60, CGRectGetMaxY(self.userImageV.frame)+5, 120, 25)];
        [phoneLab setTextAlignment:NSTextAlignmentCenter];
        self.phoneLab = phoneLab;
        [phoneLab setTextColor:[UIColor whiteColor]];
        [self addSubview:phoneLab];
        
        UILabel *gongyishangLab=[[UILabel alloc] initWithFrame:CGRectMake(kWidth/2-60, CGRectGetMaxY(phoneLab.frame), 120, 25)];
        self.gongyiDLab=gongyishangLab;
        [gongyishangLab setTextColor:[UIColor whiteColor]];
        [gongyishangLab setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:gongyishangLab];
        [gongyishangLab setFont:[UIFont systemFontOfSize:14]];
        
        
        [self setBackgroundColor:[UIColor whiteColor]];
       
        UIView *shoucangView=[self viewWithLLLLLLLImageNmae:@"mycollectionImage" andTitle:@"我的收藏" andNum:@"0" andFrame:CGRectMake(0, 220, kWidth/2, 60)];
        [self addSubview:shoucangView];
        self.collectBtn=(UIButton *)[shoucangView viewWithTag:1111];
       self.coloectLab=(UILabel *)[shoucangView viewWithTag:1112];
        UIView *integralView=[self viewWithLLLLLLLImageNmae:@"myintegralImage" andTitle:@"我的积分" andNum:@"0" andFrame:CGRectMake(kWidth/2, 220, kWidth/2, 60)];
        [self addSubview:integralView];
        self.interBtn=(UIButton *)[integralView viewWithTag:1111];
        self.integralLab=(UILabel *)[integralView viewWithTag:1112];
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(kWidth/2, 230, 0.5, 40)];
        [lineView setBackgroundColor:kLineColor];
        [self addSubview:lineView];
        }
    return self;
}
-(UIView *)viewWithLLLLLLLImageNmae:(NSString *)imamgeName andTitle:(NSString *)title andNum:(NSString *)num andFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width*0.5-60, 10, 40, 40)];
    
    [imageV setImage:[UIImage imageNamed:imamgeName]];
    [view addSubview:imageV];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.5-10, 10, 80, 20)];
    //[titleLab setBackgroundColor:[UIColor redColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    titleLab.text=title;
    [titleLab setTextColor:[UIColor lightGrayColor]];
    [view addSubview:titleLab];
    UILabel *numLab=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.5-10, 30, 80, 20)];
    [numLab setTextAlignment:NSTextAlignmentCenter];
    [numLab setTextColor:[UIColor orangeColor]];
    [numLab setFont:[UIFont systemFontOfSize:15]];
    numLab.text=num;
    [view addSubview:numLab];
    numLab.tag=1112;
    UIButton *btn=[[UIButton alloc]initWithFrame:view.bounds];
    btn.tag=1111;
    [btn setBackgroundColor:[UIColor clearColor]];
    [view addSubview:btn];
    return view;
}
-(void)userImageBtnAction
{
    
}
-(void)setModel:(UserInfoModel *)model
{
    _model=model;
    self.titleLab.text=model.name;
    [self.userImageV setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"UserImageV"]];
    self.phoneLab.text=model.phone;
    self.gongyiDLab.text=model.goldsupplier;
    self.coloectLab.text=[NSString stringWithFormat:@"%@",model.count];
    self.integralLab.text=[NSString stringWithFormat:@"%@",model.sumscore];
}
+(NSString *)IDstr
{
    return @"UserBigInfoTableViewCell";
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
