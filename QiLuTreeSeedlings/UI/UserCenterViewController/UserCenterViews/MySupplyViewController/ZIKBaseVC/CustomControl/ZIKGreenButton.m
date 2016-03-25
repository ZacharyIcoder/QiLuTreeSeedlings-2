//
//  ZIKGreenButton.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/24.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKGreenButton.h"
#import "UIDefines.h"
@implementation ZIKGreenButton

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = kWineButtonColor;
        [self setTitleColor:NavColor forState:UIControlStateNormal];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.0f;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [NavColor CGColor];
    }
    return self;
}

@end
