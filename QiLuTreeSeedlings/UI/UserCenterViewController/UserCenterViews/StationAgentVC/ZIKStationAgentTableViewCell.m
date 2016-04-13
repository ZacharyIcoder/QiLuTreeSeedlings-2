//
//  ZIKStationAgentTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/13.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKStationAgentTableViewCell.h"

@implementation ZIKStationAgentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ZIKStationAgentTableViewCellID = @"ZIKStationAgentTableViewCellID";
    ZIKStationAgentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZIKStationAgentTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKStationAgentTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(ZIKStationAgentModel *)model {
    self.workstationNameLabel.text = model.workstationName;
    self.chargelPersonLabel.text   = model.chargelPerson;
    self.phoneLabel.text           = model.phone;
    self.starLevelView.value       = model.starLevelApi.integerValue;
    self.areaLabel.text            = model.areaall;
    
}

-(void)setPhoneBlock:(PhoneBlock)phoneBlock {
    _phoneBlock = [phoneBlock copy];
    [self.phoneButton addTarget:self action:@selector(phoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)phoneBtnClick {
    _phoneBlock(self.section);
}
@end
