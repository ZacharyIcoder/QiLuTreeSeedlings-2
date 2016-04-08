//
//  NuserNullTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/26.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "NuserNullTableViewCell.h"
#import "UIDefines.h"
@implementation NuserNullTableViewCell
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setRestorationIdentifier:@"NuserNullTableViewCell"];
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 130, 130)];
        [imageV setImage:[UIImage imageNamed:@"myNuserNull"]];
        imageV.center=CGPointMake(kWidth/2, frame.size.height/2-20);
        UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-65, CGRectGetMaxY(imageV.frame)+10, 130, 20)];
        [lab1 setTextColor:detialLabColor];
        [lab1 setTextAlignment:NSTextAlignmentCenter];
        [lab1 setText:@"空空如也～～"];
        [self addSubview:lab1];
        
        UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-100, CGRectGetMaxY(lab1.frame)+10, 200, 20)];
        [lab2 setTextColor:detialLabColor];
        [lab2 setTextAlignment:NSTextAlignmentCenter];
        [lab2 setText:@"还没有添加任何苗圃信息"];
        [self addSubview:lab2];
        [self addSubview:imageV];
    }
    return self;
}
+(NSString*)IdStr
{
    return @"NuserNullTableViewCell";
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
