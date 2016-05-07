//
//  YLDMyMessageTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/7.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "YLDMyMessageTableViewCell.h"

@implementation YLDMyMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(YLDMyMessageModel *)model{
    _model=model;
    [self.titleLab setText:model.message];
    NSString *timeStr=[model.pushTimeStr substringWithRange:NSMakeRange(5, 11)];
    [self.timeLab setText:timeStr];
    if (model.reads) {
        [self.readImage setImage:[UIImage imageNamed:@"messageRead"]];
    }else
    {
        [self.readImage setImage:[UIImage imageNamed:@"messageUnRead"]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
