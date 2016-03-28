//
//  ZIKIteratorNode.m
//  SanMiKeJi
//
//  Created by 孔德志 on 15/12/9.
//  Copyright © 2015年 SanMi. All rights reserved.
//

#import "ZIKIteratorNode.h"

@implementation ZIKIteratorNode
+ (instancetype)nodeWithItem:(id)item {
    
    ZIKIteratorNode *node = [[[self class] alloc] init];
    node.item  = item;
    
    return node;
}

@end
