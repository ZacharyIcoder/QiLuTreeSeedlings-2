//
//  ZIKWorkstationSelectListView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/7/8.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZIKWorkstationSelectListView;
@protocol ZIKWorkstationSelectListViewDataSource <NSObject>
//行数
- (NSInteger)numberOfRowsInfTable:(ZIKWorkstationSelectListView *)selectListView;
//标题
- (NSString *)selectListView:(ZIKWorkstationSelectListView *)selectListView titleForRow:(NSInteger)row;
//编码
- (NSString *)selectListView:(ZIKWorkstationSelectListView *)selectListView codeForRow:(NSInteger)row;
@end

@protocol ZIKWorkstationSelectListViewDelegate <NSObject>

- (void) didSelectRowAtIndexPath:(ZIKWorkstationSelectListView *)selectListView title:(NSString *)title coel:(NSString *)code;

@end


@interface ZIKWorkstationSelectListView : UIView

@property (weak, nonatomic) IBOutlet UITableView *selectAraeTableView;
@property (nonatomic,assign)id<ZIKWorkstationSelectListViewDataSource> dataSource;
@property (nonatomic,assign)id<ZIKWorkstationSelectListViewDelegate> listdelegate ;

@property (nonatomic, assign) BOOL isShow;
+(ZIKWorkstationSelectListView *)instanceSelectListView;
@end
