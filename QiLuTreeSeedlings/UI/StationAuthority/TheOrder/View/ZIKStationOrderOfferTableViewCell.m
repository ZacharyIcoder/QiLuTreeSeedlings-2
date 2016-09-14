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
#import "StringAttributeHelper.h"
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
    self.orderUidLabel.text = [NSString stringWithFormat:@"%02d",(int)self.section+1];
    self.nameLabel.text     = model.name;
    if (model.treedescription.length>0) {
      self.contentLabel.text  = [NSString stringWithFormat:@"规格要求: %@",model.treedescription];  
    }
    
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

    NSString *quoteStr = [NSString stringWithFormat:@"需求: %@棵(株)",model.quantity];
//    NSString *quoteStr = [NSString stringWithFormat:@"供应: %@棵(株)",model.quoteQuantity];
    FontAttribute *quotefullFont = [FontAttribute new];
    quotefullFont.font = [UIFont systemFontOfSize:14.0f];
    quotefullFont.effectRange  = NSMakeRange(0, quoteStr.length);
    ForegroundColorAttribute *quotefullColor = [ForegroundColorAttribute new];
    quotefullColor.color = [UIColor darkGrayColor];
    quotefullColor.effectRange = NSMakeRange(0,quoteStr.length);
    //局部设置
    FontAttribute *quotepartFont = [FontAttribute new];
    quotepartFont.font = [UIFont systemFontOfSize:14.0f];
    quotepartFont.effectRange = NSMakeRange(3, quoteStr.length-3);
    ForegroundColorAttribute *quotedarkColor = [ForegroundColorAttribute new];
    quotedarkColor.color = yellowButtonColor;
    quotedarkColor.effectRange = NSMakeRange(3, quoteStr.length-3);

    self.quantityLabel.attributedText = [quoteStr mutableAttributedStringWithStringAttributes:@[quotefullFont,quotepartFont,quotefullColor,quotedarkColor]];
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
