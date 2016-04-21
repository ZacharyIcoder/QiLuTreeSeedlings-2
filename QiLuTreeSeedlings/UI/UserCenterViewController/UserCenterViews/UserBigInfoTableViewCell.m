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
@property (nonatomic,strong) UILabel *integralLab;
@end
@implementation UserBigInfoTableViewCell
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setAccessibilityIdentifier:@"UserBigInfoTableViewCell"];
    
        [self setBackgroundColor:[UIColor whiteColor]];
       
        UIView *shoucangView=[self viewWithLLLLLLLImageNmae:@"mycollectionImage" andTitle:@"我的收藏" andNum:@"0" andFrame:CGRectMake(0, 0, kWidth/2, 60)];
        [self addSubview:shoucangView];
        self.collectBtn=(UIButton *)[shoucangView viewWithTag:1111];
       self.coloectLab=(UILabel *)[shoucangView viewWithTag:1112];
        UIView *integralView=[self viewWithLLLLLLLImageNmae:@"myintegralImage" andTitle:@"我的积分" andNum:@"0" andFrame:CGRectMake(kWidth/2, 0, kWidth/2, 60)];
        [self addSubview:integralView];
        self.interBtn=(UIButton *)[integralView viewWithTag:1111];
        self.integralLab=(UILabel *)[integralView viewWithTag:1112];
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(kWidth/2, 10, 0.5, 40)];
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
    [titleLab setFont:[UIFont systemFontOfSize:15]];
    //[titleLab setBackgroundColor:[UIColor redColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    titleLab.text=title;
    [titleLab setTextColor:detialLabColor];
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

-(void)setModel:(UserInfoModel *)model
{
    _model=model;
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
