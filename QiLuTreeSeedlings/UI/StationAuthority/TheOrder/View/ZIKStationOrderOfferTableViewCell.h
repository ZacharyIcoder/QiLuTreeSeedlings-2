//
//  ZIKStationOrderOfferTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZIKStationOrderOfferTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(id)model;
@end
