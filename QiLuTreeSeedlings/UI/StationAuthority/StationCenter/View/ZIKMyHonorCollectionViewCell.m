//
//  ZIKMyHonorCollectionViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMyHonorCollectionViewCell.h"
#import "ZIKStationHonorListModel.h"

@interface ZIKMyHonorCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation ZIKMyHonorCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backView.alpha = 1;
    self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

    self.isEditState = NO;
}

-(void)configureCellWithModel:(ZIKStationHonorListModel *)model {

}

- (void)setIsEditState:(BOOL)isEditState {
    _isEditState = isEditState;
    if (_isEditState) {
        self.backView.hidden = NO;
    } else {
        self.backView.hidden = YES;
    }
}

@end
