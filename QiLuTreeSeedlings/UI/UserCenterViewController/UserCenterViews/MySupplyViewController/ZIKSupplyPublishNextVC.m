//
//  ZIKSupplyPublishNextVC.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKSupplyPublishNextVC.h"
//#import "ZIKSupplyPUblishNextFirstTableViewCell.h"
#import "PickerShowView.h"
#import "HttpClient.h"
#import "ZIKNurseryListView.h"
#import "ZIKIteratorNode.h"
#import "ZIKNurseryListSelectButton.h"
#import "BWTextView.h"
#import "JSONKit.h"
#import "ZIKMySupplyViewController.h"
@interface ZIKSupplyPublishNextVC ()<UITableViewDelegate,UITableViewDataSource,PickeShowDelegate>
{
    UIButton *ecttiveBtn;
    ZIKNurseryListView *listView;
    BWTextView *productDetailTextView;
}
@property (nonatomic, strong) UITableView    *supplyInfoTableView;
@property (nonatomic, strong) NSArray        *titleMarray;
@property (nonatomic, strong) UITextField    *countTextField;
@property (nonatomic, strong) UITextField    *priceTextField;
@property (nonatomic, strong) PickerShowView *ecttivePickerView;
@property (nonatomic, assign) NSInteger      ecttiv;
@property (nonatomic, strong) NSArray        *nurseryArray;
@property (nonatomic, strong) NSMutableArray *nurseryUidMArray;
@property (nonatomic, strong) NSDictionary *baseMsgDic;
@property (nonatomic, strong) NSArray *oldnurseryArray;
@end

