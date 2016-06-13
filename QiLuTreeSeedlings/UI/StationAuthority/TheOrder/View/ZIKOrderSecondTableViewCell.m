//
//  ZIKOrderSecondTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/13.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKOrderSecondTableViewCell.h"

@implementation ZIKOrderSecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
    self.layer.shadowOpacity = 0.2;////阴影透明度，默认0
    self.layer.shadowOffset  = CGSizeMake(0, -3);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowRadius  = 3;//阴影半径，默认3
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKOrderSecondTableViewCellID = @"kZIKOrderSecondTableViewCellID";
    ZIKOrderSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKOrderSecondTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKOrderSecondTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(id)model {
}

@end
