//
//  ZIKLinkedList.m
//  SanMiKeJi
//
//  Created by 孔德志 on 15/12/9.
//  Copyright © 2015年 SanMi. All rights reserved.
//

#import "ZIKLinkedList.h"
@interface ZIKLinkedList ()
@property (nonatomic, strong) ZIKIteratorNode       *headNode;
@property (nonatomic)         NSInteger   numberOfNodes;

@end
@implementation ZIKLinkedList
- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        self.headNode = [ZIKIteratorNode new];
    }
    
    return self;
}

- (void)addItem:(id)item {
    
    if (self.headNode == nil) {
        
        // 创建头结点
        self.headNode = [ZIKIteratorNode nodeWithItem:item];
        
    } else {
        
        [self addItem:item node:self.headNode];
    }
    
    self.numberOfNodes++;
}

#pragma mark - 私有方法
- (void)addItem:(id)item node:(ZIKIteratorNode *)node {
    
    if (node.nextNode == nil) {
        
        node.nextNode = [ZIKIteratorNode nodeWithItem:item];
        
    } else {
        
        [self addItem:item node:node.nextNode];
    }
}

@end
