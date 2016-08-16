//
//  QRCodeViewController.h
//  SoNice
//
//  Created by 孔思哲 on 15/9/5.
//  Copyright (c) 2015年 Sanmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKArrowViewController.h"

@interface QRCodeViewController : ZIKArrowViewController
@property (nonatomic, copy) void (^QRCodeCancleBlock) (QRCodeViewController *);//扫描取消
@property (nonatomic, copy) void (^QRCodeSuccessBlock) (QRCodeViewController *,NSString *);//扫描结果
@property (nonatomic, copy) void (^QRCodeFailBlock) (QRCodeViewController *);//扫描失败
@end
