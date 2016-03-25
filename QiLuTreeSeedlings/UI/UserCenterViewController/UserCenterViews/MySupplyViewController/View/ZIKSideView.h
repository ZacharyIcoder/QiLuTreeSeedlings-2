//
//  ZIKSideView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/24.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKSelectView.h"
@interface ZIKSideView : UIView<ZIKSelectViewDelegate>
@property (nonatomic, strong) ZIKSelectView *selectView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UILabel *pleaseSelectLabel;
- (void)removeSideViewAction;
@end
