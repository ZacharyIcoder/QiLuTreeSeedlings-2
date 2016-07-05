//
//  ZIKStationShowHonorView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationShowHonorView.h"

@interface ZIKStationShowHonorView()

@property (weak, nonatomic) IBOutlet UIImageView *honorImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
@end

@implementation ZIKStationShowHonorView

-(instancetype)initWithFrame:(CGRect)frame {
   self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

@end
