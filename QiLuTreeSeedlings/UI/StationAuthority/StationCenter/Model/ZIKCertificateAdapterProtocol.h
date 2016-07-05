//
//  ZIKCertificateAdapterProtocol.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZIKCertificateAdapterProtocol <NSObject>

- (NSString *)name;

- (NSString *)time;

- (NSString *)imageString;

- (NSString *)issuingAuthority;

- (NSString *)level;

- (NSString *)uid;

@end
