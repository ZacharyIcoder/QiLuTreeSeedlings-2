//
//  ZIKSupplyPublishNameTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/24.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKSupplyPublishNameTableViewCell.h"
#import "UIDefines.h"
@implementation ZIKSupplyPublishNameTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.nameTextField.textColor = NavColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ZIKSupplyPublishNameTableViewCellID = @"ZIKSupplyPublishNameTableViewCellID";
    ZIKSupplyPublishNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZIKSupplyPublishNameTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKSupplyPublishNameTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

-(void)configureCell:(id)data {
    
}

@end
