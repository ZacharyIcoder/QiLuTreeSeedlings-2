//
//  ZIKSupplyPublishNameTableViewCell.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/24.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZIKSupplyPublishNameTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configureCell:(id)data;
@end
