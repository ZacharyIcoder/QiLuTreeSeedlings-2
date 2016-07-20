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
@property (weak, nonatomic) IBOutlet UIButton *openButton;

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
    if ([ZIKFunction xfunc_check_strEmpty:model.area]) {
        self.addressLabel.text = @"用苗地:";
    } else {
        self.addressLabel.text    = [NSString stringWithFormat:@"用苗地:%@",model.area];
    }
       self.orderTitleLabel.text = model.orderName;
    self.startTimeLabel.text  = [NSString stringWithFormat:@"发布日期:%@",model.orderDate];
    self.endTimeLabel.text    = [NSString stringWithFormat:@"截止日期:%@",model.endDate];
    if ([ZIKFunction xfunc_check_strEmpty:model.quotation]) {
        model.quotation = @"";
    }
     NSString *offerString = [NSString stringWithFormat:@"报价要求:%@",model.quotation];
        FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:14.0f];
    fullFont.effectRange  = NSMakeRange(0, offerString.length);
    ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
    fullColor.color = self.addressLabel.textColor;
    fullColor.effectRange = NSMakeRange(0,offerString.length);
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

    //局部设置
    FontAttribute *qualitypartFont = [FontAttribute new];
    qualitypartFont.font = [UIFont systemFontOfSize:14.0f];
    qualitypartFont.effectRange = NSMakeRange(5, qualityString.length-5);
    ForegroundColorAttribute *qualitdarkColor = [ForegroundColorAttribute new];
    qualitdarkColor.color = yellowButtonColor;
    qualitdarkColor.effectRange = NSMakeRange(5, qualityString.length-5);

    self.qualityLabel.attributedText = [qualityString mutableAttributedStringWithStringAttributes:@[qualityfullFont,qualitypartFont,qualityfullColor,qualitdarkColor]];

    self.companyLabel.text    = model.engineeringCompany;
    if ([model.orderType isEqualToString:@"求购单"]) {
        self.topImageView.image = [UIImage imageNamed:@"标签-求购"];
    } else if ([model.orderType isEqualToString:@"询价单"]) {
        self.topImageView.image = [UIImage imageNamed:@"标签-询价"];
    } else if ([model.orderType isEqualToString:@"采购单"]) {
        self.topImageView.image = [UIImage imageNamed:@"标签-采购"];
    }
    if ([ZIKFunction xfunc_check_strEmpty:model.miaomu]) {
        self.breedLabel.text = @"暂无信息";
    } else {
        self.breedLabel.text = model.miaomu;
    }
    //展开隐藏
    if (model.isShow) {
        self.breedLabel.numberOfLines = 0;
        [self.openButton setImage:[UIImage imageNamed:@"ico_橙色收起"] forState:UIControlStateNormal];
    } else {
        self.breedLabel.numberOfLines = 1;
        [self.openButton setImage:[UIImage imageNamed:@"ico_橙色展开-2"] forState:UIControlStateNormal];
    }
        CGRect pzRect = [ZIKFunction getCGRectWithContent:model.miaomu width:kWidth-85 font:14.0f];
        if (pzRect.size.height > 17) {
            self.openButton.hidden = NO;
        } else {
            self.openButton.hidden = YES;
        }

    if (model.statusType == StationOrderStatusTypeOutOfDate) {
        self.typeImageView.image = [UIImage imageNamed:@"zt已结束"];
    } else if (model.statusType == StationOrderStatusTypeQuotation) {
        self.typeImageView.image = [UIImage imageNamed:@"zt报价中"];
    } else if (model.statusType == StationOrderStatusTypeAlreadyQuotation) {
        self.typeImageView.image = [UIImage imageNamed:@"zt已报价"];
    }
}

-(void)setOpenButtonBlock:(OpenButtonBlock)openButtonBlock {
    _openButtonBlock = [openButtonBlock copy];
    [self.openButton addTarget:self action:@selector(openButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)openButtonClick {
    _openButtonBlock(self.indexPath);
}

@end
