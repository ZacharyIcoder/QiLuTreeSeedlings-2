//
//  ZIKNurseryListView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKIteratorProtocol.h"
@interface ZIKNurseryListView : UIView<ZIKIteratorProtocol>
//@property (nonatomic,strong) NSMutableArray *buttonSelectArray;
- (void)configerView:(NSArray *)dataArray withSelectAry:(NSArray *)ary;
@end
