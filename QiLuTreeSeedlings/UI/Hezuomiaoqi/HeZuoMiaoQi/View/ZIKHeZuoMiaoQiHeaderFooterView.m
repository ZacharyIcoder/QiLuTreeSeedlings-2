//
//  ZIKHeZuoMiaoQiHeaderFooterView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/7.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKHeZuoMiaoQiHeaderFooterView.h"
@interface ZIKHeZuoMiaoQiHeaderFooterView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *moremoreButton;
@end

@implementation ZIKHeZuoMiaoQiHeaderFooterView

-(void)setStarNum:(NSInteger)starNum {
    _starNum = starNum;
    if (starNum == 5) {
        self.titleLabel.text = @"五星级合作苗企";
    } else if (starNum == 4) {
        self.titleLabel.text = @"四星级合作苗企";
    } else if (starNum == 3) {
        self.titleLabel.text = @"三星级合作苗企";
    }
//    else if (starNum == 2) {
//        self.titleLabel.text = @"二星级合作苗企";
//    } else if (starNum == 1) {
//        self.titleLabel.text = @"一星级合作苗企";
//    }
}


-(void)setMoreButtonBlock:(MoreButtonBlock)moreButtonBlock {
    _moreButtonBlock = [moreButtonBlock copy];
    [self.moreButton addTarget:self action:@selector(openButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.moremoreButton addTarget:self action:@selector(openButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)openButtonClick {
    _moreButtonBlock(self.indexPath);
}


@end
