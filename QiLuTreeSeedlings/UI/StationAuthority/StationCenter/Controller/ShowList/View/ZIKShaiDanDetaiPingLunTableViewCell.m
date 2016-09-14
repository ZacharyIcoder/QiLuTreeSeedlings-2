//
//  ZIKShaiDanDetaiPingLunTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKShaiDanDetaiPingLunTableViewCell.h"
#import "ZIKShaiDanDetailPingLunModel.h"
#import "UIDefines.h"
@interface ZIKShaiDanDetaiPingLunTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinglunContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pinglunTrailingLayoutConstraint;
@end
@implementation ZIKShaiDanDetaiPingLunTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = BGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKShaiDanDetaiPingLunTableViewCellID = @"kZIKShaidanDetailPingZanTableViewCellID";
    ZIKShaiDanDetaiPingLunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKShaiDanDetaiPingLunTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKShaiDanDetaiPingLunTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(ZIKShaiDanDetailPingLunModel *)model {
    self.nameLabel.text = model.memberName;
    self.pinglunContentLabel.text = model.content;
    self.timeLabel.text = model.createTimeStr;
    if ([model.del isEqualToString:@"0"]) {
        self.deleteButton.hidden = YES;
        self.pinglunTrailingLayoutConstraint.constant = -56;
    } else if ([model.del isEqualToString:@"1"]) {
        self.deleteButton.hidden = NO;
        self.pinglunTrailingLayoutConstraint.constant = 8;
    }
}

@end
