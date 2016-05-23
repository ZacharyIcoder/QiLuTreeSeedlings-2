//
//  ZIKSectionInfo.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKSectionInfo.h"
#import "ZIKCitySectionHeaderView.h"
#import "ZIKCityModel.h"
@implementation ZIKSectionInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        _rowHeights  = [[NSMutableArray alloc] init];
        _selectNum   = 0;
        _open        = NO;
        _isAllSelect = NO;
    }
    return self;
}

- (NSUInteger)countOfRowHeights {
    return [self.rowHeights count];
}

- (id)objectInRowHeightsAtIndex:(NSUInteger)idx {
    return self.rowHeights[idx];
}

- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx {
    [self.rowHeights insertObject:anObject atIndex:idx];
}

- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes {
    [self.rowHeights insertObjects:rowHeightArray atIndexes:indexes];
}

- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx {
    [self.rowHeights removeObjectAtIndex:idx];
}

- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes {
    [self.rowHeights removeObjectsAtIndexes:indexes];
}

- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject {
    self.rowHeights[idx] = anObject;
}

- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray {
    [self.rowHeights replaceObjectsAtIndexes:indexes withObjects:rowHeightArray];
}

//-(void)setOpen:(BOOL)open {
//    _open = open;
//    self.headerView.disclosureButton.selected = _open;
//}

-(void)setSelectNum:(NSInteger)selectNum {
    _selectNum = selectNum;
    if (_selectNum == 0 ) {
        self.headerView.selectHintLabel.hidden = YES;
        self.headerView.titleLable.textColor = titleLabColor;
        return;
    }
    self.headerView.selectHintLabel.hidden = NO;
    self.isAllSelect = NO;
    self.headerView.selectHintLabel.text = [NSString stringWithFormat:@"已选%ld项",(long)_selectNum];
    self.headerView.titleLable.textColor = NavColor;
//    self.headerView.titleLable.textColor = Nav
}

-(void)setIsAllSelect:(BOOL)isAllSelect {
    _isAllSelect = isAllSelect;
    if (_isAllSelect) {
       self.headerView.selectHintLabel.text = @"已全选";
        self.headerView.selectHintLabel.hidden = NO;
        self.headerView.titleLable.textColor = NavColor;
    }
    //self.headerView.selectHintLabel.text = (_isAllSelect ? @"已全选" : @"未全选");
}
//-(void)setHeaderView:(ZIKCitySectionHeaderView *)headerView {
//
//}
@end
