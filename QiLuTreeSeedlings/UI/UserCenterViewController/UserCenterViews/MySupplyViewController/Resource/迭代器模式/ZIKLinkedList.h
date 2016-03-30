//
//  ZIKLinkedList.h
//  SanMiKeJi
//
//  Created by 孔德志 on 15/12/9.
//  Copyright © 2015年 SanMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZIKIteratorNode.h"
@interface ZIKLinkedList : NSObject
/**
 *  头节点
 */
@property (nonatomic, strong, readonly) ZIKIteratorNode *headNode;

/**
 *  有几个节点
 */
@property (nonatomic, readonly) NSInteger  numberOfNodes;

/**
 *  节点挂载的对象
 *
 *  @param item 节点挂载的对象
 */
- (void)addItem:(id)item;

@end
