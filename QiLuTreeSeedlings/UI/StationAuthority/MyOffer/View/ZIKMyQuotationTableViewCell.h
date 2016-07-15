//
//  ZIKMyQuotationTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZIKMyOfferQuoteListModel;
@interface ZIKMyQuotationTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(ZIKMyOfferQuoteListModel *)model;

@end
