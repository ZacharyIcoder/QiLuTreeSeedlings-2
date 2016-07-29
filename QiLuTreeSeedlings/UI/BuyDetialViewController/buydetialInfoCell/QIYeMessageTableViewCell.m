//
//  QIYeMessageTableViewCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/8.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "QIYeMessageTableViewCell.h"
#import "UIDefines.h"
@interface QIYeMessageTableViewCell ()
@property (nonatomic,strong)UILabel *addressLab;
@property (nonatomic,strong)UILabel *creatTimeLab;
@property (nonatomic,strong)UILabel *endTimeLab;
@property (nonatomic,strong)UILabel *phoneLab;
@end
@implementation QIYeMessageTableViewCell
{
    @private
    UILabel *fabuTimeLab;
    UILabel *dizhiLab;
    UILabel *youxiaoTimeLab;
    UILabel *lianxiLab;
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        dizhiLab = [[UILabel alloc] init ];//WithFrame:CGRectMake(20, 10, 80, 20)];
        [dizhiLab setFont:[UIFont systemFontOfSize:13]];
        [dizhiLab setTextAlignment:NSTextAlignmentRight];
        [dizhiLab setTextColor:detialLabColor];
         dizhiLab.text = @"苗源地";
        [self addSubview:dizhiLab];
       
        self.addressLab = [[UILabel alloc] init];//WithFrame:CGRectMake(130, 10, 200, 20)];
        [self.addressLab setFont:[UIFont systemFontOfSize:14]];
//        [self.addressLab setTextAlignment:NSTextAlignmentRight];
        [self.addressLab setTextColor:titleLabColor];
//        dizhiLab.text=@"地址";
        [self.addressLab setNumberOfLines:0];
        [self addSubview:self.addressLab];
        
        fabuTimeLab= [[UILabel alloc]init];//WithFrame:CGRectMake(20, CGRectGetMaxY(self.addressLab.frame)+10, 80, 20)];
        [fabuTimeLab setFont:[UIFont systemFontOfSize:13]];
        [fabuTimeLab setTextAlignment:NSTextAlignmentRight];
        [fabuTimeLab setTextColor:detialLabColor];
        fabuTimeLab.text=@"发布日期";
        [self addSubview:fabuTimeLab];
        
        self.creatTimeLab=[[UILabel alloc]init ];//WithFrame:CGRectMake(130, fabuTimeLab.frame.origin.y, 200, 20)];
        [self.creatTimeLab setFont:[UIFont systemFontOfSize:14]];
//        [self.creatTimeLab setTextAlignment:NSTextAlignmentRight];
        [self.creatTimeLab setTextColor:titleLabColor];
        //        dizhiLab.text=@"地址";
        [self addSubview:self.creatTimeLab];
        
        youxiaoTimeLab= [[UILabel alloc]init ];//WithFrame:CGRectMake(20, 70, 80, 20)];
        [youxiaoTimeLab setFont:[UIFont systemFontOfSize:13]];
        [youxiaoTimeLab setTextAlignment:NSTextAlignmentRight];
        [youxiaoTimeLab setTextColor:detialLabColor];
        youxiaoTimeLab.text=@"有效期至";
        [self addSubview:youxiaoTimeLab];
        
        self.endTimeLab=[[UILabel alloc]init];//WithFrame:CGRectMake(130, 70, 200, 20)];
        [self.endTimeLab setFont:[UIFont systemFontOfSize:14]];
//        [self.endTimeLab setTextAlignment:NSTextAlignmentRight];
        [self.endTimeLab setTextColor:titleLabColor];
        //        dizhiLab.text=@"地址";
        [self addSubview:self.endTimeLab];
        
        lianxiLab = [[UILabel alloc]init ];//WithFrame:CGRectMake(20, 100, 80, 20)];
        [lianxiLab setFont:[UIFont systemFontOfSize:13]];
        [lianxiLab setTextAlignment:NSTextAlignmentRight];
        [lianxiLab setTextColor:detialLabColor];
        lianxiLab.text=@"联系方式";
        [self addSubview:lianxiLab];
        
        self.phoneLab=[[UILabel alloc]init ];//WithFrame:CGRectMake(130, 100, 200, 20)];
        [self.phoneLab setFont:[UIFont systemFontOfSize:14]];
        [self.phoneLab setTextColor:titleLabColor];
        [self addSubview:self.phoneLab];
    }
    return self;
}

-(void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    self.addressLab.text   = [dic objectForKey:@"address"];
    self.creatTimeLab.text = [dic objectForKey:@"createTime"];
    self.endTimeLab.text   = [dic objectForKey:@"endTime"];
    self.phoneLab.text     = [dic objectForKey:@"phone"];
}

-(void)layoutSubviews {
    dizhiLab.frame = CGRectMake(20, 10, 80, 20);
    self.addressLab.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize size = [self.addressLab.text boundingRectWithSize:CGSizeMake(kWidth-130-15, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

    self.addressLab.frame = CGRectMake(130, dizhiLab.frame.origin.y, size.width, size.height);

    fabuTimeLab.frame = CGRectMake(20, CGRectGetMaxY(self.addressLab.frame)+10, 80, 20);
    self.creatTimeLab.frame = CGRectMake(130, fabuTimeLab.frame.origin.y, 200, 20);

    youxiaoTimeLab.frame = CGRectMake(20, CGRectGetMaxY(fabuTimeLab.frame)+10, 80, 20);
    self.endTimeLab.frame = CGRectMake(130, youxiaoTimeLab.frame.origin.y, 200, 20);

    lianxiLab.frame = CGRectMake(20, CGRectGetMaxY(youxiaoTimeLab.frame)+10, 80, 20);
    self.phoneLab.frame = CGRectMake(130, lianxiLab.frame.origin.y, 200, 20);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
