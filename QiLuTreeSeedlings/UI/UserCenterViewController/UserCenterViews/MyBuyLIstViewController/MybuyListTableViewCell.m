//
//  MybuyListTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/4/26.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "MybuyListTableViewCell.h"
#import "UIDefines.h"
#import "StringAttributeHelper.h"
@interface MybuyListTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeImageLeading;
@end

@implementation MybuyListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.titleLab setTextColor:titleLabColor];
    [self.timeLab setTextColor:detialLabColor];
    [self.cityLab setTextColor:detialLabColor];
    [self.priceLab setTextColor:yellowButtonColor];
    // Initialization code
    self.timeImageLeading.constant = kWidth/2-30;
//    self.cityLab.backgroundColor = [UIColor yellowColor];
}

//-(void)layoutSubviews {
//    [_timeLab setNumberOfLines:1];
//    _timeLab.lineBreakMode = NSLineBreakByWordWrapping;
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
//    CGSize size = [self.titleLab.text boundingRectWithSize:CGSizeMake(70, 20) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//    [_timeLab setFrame:CGRectMake(kWidth/2+220, _timeLab.frame.origin.y, size.width, size.height)];
//    [_timeimage setFrame:CGRectMake(_timeLab.frame.origin.x-17, _timeimage.frame.origin.y, _timeimage.frame.size.width, _timeimage.frame.size.height)];
//    [_cityLab setFrame:CGRectMake(_cityLab.frame.origin.x, _cityLab.frame.origin.y, _timeimage.frame.origin.x-_cityLab.frame.origin.x, _cityLab.frame.size.height)];
//
//}

+(NSString *)IDStr
{
    return @"MybuyListTableViewCell";
}

-(void)setHotBuyModel:(HotBuyModel *)hotBuyModel
{
    _hotBuyModel=hotBuyModel;
    self.titleLab.text=hotBuyModel.title;
    self.cityLab.text=hotBuyModel.area;
    
    self.timeLab.text=hotBuyModel.timeAger;
    if (hotBuyModel.state==BuyStateUnAudit) {
        [self.stateImage setImage:[UIImage imageNamed:@"shenhezhong"]];
    }
    if (hotBuyModel.state==BuyStatePastAudit) {
        [self.stateImage setImage:[UIImage imageNamed:@"yitongguo"]];
    }
    if (hotBuyModel.state==BuyStateUnPassAudit) {
        [self.stateImage setImage:[UIImage imageNamed:@"weitonguo"]];
    }
    if (hotBuyModel.state==BuyStateColose) {
        [self.stateImage setImage:[UIImage imageNamed:@"yiguanbi"]];
    }
    if (hotBuyModel.state==BuyStateOverdue) {
        [self.stateImage setImage:[UIImage imageNamed:@"yiguoqi"]];
    }
//    NSArray *priceAry=[hotBuyModel.price componentsSeparatedByString:@"."];
//    self.priceLab.text=[priceAry firstObject];
    NSString *priceString = [NSString stringWithFormat:@"价格 ¥%@", hotBuyModel.price];
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:19.0f];
    fullFont.effectRange  = NSMakeRange(0, priceString.length);
    ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
    fullColor.color = yellowButtonColor;
    fullColor.effectRange = NSMakeRange(0,priceString.length);
    //局部设置
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:14.0f];
    partFont.effectRange = NSMakeRange(0, 4);
    ForegroundColorAttribute *darkColor = [ForegroundColorAttribute new];
    darkColor.color = yellowButtonColor;
    darkColor.effectRange = NSMakeRange(0, 3);

    self.priceLab.attributedText = [priceString mutableAttributedStringWithStringAttributes:@[fullFont,partFont,fullColor,darkColor]];

    if (hotBuyModel.isSelect) {
         self.isSelect = YES;
         self.selected = YES;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ZIKMyNuserListTableViewCellID = @"MybuyListTableViewCell";
    MybuyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZIKMyNuserListTableViewCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MybuyListTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.timeimage setBackgroundColor:[UIColor whiteColor]];
    [self.dingweiimage setBackgroundColor:[UIColor whiteColor]];
    // Configure the view for the selected state
}

@end
