//
//  ZIKShaidanDetailPingZanTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/14.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKShaidanDetailPingZanTableViewCell.h"
#import "ZIKShaiDanDetailModel.h"
#import "UIButton+ZIKEnlargeTouchArea.h"//button扩展点击区域

@interface ZIKShaidanDetailPingZanTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *pingLabel;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;

@end

static NSInteger zanNum = 0;
@implementation ZIKShaidanDetailPingZanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     [self.zanButton setEnlargeEdgeWithTop:15 right:60 bottom:10 left:20];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKShaidanDetailPingZanTableViewCellID = @"kZIKShaidanDetailPingZanTableViewCellID";
    ZIKShaidanDetailPingZanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKShaidanDetailPingZanTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKShaidanDetailPingZanTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(ZIKShaiDanDetailModel *)model  {
    self.pingLabel.text = [NSString stringWithFormat:@"%@次",model.pingLun];
    if (model.dianZanUid) {
        [self.zanButton setBackgroundImage:[UIImage imageNamed:@"赞_on内容页"] forState:UIControlStateNormal];
    }
    if (model.num == 0) {
        self.zanLabel.text = [NSString stringWithFormat:@"%@次",model.dianZan];
    } else if (model.num == 1) {

         self.zanLabel.text = [NSString stringWithFormat:@"%ld次",zanNum + 1];
    } else if (model.num == 2) {
        self.zanLabel.text = [NSString stringWithFormat:@"%ld次",zanNum - 1];

    }
    NSString *string = [self.zanLabel.text substringToIndex:1];//截取掉下标0之后的字符串

    zanNum = string.integerValue;
}

-(void)setZanButtonBlock:(ZanButtonBlock)zanButtonBlock {
    _zanButtonBlock = [zanButtonBlock copy];
    [self.zanButton addTarget:self action:@selector(openButtonClick) forControlEvents:UIControlEventTouchUpInside];
 }

- (void)openButtonClick {
    _zanButtonBlock();
}


@end
