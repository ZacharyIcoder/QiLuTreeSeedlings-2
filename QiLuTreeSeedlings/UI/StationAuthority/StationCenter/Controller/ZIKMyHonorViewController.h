//
//  ZIKMyHonorViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"
typedef NS_ENUM(NSInteger, Type) {
    TypeHonor         = 1,//我的荣誉
    TypeQualification = 2 //我的资质
};
@interface ZIKMyHonorViewController : ZIKRightBtnSringViewController
/**
 *  站长Uid
 */
@property (nonatomic, copy) NSString *workstationUid;

/**
 *  企业Uuid
 */
@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) Type type;
@end
