//
//  ZIKBottomDeleteTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/11.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKBottomDeleteTableViewCell.h"

@implementation ZIKBottomDeleteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deleteButton.backgroundColor = yellowButtonColor;
//    [self.seleteImageButton setImage:[UIImage imageNamed:@"待选"] forState:UIControlStateNormal];
//    [self.seleteImageButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateSelected];

}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kcellID = @"ZIKBottomDeleteTableViewCellID";
    ZIKBottomDeleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kcellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKBottomDeleteTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

-(void)setIsAllSelect:(BOOL)isAllSelect {
    _isAllSelect = isAllSelect;
    if (isAllSelect) {
        [self.seleteImageButton setImage:[UIImage imageNamed:@"已选"] forState:UIControlStateNormal];
    }
    else {
        [self.seleteImageButton setImage:[UIImage imageNamed:@"待选"] forState:UIControlStateNormal];
    }
}

-(void)setCount:(NSString *)count {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
