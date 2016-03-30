//
//  ZIKNurseryListView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKNurseryListView.h"
#import "ZIKNurseryListSelectButton.h"
#import "ZIKLinkedList.h"
@interface ZIKNurseryListView ()
@property (nonatomic,  strong) NSArray *datasArray;
@property (nonatomic, strong) ZIKLinkedList   *list;
@property (nonatomic, strong) ZIKIteratorNode *currentNode;
@end
@implementation ZIKNurseryListView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (void)configerView:(NSArray *)dataArray {
    self.list = [[ZIKLinkedList alloc] init];
    for (NSInteger i = 0; i < dataArray.count; i++) {
        ZIKNurseryListSelectButton *button = [[ZIKNurseryListSelectButton alloc] init];
        NSDictionary *dic = dataArray[i];
        button.frame      = CGRectMake(10, 10+i*40, 100, 20);
        button.tag        = i;
        [button setImage:[UIImage imageNamed:@"苗圃基地选择框"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"苗圃基地已选择框"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:dic[@"nurseryName"] forState:UIControlStateNormal];
        [self addSubview:button];
        [self.list addItem:button];
    }
}

- (void)buttonClick:(UIButton *)button {
    button.selected = !button.selected;
}

- (id)nextObject {
    self.currentNode = self.currentNode.nextNode;
    return self.currentNode;
}

- (void)resetIterator {
    self.currentNode = self.list.headNode;
}

@end
