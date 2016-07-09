//
//  ZIKStationOrderOfferTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationOrderOfferTableViewCell.h"
#import "UIDefines.h"
#import "ZIKStationOrderDetailQuoteModel.h"
#import "ZIKFunction.h"
@interface ZIKStationOrderOfferTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderUidLabelLayoutConstraint;
@end
@implementation ZIKStationOrderOfferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.orderUidLabel.layer.masksToBounds = YES;
    self.orderUidLabel.layer.cornerRadius = 4.0f;
    self.nameLabel.textColor = NavColor;
    self.quoteButton.layer.masksToBounds = YES;
    self.quoteButton.layer.cornerRadius = 5.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKStationOrderOfferTableViewCellID = @"kZIKStationOrderOfferTableViewCellID";
    ZIKStationOrderOfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKStationOrderOfferTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKStationOrderOfferTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(ZIKStationOrderDetailQuoteModel *)model {
    self.orderUidLabel.text = [NSString stringWithFormat:@"%02d",(int)self.section];
    self.nameLabel.text     = model.name;
    self.quantityLabel.text = [NSString stringWithFormat:@"需求:%@",model.quantity];
    self.contentLabel.text  = [NSString stringWithFormat:@"苗木规格说明:%@",model.treedescription];
//    CGRect rect = [ZIKFunction getCGRectWithContent:model.orderUid width:200 font:14.0f];
//    self.orderUidLabelLayoutConstraint.constant = rect.size.width;
    if ([model.stauts isEqualToString:@"1"]) {
        [self.quoteButton setTitle:@"已报价" forState:UIControlStateNormal];
        self.quoteButton.backgroundColor = self.orderUidLabel.backgroundColor;
        self.quoteButton.userInteractionEnabled = NO;
        //self.quoteButton.hidden = YES;
    } else if ([model.stauts isEqualToString:@"0"]){
        [self.quoteButton setTitle:@"立即报价" forState:UIControlStateNormal];
        self.quoteButton.userInteractionEnabled = YES;
        //self.quoteButton.hidden = NO;
    }
}

- (void)setQuoteBtnBlock:(QuoteBtnBlock)quoteBtnBlock {
    _quoteBtnBlock = quoteBtnBlock;
    [self.quoteButton addTarget:self action:@selector(quoteBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)quoteBtnClick {
    _quoteBtnBlock(self.section);
}

- (void)setIsCanQuote:(BOOL)isCanQuote {
    _isCanQuote = isCanQuote;
    if (isCanQuote) {
        self.quoteButton.hidden = NO;
    } else {
        self.quoteButton.hidden = YES;
    }
}
@end