@implementation ZIKSupplyPublishNextVC
-(id)initWithNurseryList:(NSArray *)nurseryAry WithbaseMsg:(NSDictionary *)baseDic
{
    self=[super init];
    if (self) {
        self.oldnurseryArray = nurseryAry;
        self.baseMsgDic = baseDic;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"供应发布";
    [self requestMyNurseryList];

    [self initData];
    [self initUI];
}

- (void)requestMyNurseryList {
    [HTTPCLIENT getNurseryListWithPage:@"1" WithPageSize:@"15" Success:^(id responseObject) {
        NSArray *array = responseObject[@"result"];
        self.nurseryArray = array;
        [self.supplyInfoTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)initData {
    self.ecttiv = 0;
    self.titleMarray = @[@[@"数量",@"上车价",@"有效期"],@[@"苗圃基地",@"产品描述"]];
        self.nurseryUidMArray = [NSMutableArray array];
    if (self.oldnurseryArray) {
        for (NSDictionary *dic in self.oldnurseryArray) {
            [self.nurseryUidMArray addObject:[dic objectForKey:@"uid"]];
        }
    }
}

- (void)initUI {
    self.supplyInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height-64-60) style:UITableViewStylePlain];
    self.supplyInfoTableView.delegate   = self;
    self.supplyInfoTableView.dataSource = self;
    [self.view addSubview:self.supplyInfoTableView];
    [ZIKFunction setExtraCellLineHidden:self.supplyInfoTableView];

    UIButton *nextBtn = [[UIButton alloc] init];
    nextBtn.frame = CGRectMake(40, Height-60, Width-80, 44);
    [nextBtn setTitle:@"确认发布" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:NavColor];
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return self.nurseryArray.count * 40;
        }
        else if (indexPath.row == 1) {
            return 100;
        }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    else if (section == 1) {
        return 2;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
        {   static NSString *cellIdentifyName = @"kFirstCellId";
            UITableViewCell *firstSectionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifyName];
            if (firstSectionCell == nil) {
                firstSectionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifyName];
                firstSectionCell.textLabel.text = self.titleMarray[indexPath.section][indexPath.row];
            }
            if (indexPath.row == 0) {
                if (!_countTextField) {
                    self.countTextField = [[UITextField alloc] init];
                    UILabel *label = [[UILabel alloc] init];
                    label.frame = CGRectMake(kWidth-50, 5, 40, 30);
                    label.text = @"棵";
                    label.textAlignment = NSTextAlignmentRight;
                    [firstSectionCell addSubview:label];

                }
                if (self.baseMsgDic) {
                    self.countTextField.text=[NSString stringWithFormat:@"%@",[self.baseMsgDic objectForKey:@"count"]];
                }

                self.countTextField.frame = CGRectMake(100, 5, kWidth-100-60, 34);
                self.countTextField.placeholder = @"请输入数量";
                [firstSectionCell addSubview:self.countTextField];


            }
            if (indexPath.row == 1)  {
                if (!_priceTextField) {
                    self.priceTextField = [[UITextField alloc] init];
                    self.priceTextField.frame = CGRectMake(100, 5, kWidth-100-60, 34);
                    [firstSectionCell addSubview:self.priceTextField];
                    UILabel *label = [[UILabel alloc] init];
                    label.frame = CGRectMake(kWidth-50, 5, 40, 30);
                    label.text = @"元";
                    label.textAlignment = NSTextAlignmentRight;
                    [firstSectionCell addSubview:label];
                }
                self.priceTextField.placeholder = @"请输入价格";
                if (self.baseMsgDic) {
                 
                    self.priceTextField.text=[NSString stringWithFormat:@"%@",[self.baseMsgDic objectForKey:@"price"]];
                }


            }
            if (indexPath.row == 2) {
                if (!ecttiveBtn) {
                ecttiveBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, kWidth-200, 40)];
                    [firstSectionCell addSubview:ecttiveBtn];

                }
                ecttiveBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
                [ecttiveBtn setTitle:@"请选择有效期" forState:UIControlStateNormal];
                [ecttiveBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                [ecttiveBtn addTarget:self action:@selector(ecttiveBtnAction) forControlEvents:UIControlEventTouchUpInside];
                if (self.baseMsgDic) {
                    self.ecttiv=[[self.baseMsgDic objectForKey:@"effective"] integerValue];
                    NSArray *effectiveAry = @[@"长期",@"一个月",@"三个月",@"半年",@"一年"];
                    if (effectiveAry.count>=self.ecttiv) {
                          NSString *effectiveStr=effectiveAry[self.ecttiv-1];
                        [ecttiveBtn setTitle:effectiveStr forState:UIControlStateNormal];
                    }
                  
                }

            }
            cell = firstSectionCell;
        }
            break;
        case 1: {
            static NSString *cellIdentifyName2 = @"kTwoCellId";
            UITableViewCell *secondSectionCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifyName2];
            if (secondSectionCell == nil) {
                secondSectionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifyName2];
                secondSectionCell.textLabel.text = self.titleMarray[indexPath.section][indexPath.row];
            }
            if (indexPath.row == 0) {
                listView = [[ZIKNurseryListView alloc] init];
                listView.frame = CGRectMake(100, 0, kWidth-200, self.nurseryArray.count*40);
                [listView configerView:self.nurseryArray withSelectAry:self.nurseryUidMArray];
                [secondSectionCell addSubview:listView];
            }
            if (indexPath.row == 1) {
                productDetailTextView  = [[BWTextView alloc] init];
                productDetailTextView.placeholder = @"请输入产品描述...";
                if (self.baseMsgDic) {
                    productDetailTextView.text=[self.baseMsgDic objectForKey:@"remark"];
                }

                productDetailTextView.frame = CGRectMake(100, 5, kWidth-100-30, 90);
                [secondSectionCell addSubview:productDetailTextView];
               // productDetailTextView.pl
            }
            cell = secondSectionCell;
        }
            break;
                   break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)nextBtnClick {
    if (self.countTextField.text.length == 0 || self.countTextField.text == nil) {
        [ToastView showTopToast:@"请输入数量"];
        return;
    }
    if (!self.ecttiv) {
        [ToastView showTopToast:@"请选择有效期"];
        return;
    }
    [self.nurseryUidMArray removeAllObjects];
    ZIKIteratorNode *node = nil;
    [listView resetIterator];
    while (node = [listView nextObject]) {
        ZIKNurseryListSelectButton *button = node.item;
        if (button.selected) {
            //NSLog(@"%@",button.titleLabel.text);
            NSDictionary *dic = self.nurseryArray[button.tag];
            [self.nurseryUidMArray addObject:dic[@"nrseryId"]];
        }
    }
    if (self.nurseryUidMArray.count == 0) {
        [ToastView showTopToast:@"请至少选择一个苗木基地"];
        return;
    }
    if (self.ecttiv == 0) {
        [ToastView showTopToast:@"请选择有效期"];
        return;
    }
    self.supplyModel.count = self.countTextField.text;
    if (self.priceTextField.text.length == 0 || self.priceTextField.text == nil) {
        self.supplyModel.price = @"面议";
    }
    else {
        self.supplyModel.price = self.priceTextField.text;
    }
    self.supplyModel.effectiveTime = [NSString stringWithFormat:@"%ld",(long)self.ecttiv];
    //self.supplyModel.murseryUid = [self.nurseryUidMArray JSONString];
    __block NSString *nurseryUidString = @"";
    [self.nurseryUidMArray enumerateObjectsUsingBlock:^(NSString *uid, NSUInteger idx, BOOL * _Nonnull stop) {
        nurseryUidString = [nurseryUidString stringByAppendingString:[NSString stringWithFormat:@",%@",uid]];
    }];
    self.supplyModel.murseryUid = [nurseryUidString substringFromIndex:1];
    //NSLog(@"%@",self.supplyModel);
    self.supplyModel.remark = productDetailTextView.text;
    [self requestSaveSupplyInfo];
}

