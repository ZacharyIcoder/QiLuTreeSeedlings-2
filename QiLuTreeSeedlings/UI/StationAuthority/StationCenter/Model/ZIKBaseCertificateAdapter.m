//
//  ZIKCertificateAdapter.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKBaseCertificateAdapter.h"

@implementation ZIKBaseCertificateAdapter
- (instancetype)initWithData:(id)data {

    self = [super init];
    if (self) {

        self.data = data;
    }

    return self;
}

- (NSString *)name {
    return nil;
}

- (NSString *)time; {
    return nil;
}

- (NSString *)imageString {
    return nil;
}

- (NSString *)issuingAuthority {
    return nil;
}

- (NSString *)level {
    return nil;
}

- (NSString *)uid {
    return nil;
}

@end
