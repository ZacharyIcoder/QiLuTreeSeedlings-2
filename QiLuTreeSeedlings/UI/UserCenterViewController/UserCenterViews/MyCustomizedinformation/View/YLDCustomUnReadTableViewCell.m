//
//  YLDCustomUnReadTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/14.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "YLDCustomUnReadTableViewCell.h"

@implementation YLDCustomUnReadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.redDD.layer.cornerRadius=4;
    // Initialization code
}

-(void)setModel:(ZIKCustomizedInfoListModel *)model
{
    _model=model;
    self.nameLab.text=model.title;
    self.timeLab.text=_model.sendTime;
    if ([model.reads isEqualToString:@"1"]) {
        self.redDD.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
