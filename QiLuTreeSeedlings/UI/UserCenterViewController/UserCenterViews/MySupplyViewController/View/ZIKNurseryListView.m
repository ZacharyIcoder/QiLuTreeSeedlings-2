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

- (void)configerView:(NSArray *)dataArray withSelectAry:(NSArray *)ary {
    self.list = [[ZIKLinkedList alloc] init];
    if (ary.count > 0) {
        for (NSInteger i = 0; i < ary.count; i++) {
            ZIKNurseryListSelectButton *button = [[ZIKNurseryListSelectButton alloc] init];
            NSDictionary *dic = ary[i];
            button.frame      = CGRectMake(10, 10+i*40, self.frame.size.width-20, 20);
            button.tag        = i;
            [button setImage:[UIImage imageNamed:@"苗圃基地选择框"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"苗圃基地已选择框"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//            button.backgroundColor = [UIColor yellowColor];
            if ([dic[@"checked"] integerValue] == 1) {
                button.selected = YES;
            }
            [button setTitle:dic[@"name"] forState:UIControlStateNormal];
//            button.titleLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:button];
            [self.list addItem:button];
//            if (ary.count>0) {
//                for (NSString *uid in ary) {
                 //}
            //}
        }
        return;
    }
    for (NSInteger i = 0; i < dataArray.count; i++) {
        ZIKNurseryListSelectButton *button = [[ZIKNurseryListSelectButton alloc] init];
        NSDictionary *dic = dataArray[i];
        button.frame      = CGRectMake(10, 10+i*40, self.frame.size.width-20, 20);
        button.tag        = i;
//        button.backgroundColor = [UIColor yellowColor];
        [button setImage:[UIImage imageNamed:@"苗圃基地选择框"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"苗圃基地已选择框"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:dic[@"nurseryName"] forState:UIControlStateNormal];
//        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:button];
        [self.list addItem:button];
        
    }
}

- (void)buttonClick:(ZIKNurseryListSelectButton *)button {
    //button.imageView.image = nil;
    button.selected = !button.selected;
   
//    NSLog(@"%d",button.selected);
//    NSLog(@"%@",button.imageView.image);
//    NSLog(@"%@",button.currentImage);
//    NSLog(@"%@",button.currentImage.description);
    //[button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    //[button setImage:[UIImage imageNamed:@"苗圃基地已选择框"] forState:UIControlStateSelected];

}

- (id)nextObject {
    self.currentNode = self.currentNode.nextNode;
    return self.currentNode;
}

- (void)resetIterator {
    self.currentNode = self.list.headNode;
}

@end
