//
//  ZIKSectionInfo.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZIKCitySectionHeaderView;
@class ZIKCityModel;
@interface ZIKSectionInfo : NSObject
@property (nonatomic,assign) BOOL open;
@property (nonatomic,assign) NSInteger selectNum;
@property (nonatomic,assign) BOOL isAllSelect;
@property ZIKCityModel *cityModel;
@property ZIKCitySectionHeaderView *headerView;
@property (nonatomic) NSMutableArray *rowHeights;
- (NSUInteger)countOfRowHeights;
- (id)objectInRowHeightsAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx;
- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject;
- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes;
- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray;

@end
