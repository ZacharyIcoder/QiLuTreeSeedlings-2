//
//  ZIKMiaoQiDetailBriefTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiDetailBriefTableViewCell.h"
#import "ZIKMiaoQiDetailModel.h"
@interface ZIKMiaoQiDetailBriefTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;

@end
@implementation ZIKMiaoQiDetailBriefTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKMiaoQiDetailBriefTableViewCellID = @"kZIKMiaoQiDetailBriefTableViewCellID";
    ZIKMiaoQiDetailBriefTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKMiaoQiDetailBriefTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMiaoQiDetailBriefTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(ZIKMiaoQiDetailModel *)model {
    self.briefLabel.text = [NSString stringWithFormat:@"简介:%@",model.qybrief];
}

@end
