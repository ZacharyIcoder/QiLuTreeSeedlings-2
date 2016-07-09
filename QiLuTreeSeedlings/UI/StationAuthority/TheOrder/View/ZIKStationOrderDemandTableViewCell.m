//
//  ZIKStationOrderDemandTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/7.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderDemandTableViewCell.h"
#import "ZIKStationOrderDemandModel.h"
@interface ZIKStationOrderDemandTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *baojiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhiliangLabel;
@property (weak, nonatomic) IBOutlet UILabel *celiangLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *shuomingLabel;

@end

@implementation ZIKStationOrderDemandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKStationOrderDemandTableViewCellID = @"kZIKStationOrderDemandTableViewCellID";
    ZIKStationOrderDemandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKStationOrderDemandTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKStationOrderDemandTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(ZIKStationOrderDemandModel *)model {
    self.titleLabel.text    = model.orderName;
    self.typeLabel.text     = model.orderType;
    self.zhiliangLabel.text = model.quantityRequired;
    self.baojiaLabel.text   = model.quotationRequired;
    self.endDataLabel.text  = model.endDate;
    self.companyLabel.text  = model.company;
    self.areaLabel.text     = model.area;
    self.phoneLabel.text    = model.phone;
    self.shuomingLabel.text = model.demandDescription;
    self.celiangLabel.text = [NSString stringWithFormat:@"胸径离地面%@处,地径离地面%@处",model.dbh,model.groundDiameter];
}
@end
