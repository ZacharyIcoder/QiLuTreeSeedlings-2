//
//  ZIKArrowViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/22.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKBaseViewController.h"
#import "ZIKFunction.h"
#import "HttpClient.h"

@interface ZIKArrowViewController : ZIKBaseViewController
/**
 *  视图标题
 */
@property (nonatomic,weak)UIButton *backBtn;
@property (nonatomic, strong) NSString *vcTitle;
@property (nonatomic,strong) UIView *navBackView;
@end
