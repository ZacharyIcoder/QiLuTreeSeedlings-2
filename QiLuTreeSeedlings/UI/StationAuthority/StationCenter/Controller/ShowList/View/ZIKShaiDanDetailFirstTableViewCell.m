//
//  ZIKShaiDanDetailFirstTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKShaiDanDetailFirstTableViewCell.h"
#import "ZIKShaiDanDetailModel.h"
#import "UIDefines.h"
@interface ZIKShaiDanDetailFirstTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation ZIKShaiDanDetailFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.timeLabel.textColor = DarkTitleColor;
    self.nameLabel.textColor = detialLabColor;
    self.timeLabel.textColor = detialLabColor;
    self.contentLabel.textColor = titleLabColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKStationCenterContentTableViewCellID = @"kZIKStationCenterContentTableViewCellID";
    ZIKShaiDanDetailFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKStationCenterContentTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKShaiDanDetailFirstTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(ZIKShaiDanDetailModel *)model {
    self.titleLabel.text = model.title;
    self.nameLabel.text = [NSString stringWithFormat:@"发布人:%@",model.memberName];
    self.timeLabel.text = model.createTimeStr;
    self.contentLabel.text = model.content;
}
@end
