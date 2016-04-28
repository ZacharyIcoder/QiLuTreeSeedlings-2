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
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(20, 12, 20, 20)];
        [self addSubview:imageV];
        [imageV setImage:[UIImage imageNamed:imageName]];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 120, 44)];
        titleLab.text=title;
        [titleLab setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:titleLab];
        [titleLab setTextColor:titleLabColor];
        UIImageView *lineImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 43.5, kWidth-20, 0.5)];
        self.lineImage=lineImage;
        [lineImage setBackgroundColor:kLineColor];
        [self addSubview:lineImage];
        if ([title isEqualToString:@"我的订制信息"]||[title isEqualToString:@"我的余额"]||[title isEqualToString:@"我的分享"]||[title isEqualToString:@"站长通"]) {
            lineImage.hidden=YES;
        }
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //self.detailTextLabel.text = @"mona";
        //self.selectionStyle=UITableViewCellSelectionStyleNone;
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
