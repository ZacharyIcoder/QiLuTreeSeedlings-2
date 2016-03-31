//
//  ZIKMySupplyDetailViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/31.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"

@interface ZIKMySupplyDetailViewController : ZIKRightBtnSringViewController
///**
// *  供应ID
// */
//@property (nonatomic, copy) NSString *uid;
/**
 *  根据供应Uid创建我的供应详情
 *
 *  @param uid 供应Uid
 *
 *  @return return value description
 */
-(id)initMySupplyDetialWithUid:(NSString *)uid;
@end
