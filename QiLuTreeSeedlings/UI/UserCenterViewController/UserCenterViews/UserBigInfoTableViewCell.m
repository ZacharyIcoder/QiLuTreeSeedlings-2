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
@property (nonatomic,weak) UILabel *coloectLab;
@property (nonatomic,weak) UILabel *integralLab;
@property (nonatomic,weak) UILabel *messageLab;
@end
@implementation UserBigInfoTableViewCell
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setAccessibilityIdentifier:@"UserBigInfoTableViewCell"];
    
        [self setBackgroundColor:[UIColor whiteColor]];
       
        UIView *shoucangView=[self viewWithLLLLLLLImageNmae:@"mycollectionImage" andTitle:@"我的收藏" andNum:@"0" andFrame:CGRectMake(0, 0, kWidth/3, 80)];
        [self addSubview:shoucangView];
        self.collectBtn=(UIButton *)[shoucangView viewWithTag:1111];
       self.coloectLab=(UILabel *)[shoucangView viewWithTag:1112];
        self.coloectLab.hidden=YES;
        UIView *integralView=[self viewWithLLLLLLLImageNmae:@"myintegralImage" andTitle:@"我的积分" andNum:@"0" andFrame:CGRectMake(kWidth/3*1, 0, kWidth/3, 80)];
        [self addSubview:integralView];
        self.interBtn=(UIButton *)[integralView viewWithTag:1111];
        self.integralLab=(UILabel *)[integralView viewWithTag:1112];
        self.integralLab.hidden=YES;
        UIView *myMessageView=[self viewWithLLLLLLLImageNmae:@"MyMessage" andTitle:@"我的消息" andNum:@"0" andFrame:CGRectMake(kWidth/3*2, 0, kWidth/3, 80)];
        [self addSubview:myMessageView];
        
        self.messageLab=(UILabel *)[myMessageView viewWithTag:1112];
        self.messageLab.hidden=YES;
        self.messageBtn=(UIButton *)[myMessageView viewWithTag:1111];
    }
    return self;
}
-(UIView *)viewWithLLLLLLLImageNmae:(NSString *)imamgeName andTitle:(NSString *)title andNum:(NSString *)num andFrame:(CGRect)frame
{
    UIView *view=[[UIView alloc]initWithFrame:frame];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width*0.5-20, 10, 40, 40)];
    
    [imageV setImage:[UIImage imageNamed:imamgeName]];
    [view addSubview:imageV];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.5-30, 50, 60, 20)];
    [titleLab setFont:[UIFont systemFontOfSize:14]];
    //[titleLab setBackgroundColor:[UIColor redColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    titleLab.text=title;
    [titleLab setTextColor:titleLabColor];
    [view addSubview:titleLab];
    UILabel *numLab=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.5+15, 10, 14, 14)];
    [numLab setBackgroundColor:[UIColor redColor]];
    numLab.layer.masksToBounds=YES;
    numLab.layer.cornerRadius=7;
    [numLab setTextAlignment:NSTextAlignmentCenter];
    [numLab setTextColor:[UIColor whiteColor]];
    [numLab setFont:[UIFont systemFontOfSize:9]];
    numLab.text=num;
    [view addSubview:numLab];
    numLab.tag=1112;
    UIButton *btn=[[UIButton alloc]initWithFrame:view.bounds];
    btn.tag=1111;
    [btn setBackgroundColor:[UIColor clearColor]];
    [view addSubview:btn];
    return view;
}

-(void)setModel:(UserInfoModel *)model
{
    _model=model;
    if ([model.count intValue]==0) {
        self.coloectLab.hidden=YES;
    }else
    {
        self.coloectLab.hidden=NO;
    }
    if ([model.nrMessageCount intValue]==0) {
        self.messageLab.hidden=YES;
    }else
    {
        self.messageLab.hidden=NO;
    }
    self.coloectLab.text=[NSString stringWithFormat:@"%@",model.count];
    self.messageLab.text=[NSString stringWithFormat:@"%@",model.nrMessageCount];
    //self.integralLab.text=[NSString stringWithFormat:@"%@",model.sumscore];
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
