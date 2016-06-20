//
//  ZIKStationCenterTableViewHeaderView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/18.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKStationCenterTableViewHeaderView.h"

@implementation ZIKStationCenterTableViewHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)backBtnClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZIKBackHome" object:nil];

}

@end
