//
//  ZIKWorkstationSelectView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKWorkstationSelectView.h"
#import "UIDefines.h"
#import "ZIKWorkstationSelectViewAboutAddressButton.h"

@implementation ZIKWorkstationSelectView

+(ZIKWorkstationSelectView *)instanceSelectAreaView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ZIKWorkstationSelectView" owner:nil options:nil];
    ZIKWorkstationSelectView *showHonorView = [nibView objectAtIndex:0];
    [showHonorView initView];
    return showHonorView;
}

- (void)initView {
    self.level    = @"1";
    _provinceName = @"全国";
    _cityName     = @"所有市";
    _countryName  = @"所有县(区)";
    [self.provinceButton setTitle:_provinceName forState:UIControlStateNormal];
    [self.cityButton setTitle:_cityName forState:UIControlStateNormal];
    [self.countryButton setTitle:_countryName forState:UIControlStateNormal];
}

- (IBAction)provinceButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelector:title:level:)]) {
        [self.delegate didSelector:_provinceCode title:_provinceName level:@"1"];
    }
}

- (IBAction)cityButtonClick:(UIButton *)sender {
    if ([self.provinceName isEqualToString:@"全国"]) {
        [sender setTitleColor:titleLabColor forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"工程订单_排序off"] forState:UIControlStateNormal];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(didSelector:title:level:)]) {
        [self.delegate didSelector:_cityCode title:_cityName level:@"2"];
    }
}

- (IBAction)countryButtonClick:(UIButton *)sender {
    if ([self.provinceName isEqualToString:@"全国"] || [self.cityName isEqualToString:@"所有市"]) {
        [sender setTitleColor:titleLabColor forState:UIControlStateNormal];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(didSelector:title:level:)]) {
        [self.delegate didSelector:_countryCode title:_countryName level:@"3"];
    }
}

-(void)setProvinceName:(NSString *)provinceName {
    _provinceName = provinceName;
    [self.provinceButton setTitle:provinceName forState:UIControlStateNormal];
    [self.cityButton setTitleColor:titleLabColor forState:UIControlStateNormal];
    [self.cityButton setImage:[UIImage imageNamed:@"工程订单_排序off"] forState:UIControlStateNormal];
    [self.cityButton setTitle:@"所有市" forState:UIControlStateNormal];

    [self.countryButton setTitleColor:titleLabColor forState:UIControlStateNormal];
    [self.countryButton setImage:[UIImage imageNamed:@"工程订单_排序off"] forState:UIControlStateNormal];
    [self.countryButton setTitle:@"所有县(区)" forState:UIControlStateNormal];
}

-(void)setProvinceCode:(NSString *)provinceCode {
    _provinceCode = provinceCode;
    self.cityCode = nil;
    self.countryCode = nil;
}

-(void)setCityName:(NSString *)cityName {
    _cityName = cityName;
    [self.cityButton setTitle:cityName forState:UIControlStateNormal];
    [self.cityButton setTitleColor:NavColor forState:UIControlStateNormal];
    [self.cityButton setImage:[UIImage imageNamed:@"工程订单_排序on"] forState:UIControlStateNormal];

    [self.countryButton setTitleColor:titleLabColor forState:UIControlStateNormal];
    [self.countryButton setImage:[UIImage imageNamed:@"工程订单_排序off"] forState:UIControlStateNormal];
    [self.countryButton setTitle:@"所有县(区)" forState:UIControlStateNormal];
}

-(void)setCityCode:(NSString *)cityCode {
    _cityCode = cityCode;
    self.countryCode = nil;
}

-(void)setCountryName:(NSString *)countryName {
    _countryName = countryName;
    [self.countryButton setTitle:countryName forState:UIControlStateNormal];
    [self.countryButton setTitleColor:NavColor forState:UIControlStateNormal];
    [self.countryButton setImage:[UIImage imageNamed:@"工程订单_排序on"] forState:UIControlStateNormal];
}

-(void)setCountryCode:(NSString *)countryCode {
    _countryCode = countryCode;
}
@end
