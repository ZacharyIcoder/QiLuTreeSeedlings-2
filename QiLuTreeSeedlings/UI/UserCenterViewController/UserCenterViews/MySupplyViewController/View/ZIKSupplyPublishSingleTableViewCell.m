//
//  ZIKSupplyPublishSingleTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/23.
//  Copyright © 2016年 中亿信息技术. All rights reserved.
//

#import "ZIKSupplyPublishSingleTableViewCell.h"

@implementation ZIKSupplyPublishSingleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ZZIKSupplyPublishSingleTableViewCellID = @"ZIKOrderDetailFirstAddressTableViewCellID";
    ZIKSupplyPublishSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZZIKSupplyPublishSingleTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKSupplyPublishSingleTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

////<span style="font-size:14px;">#pragma mark - remove view to superView autoLayout
//- (void)removeAllAutoLayout{
//    [self removeConstraints:self.constraints];
//    for (NSLayoutConstraint *constraint in self.superview.constraints) {
//        if ([constraint.firstItem isEqual:self]) {
//            [self.superview removeConstraint:constraint];
//        }
//    }
//}//</span>
- (void)configureCell:(id)model {
    //[self removeAllAutoLayout];
//    self.contentTextField.placeholder = @"请输入标题(限制在20字以内)";
//    self.otherLabel.hidden = YES;
//    self.contentTextField.frame = CGRectMake(80, 11, Width-90, 20);
    
}

@end
