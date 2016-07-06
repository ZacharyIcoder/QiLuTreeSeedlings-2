//
//  ZIKStationShowHonorView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKCertificateAdapterProtocol.h"
@interface ZIKStationShowHonorView : UIView
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *imageString;
/**
 *  颁发机构
 */
@property (nonatomic, copy) NSString *issuingAuthority;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *uid;
+(ZIKStationShowHonorView *)instanceShowHonorView;
- (void)loadData:(id <ZIKCertificateAdapterProtocol>)data;
@end
