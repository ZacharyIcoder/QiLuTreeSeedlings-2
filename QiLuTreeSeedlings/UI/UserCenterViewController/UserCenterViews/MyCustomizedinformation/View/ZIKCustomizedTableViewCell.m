//
//  ZIKCustomizedTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/6.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKCustomizedTableViewCell.h"
#import "UIDefines.h"
@implementation ZIKCustomizedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.priceLabel.textColor = yellowButtonColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ZIKCustomizedTableViewCellID = @"ZIKCustomizedTableViewCellID";
    ZIKCustomizedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZIKCustomizedTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKCustomizedTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(ZIKCustomizedModel *)model {
    self.nameLabel.text  = model.productName;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@/条",model.price];
}

@end