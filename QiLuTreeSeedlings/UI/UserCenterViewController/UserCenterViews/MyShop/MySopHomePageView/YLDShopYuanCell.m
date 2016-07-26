//
//  YLDShopYuanCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/7/25.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShopYuanCell.h"
#import "UIDefines.h"
@implementation YLDShopYuanCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame=CGRectMake(0, 0,kWidth,210);
        NSArray *titleAry=@[@"发布供应",@"发布求购",@"我的企业",@"我的苗圃",@"店铺装修",@"查看店铺"];
         NSArray *imageAry=@[@"我的店铺-发布供应.png",@"我的店铺-发布求购.png",@"我的店铺-我的企业.png",@"我的店铺-我的苗圃.png",@"我的店铺-店铺装修.png",@"我的店铺-查看店铺.png"];
        [self setBackgroundColor:[UIColor whiteColor]];
        for (int i=0; i<titleAry.count; i++) {
            
            UIView *circV=[self makeCircleViewWtihName:titleAry[i] WithImagName:imageAry[i] WithNum:i];
            [self.contentView addSubview:circV];
            
        }

        
    }
    return self;
}
-(UIView *)makeCircleViewWtihName:(NSString *)nameStr WithImagName:(NSString *)imagName WithNum:(int)i
{
    int CWith=kWidth/3;
    int k=i/3;
    int z=i%3;
    UIView *circleView=[[UIView alloc]initWithFrame:CGRectMake(z*CWith, k*100, CWith, 100)];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(circleView.frame.size.width/2-55/2,100/2-36, 55, 55)];
    [imageV setImage:[UIImage imageNamed:imagName]];
    imageV.layer.masksToBounds=YES;
    imageV.layer.cornerRadius=55/2;
    [circleView addSubview:imageV];
    UIButton *circBtn=[[UIButton alloc]initWithFrame:imageV.frame];
    circBtn.tag=i;
    [circBtn addTarget:self action:@selector(circleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [circleView addSubview:circBtn];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame)+5, CWith, 20)];
    nameLab.textAlignment=NSTextAlignmentCenter;
    nameLab.text=nameStr;
    [nameLab setTextColor:[UIColor darkGrayColor]];
    [nameLab setFont:[UIFont systemFontOfSize:15]];
    [circleView addSubview:nameLab];
   
    return circleView;
}
-(void)circleBtnAction:(UIButton *)sender
{
    if (self.delegate) {
        [self.delegate YLDShopYuanCellPush:sender.tag];
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
