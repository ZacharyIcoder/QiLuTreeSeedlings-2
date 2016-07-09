//
//  yYLDGZZRongYaoTableCell.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKStationHonorListModel.h"
typedef void(^imageBtnClickedBlock)(ZIKStationHonorListModel *model);
@interface yYLDGZZRongYaoTableCell : UITableViewCell <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollV;
@property (weak, nonatomic) IBOutlet UIPageControl *pageContr;
@property (nonatomic,strong)NSArray *dataAry;
@property (nonatomic,copy) imageBtnClickedBlock imageBlock;
+(yYLDGZZRongYaoTableCell *)yldGZZRongYaoTableCell;
-(void)showImageActionBlock:(imageBtnClickedBlock)imageBlock;
@end
