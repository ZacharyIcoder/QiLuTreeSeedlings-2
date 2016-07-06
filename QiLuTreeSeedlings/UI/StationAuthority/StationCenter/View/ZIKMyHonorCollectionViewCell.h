//
//  ZIKMyHonorCollectionViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZIKStationHonorListModel;
#import "GCZZModel.h"
typedef void(^EditButtonBlock)(NSIndexPath *indexPath);
typedef void(^DeleteButtonBlock)(NSIndexPath *indexPath);

@interface ZIKMyHonorCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic  ) IBOutlet UIImageView       *honorImageView;
@property (weak, nonatomic  ) IBOutlet UILabel           *honorTitleLabel;
@property (weak, nonatomic  ) IBOutlet UILabel           *honorTimeLabel;
@property (strong,nonatomic ) GCZZModel *ZZmodel;
@property (nonatomic, assign) BOOL              isEditState;

@property (nonatomic, strong) NSIndexPath       *indexPath;
@property (nonatomic, copy  ) EditButtonBlock   editButtonBlock;
@property (nonatomic, copy  ) DeleteButtonBlock deleteButtonBlock;

-(void)configureCellWithModel:(ZIKStationHonorListModel *)model;
@end
