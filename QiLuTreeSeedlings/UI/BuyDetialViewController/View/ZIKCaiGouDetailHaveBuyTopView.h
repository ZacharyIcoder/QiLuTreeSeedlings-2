//
//  ZIKCaiGouDetailHaveBuyTopView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/8/16.
//  Copyright © 2016年 中亿科技. All rights reserved.
//  站长中心定制信息已购买详情顶部页面

#import <UIKit/UIKit.h>
@protocol ZIKCaiGouDetailHaveBuyTopViewDelegate <NSObject>

@required
-(void)gotoDetail;

@end

@interface ZIKCaiGouDetailHaveBuyTopView : UIView
/**
 *  订单编号
 */
@property (nonatomic, copy) NSString *orderNo;
/**
 *  订单ID
 */
@property (nonatomic, copy) NSString *orderUid;
/**
 *  推送记录ID
 */
@property (nonatomic, copy) NSString *recordUid;
@property (nonatomic, assign) id<ZIKCaiGouDetailHaveBuyTopViewDelegate>delegate;
+(ZIKCaiGouDetailHaveBuyTopView *)instanceTopView;

@end
