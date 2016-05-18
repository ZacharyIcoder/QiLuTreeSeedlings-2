//
//  BuySearchTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/3.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "BuySearchTableViewCell.h"
#import "UIDefines.h"
#import "StringAttributeHelper.h"
#define kSCREEN_EDGE_DISTANCE 15 //距离屏幕边缘距离
@interface BuySearchTableViewCell()
//@property (nonatomic,strong)UIImageView *imageV;
@property (nonatomic,strong)UILabel *priceLab;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *cityLab;
@property (nonatomic,strong)UILabel *timeLab;
//@property (nonatomic,strong)UILabel *numLab;
@end
@implementation BuySearchTableViewCell
{
    UIImageView * timeImag;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithFrame:(CGRect)frame
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame=frame;
        //[self setAccessibilityIdentifier:@"SellSearchTableViewCell2"];
        self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(18, 10, kWidth-20, 13)];
        [self.titleLab setTextColor:titleLabColor];
        [self.titleLab setFont:[UIFont systemFontOfSize:15]];
        [self.titleLab setText:@"标题"];
        [self.contentView addSubview:self.titleLab];
        UIImageView *dingweiImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 38, 15, 15)];
        [dingweiImage setImage:[UIImage imageNamed:@"region"]];
        [self.contentView addSubview:dingweiImage];
        self.cityLab=[[UILabel alloc]initWithFrame:CGRectMake(38, 40, 60, 12)];
        
        [self.cityLab setFont:[UIFont systemFontOfSize:12]];
        [self.cityLab setText:@"临沂"];
        [self.cityLab setTextColor:detialLabColor];
        [self.contentView addSubview:self.cityLab];
         timeImag=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth*0.5-45,38, 15, 15)];
         [timeImag setImage:[UIImage imageNamed:@"listtime"]];
        [self.contentView addSubview:timeImag];
        self.timeLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth*0.5-15, 38, 70, 12)];
         [self.timeLab setTextColor:detialLabColor];
        [self.timeLab setFont:[UIFont systemFontOfSize:12]];
        [self.timeLab setText:@"N天前"];
        [self.contentView addSubview:self.timeLab];
//        UILabel *priceLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth*0.8-25, 40, 30, 12)];
//        [priceLab setFont:[UIFont systemFontOfSize:12]];
//        [priceLab setText:@"价格"];
//        [self.contentView addSubview:priceLab];
//         [priceLab setTextColor:detialLabColor];
        self.priceLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-170-kSCREEN_EDGE_DISTANCE, 35, 170, 20)];
        [self.priceLab setFont:[UIFont systemFontOfSize:18]];
        [self.priceLab setText:@"O元"];
        [self.priceLab setTextColor:yellowButtonColor];
        [self.contentView addSubview:self.priceLab];
        self.priceLab.textAlignment = NSTextAlignmentRight;
        UIImageView *imageVLine=[[UIImageView alloc]initWithFrame:CGRectMake(13, frame.size.height-0.5, kWidth-26, 0.5)];
        [imageVLine setBackgroundColor:kLineColor];
        [self.contentView addSubview:imageVLine];
        self.selectionStyle=UITableViewCellSelectionStyleBlue;
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        //self.frame=frame;
        [self setAccessibilityIdentifier:@"SellSearchTableViewCell2"];
        self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(18, 10, kWidth-20, 13)];
        [self.titleLab setTextColor:titleLabColor];
        [self.titleLab setFont:[UIFont systemFontOfSize:15]];
        [self.titleLab setText:@"标题"];
        [self.contentView addSubview:self.titleLab];
        UIImageView *dingweiImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 38, 15, 15)];
        [dingweiImage setImage:[UIImage imageNamed:@"region"]];
        [self.contentView addSubview:dingweiImage];
        self.cityLab=[[UILabel alloc]initWithFrame:CGRectMake(38, 40, 60, 12)];
        
        [self.cityLab setFont:[UIFont systemFontOfSize:12]];
        [self.cityLab setText:@"临沂"];
        [self.cityLab setTextColor:detialLabColor];
        [self.contentView addSubview:self.cityLab];
        timeImag=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth*0.5-45,38, 15, 15)];
        [timeImag setImage:[UIImage imageNamed:@"listtime"]];
        [self.contentView addSubview:timeImag];
        self.timeLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth*0.5-15, 38, 70, 12)];
        [self.timeLab setTextColor:detialLabColor];
        [self.timeLab setFont:[UIFont systemFontOfSize:12]];
        [self.timeLab setText:@"N天前"];
        [self.contentView addSubview:self.timeLab];

        self.priceLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-170-kSCREEN_EDGE_DISTANCE, 35, 170, 20)];
        [self.priceLab setFont:[UIFont systemFontOfSize:18]];
        [self.priceLab setText:@"O元"];
        [self.priceLab setTextColor:yellowButtonColor];
        [self addSubview:self.priceLab];
        self.priceLab.textAlignment = NSTextAlignmentRight;

        UIImageView *imageVLine=[[UIImageView alloc]initWithFrame:CGRectMake(13, frame.size.height-0.5, kWidth-26, 0.5)];
        [imageVLine setBackgroundColor:kLineColor];
        [self.contentView addSubview:imageVLine];
       // self.selectionStyle=UITableViewCellSelectionStyleBlue;
        
    }
    return self;
}
+(NSString *)IDStr
{
    return @"SellSearchTableViewCell2";
}
-(void)setHotBuyModel:(HotBuyModel *)hotBuyModel
{
    _hotBuyModel=hotBuyModel;
    self.titleLab.text=hotBuyModel.title;
    self.cityLab.text=hotBuyModel.area;
   
        self.timeLab.text=hotBuyModel.timeAger;
    [_timeLab setNumberOfLines:1];
    _timeLab.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize size = [hotBuyModel.timeAger boundingRectWithSize:CGSizeMake(70, 20) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    [_timeLab setFrame:CGRectMake(_timeLab.frame.origin.x, _timeLab.frame.origin.y, size.width, size.height)];
    [timeImag setFrame:CGRectMake(_timeLab.frame.origin.x-17, timeImag.frame.origin.y, timeImag.frame.size.width, timeImag.frame.size.height)];

    NSArray *priceAry=[hotBuyModel.price componentsSeparatedByString:@"."];
//    self.priceLab.text=[priceAry firstObject];
    NSString *priceString = [NSString stringWithFormat:@"价格 ¥%@", [priceAry firstObject]];
    FontAttribute *fullFont = [FontAttribute new];
    fullFont.font = [UIFont systemFontOfSize:18.0f];
    fullFont.effectRange  = NSMakeRange(0, priceString.length);
    ForegroundColorAttribute *fullColor = [ForegroundColorAttribute new];
    fullColor.color = yellowButtonColor;
    fullColor.effectRange = NSMakeRange(0,priceString.length);
    //局部设置
    FontAttribute *partFont = [FontAttribute new];
    partFont.font = [UIFont systemFontOfSize:14.0f];
    partFont.effectRange = NSMakeRange(0, 4);
    ForegroundColorAttribute *darkColor = [ForegroundColorAttribute new];
    darkColor.color = detialLabColor;
    darkColor.effectRange = NSMakeRange(0, 3);

    self.priceLab.attributedText = [priceString mutableAttributedStringWithStringAttributes:@[fullFont,partFont,fullColor,darkColor]];

    if (hotBuyModel.isSelect) {
        self.selected = YES;
        self.isSelect = YES;
    }
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
    // Configure the view for the selected stat
}

@end
