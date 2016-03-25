//
//  ZIKSelectView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/24.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//
#define kString(string) [NSString stringWithFormat:@"%@",string]

#import "ZIKSelectView.h"
#import "ZIKSelectProductCategoryTableViewCell.h"
#import "HttpClient.h"
@interface ZIKSelectView ()

@end
@implementation ZIKSelectView


-(void)setDataArray:(NSArray *)dataArray {
    _dataArray =  dataArray;
    //[self.myTableView reloadData];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
}

-(id)initWithFrame:(CGRect)frame dataArray:(NSArray *)array  {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = array;
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        //self.myTableView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.myTableView];
    }
    return self;
}

#pragma mark - UITabelViewDelegate
#pragma mark- TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellZero = @"cellid";
    ZIKSelectProductCategoryTableViewCell *cell = nil;
    cell = (ZIKSelectProductCategoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellZero];
    
    if (cell == nil) {
        cell = [[ZIKSelectProductCategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellZero];
    }
    if ([[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"typeName"]) {
       cell.textLabel.text = kString([[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"typeName"]);
       cell.typeUid = kString([[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"typeUid"]);
    }
    else if([[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"productName"]){
        cell.textLabel.text = kString([[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"productName"]);
        cell.productUid = kString([[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"productUid"]);
        cell.typeUid = nil;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor grayColor];
    
    //cell.backgroundColor = [UIColor redColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    ZIKSelectProductCategoryTableViewCell *cel = (ZIKSelectProductCategoryTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cel.typeUid) {
            if ([self.delegate respondsToSelector:@selector(didSelector:title:)]) {
            [self.delegate didSelector:cel.typeUid title:cel.textLabel.text];
        }

        [HTTPCLIENT getProductWithTypeUid:cel.typeUid type:@"1" Success:^(id responseObject) {          
            if ([[responseObject objectForKey:@"success"] integerValue] == 1 ) {
                NSArray *productArray = [responseObject[@"result"] objectForKey:@"productList"];
                if (productArray.count == 0) {
                    NSLog(@"暂时没有产品信息!!!");
                }
                else if (productArray.count > 0) {
                    self.dataArray = productArray;
                }
            }
            else if ([[responseObject objectForKey:@"success"] integerValue] == 0) {
                
            }

        } failure:^(NSError *error) {
            
        }];
    }

    if (cel.productUid) {
        if ([self.uidDelegate respondsToSelector:@selector(didSelectorUid:title:)]) {
            [self.uidDelegate didSelectorUid:cel.productUid title:cel.textLabel.text];
        }
    }

}

@end
