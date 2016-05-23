//
//  ZIKCitySectionHeaderView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/5/19.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKCitySectionHeaderView.h"
@implementation ZIKCitySectionHeaderView

-(void)awakeFromNib {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.disclosureButton setImage:[UIImage imageNamed:@"carat-open"] forState:UIControlStateSelected];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
    [self addGestureRecognizer:tapGesture];
    self.titleLable.textColor = titleLabColor;
    self.selectHintLabel.textColor = NavColor;
    self.lineview.backgroundColor = BGColor;
}

- (IBAction)toggleOpen:(id)sender {
    [self toggleOpenWithUserAction:YES];
}

- (void)toggleOpenWithUserAction:(BOOL)userAction {

    // toggle the disclosure button state
    self.disclosureButton.selected = !self.disclosureButton.selected;

    // if this was a user action, send the delegate the appropriate message
    if (userAction) {
        if (self.disclosureButton.selected) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}

@end
