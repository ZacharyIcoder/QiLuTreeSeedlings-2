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
#import "StringAttributeHelper.h"

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
    
    //    self.offerLabel.text      = [NSString stringWithFormat:@"报价要求:%@",model.quotation];
    NSString *offerString = [NSString stringWithFormat:@"报价要求:%@",model.quotation];
    //    self.qualityLabel.text = [NSString stringWithFormat:@"质量要求:%@",model.qualityRequest];
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:14.0f];
    fullFont.effectRange  = NSMakeRange(0, offerString.length);
    ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
    fullColor.color = self.addressLabel.textColor;
    fullColor.effectRange = NSMakeRange(0,offerString.length);
    //    NSLog(@"%d,%d,%d,%d",(int)range11.location,(int)(range12.location-range11.location),(int)(range12.location+1+range21.location),(int)(range22.location-range21.location));
    //局部设置
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:14.0f];
    partFont.effectRange = NSMakeRange(5, offerString.length-5);
    ForegroundColorAttribute *darkColor = [ForegroundColorAttribute new];
    darkColor.color = yellowButtonColor;
    darkColor.effectRange = NSMakeRange(5, offerString.length-5);

    self.offerLabel.attributedText = [offerString mutableAttributedStringWithStringAttributes:@[fullFont,partFont,fullColor,darkColor]];

    NSString *qualityString = [NSString stringWithFormat:@"质量要求:%@",model.qualityRequest];
    FontAttribute *qualityfullFont = [FontAttribute new];
    qualityfullFont.font = [UIFont systemFontOfSize:14.0f];
    qualityfullFont.effectRange  = NSMakeRange(0, qualityString.length);
    ForegroundColorAttribute *qualityfullColor = [ForegroundColorAttribute new];
    qualityfullColor.color = self.addressLabel.textColor;
    qualityfullColor.effectRange = NSMakeRange(0,qualityString.length);
    //    NSLog(@"%d,%d,%d,%d",(int)range11.location,(int)(range12.location-range11.location),(int)(range12.location+1+range21.location),(int)(range22.location-range21.location));
    //局部设置
    FontAttribute *qualitypartFont = [FontAttribute new];
    qualitypartFont.font = [UIFont systemFontOfSize:14.0f];
    qualitypartFont.effectRange = NSMakeRange(5, qualityString.length-5);
    ForegroundColorAttribute *qualitdarkColor = [ForegroundColorAttribute new];
    qualitdarkColor.color = yellowButtonColor;
    qualitdarkColor.effectRange = NSMakeRange(5, qualityString.length-5);

    self.qualityLabel.attributedText = [qualityString mutableAttributedStringWithStringAttributes:@[qualityfullFont,qualitypartFont,qualityfullColor,qualitdarkColor]];

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
