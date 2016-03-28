//
//  ZIKIteratorProtocol.h
//  SanMiKeJi
//
//  Created by 孔德志 on 15/12/9.
//  Copyright © 2015年 SanMi. All rights reserved.
//
//迭代器模式（Iterator），提供一种方法顺序访问一个聚合对象中的各种元素，而又不暴露该对象的内部表示。
//在这里不适合用，我只是想试试，不暴露的代价是传值要繁琐一点，迭代器适合需要顺序访问的时候
#import <Foundation/Foundation.h>

@protocol ZIKIteratorProtocol <NSObject>
@required
/**
 *  下一个对象
 *
 *  @return 对象
 */
- (id)nextObject;

/**
 *  重置迭代器(重置指针)
 */
- (void)resetIterator;

@end
