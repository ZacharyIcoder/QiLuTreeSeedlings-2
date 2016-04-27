//
//  ZIKPayRecordCell.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/27.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKPayRecordCell.h"
#import "ZIKConsumeRecordModel.h"
#import "ZIKConsumeRecordFrame.h"
#import "UIDefines.h"
@interface ZIKPayRecordCell ()
@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UILabel     *reasonLabel;
@property (nonatomic, weak) UILabel     *priceLabel;
@property (nonatomic, weak) UILabel     *timeLabel;
@end;
@implementation ZIKPayRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *kZIKPayRecordCellID = @"kZIKPayRecordCellID";

    ZIKPayRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kZIKPayRecordCellID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kZIKPayRecordCellID];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupTopView];
    }

    return self;
}
/**
 *  头像，名字，时间，活动设置
 */
- (void)setupTopView
{

    UIImageView *headIcon  = [[UIImageView alloc] init];
    [self addSubview:headIcon];
    self.icon              = headIcon;

    UILabel *nameLabel     = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    nameLabel.textColor    = titleLabColor;
    self.priceLabel        = nameLabel;

    UILabel *timeLabel     = [[UILabel alloc] init];
    timeLabel.textColor    = detialLabColor;
    [self addSubview:timeLabel];
    self.timeLabel         = timeLabel;

    UILabel *contentLabel  = [[UILabel alloc] init];
    [self addSubview:contentLabel];
    contentLabel.textColor = titleLabColor;
    self.reasonLabel       = contentLabel;

}

-(void)setRecordFrame:(ZIKConsumeRecordFrame *)recordFrame {
    _recordFrame = recordFrame;
    [self setTopViewData];
}

- (void)setTopViewData {
    ZIKConsumeRecordModel *model   = self.recordFrame.recordModel;

    self.icon.frame                = self.recordFrame.iconF;
    if ([model.type isEqualToString:@"1"]) {//消费
    self.icon.image                = [UIImage imageNamed:@"消费记录-消费"];
    self.priceLabel.textColor      = NavColor;
    self.priceLabel.text           = [NSString stringWithFormat:@"¥ : -%@",model.price];
    }
    else if ([model.type isEqualToString:@"0"]) {//充值
    self.icon.image                = [UIImage imageNamed:@"消费记录-充值"];
    self.priceLabel.textColor      = kRGB(241, 157, 65, 1);
    self.priceLabel.text           = [NSString stringWithFormat:@"¥ : +%@",model.price];
    }
    self.priceLabel.textAlignment  = NSTextAlignmentRight;
    self.priceLabel.font           = [UIFont systemFontOfSize:18];
    self.priceLabel.frame          = self.recordFrame.priceF;

    self.reasonLabel.text          = model.reason;
    self.reasonLabel.font          = StatusReasonFont;
    self.reasonLabel.frame         = self.recordFrame.reasonF;
//    if (self.recordFrame.reasonF.size.height == 19 *3) {
//        self.reasonLabel.numberOfLines = 3;
//    }
//    else {
    self.reasonLabel.numberOfLines = 0;
    //}

    self.timeLabel.text            = model.time;
    self.timeLabel.font            = StatusTimeFont;
    self.timeLabel.frame           = self.recordFrame.timeF;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