- (void)ecttiveBtnAction {
    if (!self.ecttivePickerView) {
        self.ecttivePickerView = [[PickerShowView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.ecttivePickerView resetPickerData:@[@"长期",@"一个月",@"三个月",@"半年",@"一年"]];
    }
    self.ecttivePickerView.delegate = self;
    [self.ecttivePickerView showInView];
}

-(void)selectNum:(NSInteger)select
{
    //NSLog(@"%ld",select+1);
    self.ecttiv = select+1;
}

- (void)selectInfo:(NSString *)select {
    ecttiveBtn.titleLabel.text = nil;
    [ecttiveBtn setTitle:select forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestSaveSupplyInfo {
    [HTTPCLIENT saveSupplyInfoWithAccessToken:nil accessId:nil clientId:nil clientSecret:nil deviceId:nil uid:nil title:self.supplyModel.title name:self.supplyModel.name productUid:self.supplyModel.productUid count:self.supplyModel.count price:self.supplyModel.price effectiveTime:self.supplyModel.effectiveTime remark:self.supplyModel.remark nurseryUid:self.supplyModel.murseryUid imageUrls:self.supplyModel.imageUrls imageCompressUrls:self.supplyModel.imageCompressUrls withSpecificationAttributes:self.supplyModel.specificationAttributes Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
             [ToastView showTopToast:@"发布成功"];
            [ToastView showTopToast:@"提交成功，即将返回"];
            [self performSelector:@selector(backRootView) withObject:nil afterDelay:1];
//            for(UIViewController *controller in self.navigationController.viewControllers) {
//                if([controller isKindOfClass:[ZIKMySupplyViewController class]]){
//                    ZIKMySupplyViewController *owr = (ZIKMySupplyViewController *)controller;
//                    [self.navigationController popToViewController:owr animated:YES];
//                }
//            }
        }
        else {
            //NSLog(@"%@",responseObject[@"msg"]);
            [ToastView showTopToast:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        //NSLog(@"%@",error);
    }];
}
-(void)backRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
