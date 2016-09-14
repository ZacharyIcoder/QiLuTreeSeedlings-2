//
//  ZIKShaiDanTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/1.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKShaiDanTableViewCell.h"
#import "ZIKShaiDanModel.h"
#import "UIImageView+AFNetworking.h"
#import "ZIKFunction.h"

@interface ZIKShaiDanTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconimageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UILabel *pingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation ZIKShaiDanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKShaiDanTableViewCellID = @"kZIKShaiDanTableViewCellID";
    ZIKShaiDanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKShaiDanTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKShaiDanTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(ZIKShaiDanModel *)model {
    [self.iconimageView setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    self.titleLabel.text = model.title;
    self.stationLabel.text = [NSString stringWithFormat:@"工作站:%@",model.workstationName];
    self.contentLabel.text = [NSString stringWithFormat:@"内容:%@",model.content];
    self.zanLabel.text = model.dianZan;
    self.pingLabel.text = model.pingLun;
//    self.timeLabel.text =  model.createTimeStr;

    NSDate *timeDate = [ZIKFunction getDateFromString:model.createTimeStr];
    NSString *time = [ZIKFunction compareCurrentTime:timeDate];
    self.timeLabel.text  = time;
}

@end
