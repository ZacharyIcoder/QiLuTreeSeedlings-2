//
//  ZIKCustomizedModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/6.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKCustomizedModel : NSObject
@property (nonatomic, copy  ) NSString *customsetUid;
@property (nonatomic, copy  ) NSString *price;
@property (nonatomic, copy  ) NSString *productName;
@property (nonatomic, copy  ) NSString *productUid;
@property (nonatomic, copy  ) NSArray  *spec;
@property (nonatomic, assign) BOOL     isSelect;
//新增
@property (nonatomic, assign) BOOL     isShow;
@property (nonatomic, strong) NSArray  *haveSpecArray;
@property (nonatomic, strong) NSArray  *specArray;
@end
