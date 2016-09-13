//
//  ZIKAddHonorViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/4.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"
#import "ZIKStationHonorListModel.h"
@interface ZIKAddHonorViewController : ZIKArrowViewController
@property (nonatomic, copy) NSString *workstationUid;
/**
 *  荣誉id
 */
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *miaoqiUid;
@property (nonatomic, copy) NSString *memberUid;
@property (nonatomic, strong) ZIKStationHonorListModel *miaoqiModel;
@end
