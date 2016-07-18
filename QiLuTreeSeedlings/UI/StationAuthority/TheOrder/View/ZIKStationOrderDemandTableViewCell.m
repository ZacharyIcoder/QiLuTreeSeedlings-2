//
//  ZIKStationOrderDemandTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/7.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderDemandTableViewCell.h"
#import "ZIKStationOrderDemandModel.h"
#import "StringAttributeHelper.h"
#import "UIDefines.h"
#import "ZIKFunction.h"
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidthLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneWidthLayoutConstraint;
@property (weak, nonatomic) IBOutlet UILabel *dianhuaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dianhuaImageView;

@end


@implementation ZIKStationOrderDemandTableViewCell
{
    NSString *phone;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phone:)];
//    [self addGestureRecognizer:tapGesture];

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
    self.phoneLabel.text    = model.person;
    CGRect nameRect =  [ZIKFunction getCGRectWithContent:model.person width:180 font:15.0f];
    self.nameWidthLayoutConstraint.constant = nameRect.size.width+5;
    self.shuomingLabel.text = model.demandDescription;

    self.dianhuaLabel.text = model.phone;
    phone = model.phone;
    CGRect phoneRect = [ZIKFunction getCGRectWithContent:model.phone width:180 font:15.0f];
    self.phoneWidthLayoutConstraint.constant = phoneRect.size.width+5;

    self.dianhuaLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phone:)];
    [self.dianhuaLabel addGestureRecognizer:tapGesture];

    self.dianhuaImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phone:)];
    [self.dianhuaImageView addGestureRecognizer:tapGesture2];


    if ([model.status isEqualToString:@"已结束"]) {
        self.typeImageView.image  = [UIImage imageNamed:@"zt已结束"];
    } else if ([model.status isEqualToString:@"报价中"]) {
        self.typeImageView.image  = [UIImage imageNamed:@"zt报价中"];
    } else if ([model.status isEqualToString:@"已报价"]) {
        self.typeImageView.image  = [UIImage imageNamed:@"zt已报价"];
    }
//    self.celiangLabel.text  = [NSString stringWithFormat:@"胸径离地面%@CM处,地径离地面%@CM处",model.dbh,model.groundDiameter];
    NSString *celiangString = [NSString stringWithFormat:@"胸径离地面%@CM处,地径离地面%@CM处",model.dbh,model.groundDiameter];
    NSArray *array = [celiangString componentsSeparatedByString:@","];
    NSString *string1 = array[0];
    NSString *string2 = array[1];

    NSRange range12 = [string1 rangeOfString:@"处"];//匹配得到的下标
    NSRange range11 = [string1 rangeOfString:@"面"];
    NSRange range21 = [string2 rangeOfString:@"面"];//匹配得到的下标
    NSRange range22 = [string2 rangeOfString:@"处"];
//    NSLog(@"%@",range1);
//    NSLog(@"%@",range2);
//    NSString *priceString = [NSString stringWithFormat:@"我的报价: ¥%@",model.price];
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:15.0f];
    fullFont.effectRange  = NSMakeRange(0, celiangString.length);
    ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
    fullColor.color = DarkTitleColor;
    fullColor.effectRange = NSMakeRange(0,celiangString.length);
//    NSLog(@"%d,%d,%d,%d",(int)range11.location,(int)(range12.location-range11.location),(int)(range12.location+1+range21.location),(int)(range22.location-range21.location));
    //局部设置
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:15.0f];
    partFont.effectRange = NSMakeRange(range11.location+1, range12.location-range11.location-1);
    ForegroundColorAttribute *darkColor = [ForegroundColorAttribute new];
    darkColor.color = NavColor;
    darkColor.effectRange = NSMakeRange(range11.location+1, range12.location-range11.location-1);

    FontAttribute *partFont2 = [FontAttribute new];
    partFont2.font = [UIFont systemFontOfSize:15.0f];
    partFont2.effectRange = NSMakeRange(range12.location+1+range21.location+2, range22.location-range21.location-1);
    ForegroundColorAttribute *darkColor2 = [ForegroundColorAttribute new];
    darkColor2.color = NavColor;
    darkColor2.effectRange = NSMakeRange(range12.location+1+range21.location+2, range22.location-range21.location-1);


    self.celiangLabel.attributedText = [celiangString mutableAttributedStringWithStringAttributes:@[fullFont,partFont,partFont2,fullColor,darkColor,darkColor2]];

}

- (void)phone:(UIGestureRecognizer *)gr {
    if ([self.delegate respondsToSelector:@selector(sendPhoneInfo:)]) {
        [self.delegate sendPhoneInfo:phone];
    }

}
@end
