//
//  ZIKSupplyPublishNextVC.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKArrowViewController.h"

#import "ZIKMySupplyCreateModel.h"//供应信息model
#import "ZIKAddImageView.h"       //添加图片view

@interface ZIKSupplyPublishNextVC : ZIKArrowViewController
/**
 *  供应信息model
 */
@property (nonatomic, strong) ZIKMySupplyCreateModel *supplyModel;
/**
 *  添加图片view
 */
@property (nonatomic, weak  ) ZIKAddImageView *pickerImgView;
/**
 *  根据苗圃数组和修改的供应信息的苗圃数组初始化
 *
 *  @param nurseryAry 苗圃数组
 *  @param baseDic 修改的供应信息的苗圃数组
 *
 *  @return ZIKSupplyPublishNextVC
 */
-(id)initWithNurseryList:(NSArray *)nurseryAry WithbaseMsg:(NSDictionary *)baseDic;
@end
