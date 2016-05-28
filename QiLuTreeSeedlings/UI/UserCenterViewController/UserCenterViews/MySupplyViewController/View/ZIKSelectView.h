//
//  ZIKSelectView.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/24.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZIKSelectViewDelegate <NSObject>
@optional

- (void)didSelector:(NSString *)selectId title:(NSString *)selectTitle;

@end

@protocol ZIKSelectViewUidDelegate <NSObject>

- (void)didSelectorUid:(NSString *)selectId title:(NSString *)selectTitle;

@end
@interface ZIKSelectView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView           *myTableView;
@property (nonatomic, strong) NSArray               *dataArray;
@property (nonatomic, strong) id<ZIKSelectViewDelegate> delegate;
@property (nonatomic, strong) id<ZIKSelectViewUidDelegate> uidDelegate;
@property (nonatomic, assign) BOOL                  isshow;
@property (nonatomic, copy)   NSString *type;

- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)array;
@end
