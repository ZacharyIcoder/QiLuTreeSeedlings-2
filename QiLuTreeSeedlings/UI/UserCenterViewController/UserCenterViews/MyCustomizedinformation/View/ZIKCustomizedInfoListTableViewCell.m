//
//  ZIKCustomizedInfoListTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKCustomizedInfoListTableViewCell.h"
#import "ZIKCustomizedInfoListModel.h"

@implementation ZIKCustomizedInfoListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCell:(ZIKCustomizedInfoListModel *)model {
    self.titleLabel.text = model.title;
    self.timeLabel.text  = model.sendTime;
}

@end
