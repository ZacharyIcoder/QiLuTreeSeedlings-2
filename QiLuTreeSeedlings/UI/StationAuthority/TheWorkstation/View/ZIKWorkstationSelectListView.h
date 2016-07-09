//
//  ZIKWorkstationSelectListView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZIKWorkstationSelectListView : UIView
@property (weak, nonatomic) IBOutlet UITableView *selectAraeTableView;

+(ZIKWorkstationSelectListView *)instanceSelectListView;
@end
