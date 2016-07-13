//
//  ZIKCertificateAdapter.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/5.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKCertificateAdapter.h"
#import "GCZZModel.h"//资质model
#import "ZIKStationHonorListModel.h"//荣誉model
@implementation ZIKCertificateAdapter
- (instancetype)initWithData:(id)data {

    self = [super init];
    if (self) {

        self.data = data;
    }

    return self;
}

- (NSString *)name {
    NSString *name = nil;
    if ([self.data isMemberOfClass:[GCZZModel class]]) {
        GCZZModel *model = self.data;
        name = model.companyQualification;
    } else if ([self.data isMemberOfClass:[ZIKStationHonorListModel class]]) {
        ZIKStationHonorListModel *model = self.data;
        name = model.name;
    }
    return name;
}

- (NSString *)time {
    NSString *time = nil;
    if ([self.data isMemberOfClass:[GCZZModel class]]) {
        GCZZModel *model = self.data;
        time = model.acqueTime;
    } else if ([self.data isMemberOfClass:[ZIKStationHonorListModel class]]) {
        ZIKStationHonorListModel *model = self.data;
        time = model.acquisitionTime;
    }
    return time;
}

- (NSString *)imageString {
    NSString *imageString = nil;
    if ([self.data isMemberOfClass:[GCZZModel class]]) {
        GCZZModel *model = self.data;
        imageString = model.image;
    } else if ([self.data isMemberOfClass:[ZIKStationHonorListModel class]]) {
        ZIKStationHonorListModel *model = self.data;
        imageString = model.image;
    }
    return imageString;
}

- (NSString *)issuingAuthority {
    NSString *issuingAuthority = nil;
    if ([self.data isMemberOfClass:[GCZZModel class]]) {
        GCZZModel *model = self.data;
        issuingAuthority = model.issuingAuthority;
    } else if ([self.data isMemberOfClass:[ZIKStationHonorListModel class]]) {
        //ZIKStationHonorListModel *model = self.data;
        issuingAuthority = nil;
    }
    return issuingAuthority;
}

- (NSString *)level {
    NSString *level = nil;
    if ([self.data isMemberOfClass:[GCZZModel class]]) {
        GCZZModel *model = self.data;
        level = model.level;
    } else if ([self.data isMemberOfClass:[ZIKStationHonorListModel class]]) {
        //ZIKStationHonorListModel *model = self.data;
        level = nil;
    }
    return level;
}

- (NSString *)uid {
    NSString *uid = nil;
    if ([self.data isMemberOfClass:[GCZZModel class]]) {
        GCZZModel *model = self.data;
        uid = model.uid;
    } else if ([self.data isMemberOfClass:[ZIKStationHonorListModel class]]) {
        ZIKStationHonorListModel *model = self.data;
        uid = model.uid;
    }
    return uid;
}

@end
