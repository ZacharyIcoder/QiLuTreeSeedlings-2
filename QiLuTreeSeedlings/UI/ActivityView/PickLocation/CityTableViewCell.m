//
//  CityTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/5/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "CityTableViewCell.h"

@implementation CityTableViewCell
+(CityTableViewCell *)CityTableViewCell;
{
    CityTableViewCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"CityTableViewCell" owner:self options:nil] lastObject];
    cell.pickImage.hidden=YES;
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(CityModel *)model
{
    _model=model;
    self.cityNameLab.text=model.cityName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
