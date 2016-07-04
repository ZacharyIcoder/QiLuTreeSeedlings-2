//
//  ZIKMyHonorCollectionViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZIKStationHonorListModel;

@interface ZIKMyHonorCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *honorImageView;
@property (weak, nonatomic) IBOutlet UILabel *honorTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *honorTimeLabel;

@property (nonatomic, assign) BOOL isEditState;

-(void)configureCellWithModel:(ZIKStationHonorListModel *)model;
@end
