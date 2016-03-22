//
//  searchHistoryViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "searchHistoryViewCell.h"
#import "UIDefines.h"
@implementation searchHistoryViewCell
-(id)initWithFrame:(CGRect)frame WithDic:(NSDictionary *)dic
{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(5,7, 16, 16)];
        [imageV setImage:[UIImage imageNamed:@"listtime"]];
        [self addSubview:imageV];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(30, 7, 80, 20)];
        [titleLab setTextColor:[UIColor lightGrayColor]];
        titleLab.text=[dic objectForKey:@"title"];
        [titleLab setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:titleLab];
        UIButton *actionBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-60, self.frame.size.height)];
        self.actionBtn=actionBtn;
        [self addSubview:actionBtn];
        UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-60, 0, 60, self.frame.size.height)];
        self.deleteBtn=deleteBtn;
        UIImageView *deleteBtnImageV=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-50, self.frame.size.height/2-5, 10, 10)];
        [deleteBtnImageV setImage:[UIImage imageNamed:@"delectLiteBtn"]];
        [self addSubview:deleteBtnImageV];
        [self addSubview:deleteBtn];
        UIImageView *liImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-0.5, self.frame.size.width-10, 0.5)];
        [liImgV setBackgroundColor:kLineColor];
        [self addSubview:liImgV];
    }
    return self;
}

//-(void)actionBtnAction:(UIButton *)sender
//{
//    
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
