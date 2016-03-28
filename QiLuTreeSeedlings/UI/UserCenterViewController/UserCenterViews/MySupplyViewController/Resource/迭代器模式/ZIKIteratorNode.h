//
//  ZIKIteratorNode.h
//  SanMiKeJi
////Created by YouXianMing on 15/11/15.
//  copy by 孔德志            on 15/12/9.
//  Copyright © 2015年 SanMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZIKIteratorNode : NSObject
/**
 *  指向下一个节点
 */
@property (nonatomic, strong) ZIKIteratorNode  *nextNode;

/**
 *  节点挂载的对象
 */
@property (nonatomic, weak)   id     item;

/**
 *  便利构造器
 *
 *  @param item 节点挂载的对象
 *
 *  @return Node对象
 */
+ (instancetype)nodeWithItem:(id)item;

@end
