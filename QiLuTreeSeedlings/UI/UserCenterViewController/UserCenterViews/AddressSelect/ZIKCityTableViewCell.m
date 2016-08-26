//
//  ZIKCityTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKCityTableViewCell.h"
#import "UIDefines.h"
@implementation ZIKCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectImageView.hidden = YES;
    self.nameLable.textColor = titleLabColor;
    self.contentView.backgroundColor = BGColor;
}

-(void)setCity:(NSDictionary *)city {
    _city = city;
    self.nameLable.text  = _city[@"name"];
    if ([city[@"select"] isEqualToString:@"1"]) {
        self.nameLable.textColor = NavColor;
        self.selectImageView.hidden = NO;
    }
    else {
        self.nameLable.textColor = titleLabColor;
        self.selectImageView.hidden = YES;
    }
}
-(void)setModel:(CityModel *)model
{
    
    _model=model;
    self.nameLable.text  =model.cityName;
    if (model.select) {
        self.nameLable.textColor = NavColor;
        self.selectImageView.hidden = NO;
    }
    else {
        self.nameLable.textColor = titleLabColor;
        self.selectImageView.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
