//
//  ZIKMyHonorCollectionViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKCertificateAdapterProtocol.h"
@class ZIKStationHonorListModel;
#import "GCZZModel.h"
typedef void(^EditButtonBlock)(NSIndexPath *indexPath);
typedef void(^DeleteButtonBlock)(NSIndexPath *indexPath);

@interface ZIKMyHonorCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *honorTypeLab;
@property (weak, nonatomic  ) IBOutlet UIImageView       *honorImageView;
@property (weak, nonatomic  ) IBOutlet UILabel           *honorTitleLabel;
@property (weak, nonatomic  ) IBOutlet UILabel           *honorTimeLabel;
@property (strong,nonatomic ) GCZZModel *ZZmodel;
@property (nonatomic, assign) BOOL              isEditState;

@property (nonatomic, strong) NSIndexPath       *indexPath;
@property (nonatomic, copy  ) EditButtonBlock   editButtonBlock;
@property (nonatomic, copy  ) DeleteButtonBlock deleteButtonBlock;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *imageString;
/**
 *  颁发机构
 */
@property (nonatomic, copy) NSString *issuingAuthority;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *uid;

- (void)loadData:(id <ZIKCertificateAdapterProtocol>)data;
@end
