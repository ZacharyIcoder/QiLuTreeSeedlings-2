//
//  ZIKWorkstationSelectViewAboutAddressButton.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/15.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LZRelayoutButtonType) {
    LZRelayoutButtonTypeNomal  = 0,//默认
    LZRelayoutButtonTypeLeft   = 1,//标题在左
    LZRelayoutButtonTypeBottom = 2,//标题在下
};

@interface ZIKWorkstationSelectViewAboutAddressButton : UIButton
@property (assign,nonatomic)LZRelayoutButtonType lzType;

@end
