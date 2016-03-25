//
//  ZIKSelectProductCategoryTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/24.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZIKSelectProductCategoryTableViewCell : UITableViewCell
/**
 *  名称
 */
@property (nonatomic, copy) NSString *typeName;
/**
 *  ID
 */
@property (nonatomic, copy) NSString *typeUid;
/**
 *  产品名称
 */
@property (nonatomic, copy) NSString *productName;
/**
 *  产品Uid
 */
@property (nonatomic, copy) NSString *productUid;
@end
