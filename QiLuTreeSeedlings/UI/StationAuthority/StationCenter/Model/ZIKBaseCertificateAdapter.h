//
//  ZIKCertificateAdapter.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIKCertificateAdapterProtocol.h"
@interface ZIKBaseCertificateAdapter : NSObject<ZIKCertificateAdapterProtocol>
/**
 *  输入对象
 */
@property (nonatomic, weak) id data;

/**
 *  与输入对象建立联系
 *
 *  @param data 输入的对象
 *
 *  @return 实例对象
 */
- (instancetype)initWithData:(id)data;

@end
