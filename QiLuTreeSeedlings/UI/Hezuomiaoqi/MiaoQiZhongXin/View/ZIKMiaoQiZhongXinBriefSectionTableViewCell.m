//
//  ZIKMiaoQiZhongXinBriefSectionTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/9.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKMiaoQiZhongXinBriefSectionTableViewCell.h"
#import "ZIKMiaoQiZhongXinModel.h"

@interface ZIKMiaoQiZhongXinBriefSectionTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;

@property (weak, nonatomic) IBOutlet UIButton *openButton;
@end

@implementation ZIKMiaoQiZhongXinBriefSectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *kZIKMiaoQiZhongXinBriefSectionTableViewCellID = @"kZIKStationCenterContentTableViewCellID";
    ZIKMiaoQiZhongXinBriefSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKMiaoQiZhongXinBriefSectionTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZIKMiaoQiZhongXinBriefSectionTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)configureCell:(ZIKMiaoQiZhongXinModel *)model {
//    self.briefLabel.text = [NSString stringWithFormat:@"简介:afwEFWIEFIWEFJO;WQJFIJQIOFJO WQQJWFIOJWIOQJFEIOJWQIOFJIOWQJFIOJWQIOJFIJWQIOFJIWQJFIJWQIJFIOJWQIOFJIWQJFIJWQIOFJIWJQIFJIWJFIOJWEIOFJIWJFIJWIJFIWJFIJWIOEQJFIOWJQFIOJWIQOFJIWJFIOWJQIOFWQIFJIOQWFJIOQWJFIOJQWFIQWJFIOOJWIFJIWOQEJFIWJQFIJWQIFJIWQJEFIWJQIFJWIQJFIWQJFIJWIQFJIWJQFIJWQIEFJWIQJFEWEIOFJWEIFJWIQJFIJWQIFJWIQJFIWJQFIOJWQIJFIWJQFIJWIFJWQEF %@",model.gybrief];
    if (model.gybrief) {
        self.briefLabel.text = [NSString stringWithFormat:@"简介: %@",model.gybrief];
    } else {
        self.briefLabel.text = [NSString stringWithFormat:@"简介: 暂无简介"];
    }

    //展开隐藏
    if (model.isShow) {
        self.briefLabel.numberOfLines = 0;
        [self.openButton setImage:[UIImage imageNamed:@"rolock"] forState:UIControlStateNormal];
        [self.openButton setTitle:@"隐藏更多" forState:UIControlStateNormal];
    } else {
        self.briefLabel.numberOfLines = 2;
        [self.openButton setImage:[UIImage imageNamed:@"rounlock"] forState:UIControlStateNormal];
        [self.openButton setTitle:@"展开更多" forState:UIControlStateNormal];
    }
}


-(void)setOpenButtonBlock:(OpenButtonBlock)openButtonBlock {
    _openButtonBlock = [openButtonBlock copy];
    [self.openButton addTarget:self action:@selector(openButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)openButtonClick {
    _openButtonBlock(self.indexPath);
}

@end
