//
//  ZIKMySupplyCreateModel.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKMySupplyCreateModel : NSObject
/**
 *  供应ID (只在修改保存有，新发布的不存在uid)
 */
@property (nonatomic, copy) NSString *uid;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  产品名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  产品ID
 */
@property (nonatomic, copy) NSString *productUid;
/**
 *  数量
 */
@property (nonatomic, copy) NSString *count;
/**
 *  上车价，不填时，为面议
 */
@property (nonatomic, copy) NSString *price;
/**
 *  有效期	1:长期；2：一月；3：三月；4半年；5一年
 */
@property (nonatomic, copy) NSString *effectiveTime;
/**
 *  供应产品说明
 */
@property (nonatomic, copy) NSString *remark;
/**
 *  苗圃ID，以数组的形式传入，可多个
 */
@property (nonatomic, copy) NSString *murseryUid;
/**
 *  原图url，以数组形式传入，有且只传3张
 */
@property (nonatomic, copy) NSString *imageUrls;
/**
 *  压缩图url，以数组形式传入，有且只传3张，以”-compress”结尾
 */
@property (nonatomic, copy) NSString *imageCompressUrls;
/**
 *  规格属性(英文名=value)
 */
@property (nonatomic, copy) NSString *SpecificationAttributes;
@end
