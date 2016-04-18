//
//  ZIKPaySuccessViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/5.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKArrowViewController.h"

@interface ZIKPaySuccessViewController : ZIKArrowViewController
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (copy, nonatomic) NSString *price;
- (IBAction)finishButton:(id)sender;

@end
