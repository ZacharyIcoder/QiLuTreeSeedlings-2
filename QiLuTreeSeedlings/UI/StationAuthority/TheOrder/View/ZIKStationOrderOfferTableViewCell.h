//
//  ZIKStationOrderOfferTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZIKStationOrderDetailQuoteModel;
typedef void (^QuoteBtnBlock) (NSInteger);
@interface ZIKStationOrderOfferTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderUidLabel;
@property (weak, nonatomic) IBOutlet UIButton *quoteButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, copy  ) QuoteBtnBlock      quoteBtnBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(ZIKStationOrderDetailQuoteModel *)model;
@end
