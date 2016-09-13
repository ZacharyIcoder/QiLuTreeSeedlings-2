//
//  ZIKStationCenterInfoViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/23.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"
@class MasterInfoModel,ZIKMiaoQiZhongXinModel;
@interface ZIKStationCenterInfoViewController : ZIKArrowViewController
@property (nonatomic, strong) MasterInfoModel *masterModel;
@property (nonatomic, strong) ZIKMiaoQiZhongXinModel *miaoModel;
@property (nonatomic, copy) NSString *type;
@end
