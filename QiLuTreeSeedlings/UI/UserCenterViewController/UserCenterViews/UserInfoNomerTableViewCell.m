//
//  UserInfoNomerTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/11.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "UserInfoNomerTableViewCell.h"
#import "UIDefines.h"
@implementation UserInfoNomerTableViewCell
-(id)initWithFrame:(CGRect)frame andImageName:(NSString *)imageName andTitle:(NSString *)title
{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 24, 24)];
        [self addSubview:imageV];
        [imageV setImage:[UIImage imageNamed:imageName]];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 120, 44)];
        titleLab.text=title;
        [self addSubview:titleLab];
        [titleLab setTextColor:[UIColor blackColor]];
        UIImageView *lineImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-20, 0.5)];
        [lineImage setBackgroundColor:kLineColor];
        [self addSubview:lineImage];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
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
