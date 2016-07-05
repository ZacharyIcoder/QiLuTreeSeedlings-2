//
//  ZIKMyHonorCollectionViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/6/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMyHonorCollectionViewCell.h"
#import "ZIKStationHonorListModel.h"
#import "UIImageView+AFNetworking.h"
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
    NSURL *honorUrl = [NSURL URLWithString:model.image];
    [self.honorImageView setImageWithURL:honorUrl placeholderImage:[UIImage imageNamed:@"MoRentu"]];
    self.honorTimeLabel.text = model.acquisitionTime;
    self.honorTitleLabel.text = model.name;
}

- (void)setIsEditState:(BOOL)isEditState {
    _isEditState = isEditState;
    if (_isEditState) {
        self.backView.hidden = NO;
    } else {
        self.backView.hidden = YES;
    }
}

-(void)setEditButtonBlock:(EditButtonBlock)editButtonBlock {
    _editButtonBlock = editButtonBlock;
    [self.editButton addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)editButtonClick {
    _editButtonBlock(self.indexPath);
}

-(void)setDeleteButtonBlock:(DeleteButtonBlock)deleteButtonBlock {
    _deleteButtonBlock = deleteButtonBlock;
    [self.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteButtonClick {
    _deleteButtonBlock(self.indexPath);
}
@end
