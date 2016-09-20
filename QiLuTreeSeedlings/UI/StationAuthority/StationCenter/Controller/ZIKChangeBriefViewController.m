//
//  ZIKChangeBriefViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/9/20.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKChangeBriefViewController.h"

@interface ZIKChangeBriefViewController ()

@property (weak, nonatomic) IBOutlet BWTextView *briefBWTextView;
@end

@implementation ZIKChangeBriefViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = self.titleString;
    if (_setString) {
        self.briefBWTextView.text = _setString;
    } else {
        self.briefBWTextView.placeholder = self.placeholderString;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
