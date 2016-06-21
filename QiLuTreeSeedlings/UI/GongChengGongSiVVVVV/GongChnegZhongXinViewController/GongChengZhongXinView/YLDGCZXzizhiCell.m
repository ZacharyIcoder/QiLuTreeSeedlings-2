//
//  YLDGCZXzizhiCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDGCZXzizhiCell.h"

@implementation YLDGCZXzizhiCell
+(YLDGCZXzizhiCell *)yldGCZXzizhiCell
{
    YLDGCZXzizhiCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDGCZXzizhiCell" owner:self options:nil] lastObject];
    return cell;
}
-(void)setMessageWithImageName:(NSString *)imageName andTitle:(NSString *)title
{
    [self.imagev setImage:[UIImage imageNamed:imageName]];
    self.titleLab.text=title;
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
