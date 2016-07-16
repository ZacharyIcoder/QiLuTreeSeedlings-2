//
//  ZIKStationOrderTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/2.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderTableViewCell.h"
#import "ZIKStationOrderModel.h"
#import "UIDefines.h"
#import "ZIKFunction.h"
@interface ZIKStationOrderTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *offerLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *breedLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@end

@implementation ZIKStationOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.breedLabel.textColor = NavColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKStationOrderTableViewCellID = @"kZIKStationOrderTableViewCellID";
    ZIKStationOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKStationOrderTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKStationOrderTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(ZIKStationOrderModel *)model {
    self.addressLabel.text    = [NSString stringWithFormat:@"用苗地:%@",model.area];
    self.orderTitleLabel.text = model.orderName;
    self.startTimeLabel.text  = [NSString stringWithFormat:@"发布日期:%@",model.orderDate];
    self.endTimeLabel.text    = [NSString stringWithFormat:@"截止日期:%@",model.endDate];
    if ([ZIKFunction xfunc_check_strEmpty:model.quotation]) {
        model.quotation = @"";
    }
    
    self.offerLabel.text      = [NSString stringWithFormat:@"报价要求:%@",model.quotation];
    self.qualityLabel.text= [NSString stringWithFormat:@"质量要求:%@",model.qualityRequest];
    self.companyLabel.text    = model.engineeringCompany;
    //self.qualityLabel.text = model.orderType;
    if ([model.orderType isEqualToString:@"求购单"]) {
        self.topImageView.image = [UIImage imageNamed:@"标签-求购"];
    } else if ([model.orderType isEqualToString:@"询价单"]) {
        self.topImageView.image = [UIImage imageNamed:@"标签-询价"];
    } else if ([model.orderType isEqualToString:@"采购单"]) {
        self.topImageView.image = [UIImage imageNamed:@"标签-采购"];
    }
    self.breedLabel.text = model.miaomu;
   //self.breedLabel.text = @"wejfijwiajfijwaifejwaifjjhwefhwhafohwohfiohwaofhiwoahfiohwifhiowhwefwefwqefwqefwqefwqefwqefwqfwqeffwqewqefwqefwqefwqefwewqfohwoaf";
    if (model.statusType == StationOrderStatusTypeOutOfDate) {
        self.typeImageView.image = [UIImage imageNamed:@"zt已结束"];
    } else if (model.statusType == StationOrderStatusTypeQuotation) {
        self.typeImageView.image = [UIImage imageNamed:@"zt报价中"];
    } else if (model.statusType == StationOrderStatusTypeAlreadyQuotation) {
        self.typeImageView.image = [UIImage imageNamed:@"zt已报价"];
    }

}


@end
