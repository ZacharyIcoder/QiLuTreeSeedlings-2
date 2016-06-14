//
//  ZIKPasswordSetViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKPasswordSetViewController.h"

@interface ZIKPasswordSetViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)NSMutableArray *dataSource;

@end

@implementation ZIKPasswordSetViewController
@synthesize myTableView;
@synthesize dataSource;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle = @"修改密码";
    [self initUI];
}

- (void)initUI {
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height-64) style:UITableViewStyleGrouped];
    //[myTableView setBackgroundColor:BB_Back_Color_Here];
    [myTableView setBackgroundView:nil];
    [myTableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.dataSource     = self;
    myTableView.delegate       = self;
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];

}
#pragma mark- TableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"BWMChangePasswordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.backgroundColor = BB_White_Color;
    }else
    {
        for(UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
    }

    //左侧
    UILabel *labLeft = [[UILabel alloc]init];
    labLeft.backgroundColor = [UIColor clearColor];
    labLeft.textAlignment = NSTextAlignmentLeft;
    labLeft.font = [UIFont boldSystemFontOfSize:15];
    labLeft.tag = 10;
    labLeft.textColor = [UIColor grayColor];
    [cell.contentView addSubview:labLeft];
    [labLeft setHidden:YES];

    //输入TextField
    UITextField *password = [[UITextField alloc]init];
    password.textColor = [UIColor grayColor];
    password.font = [UIFont systemFontOfSize:15.0];
    password.secureTextEntry = YES;
    password.delegate = self;
    password.keyboardType = UIKeyboardTypeDefault;
    password.tag = 11+indexPath.row;
    password.frame = CGRectMake(15, 11, 160+120, 20);
    password.textAlignment = NSTextAlignmentLeft;
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    password.returnKeyType = UIReturnKeyDone;
    [cell.contentView addSubview:password];
    NSMutableArray *temArr = [[NSMutableArray alloc]initWithObjects:@"请输入原密码",@"请输入新密码",@"请再输入一次", nil];
    labLeft.frame = CGRectMake(10, 0, 120, 44);

    password.placeholder = [temArr objectAtIndex:indexPath.row];

    password.text = @"";
    if (0 == indexPath.row)
    {
        [password becomeFirstResponder];
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    if (0 == section)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [footView addSubview:btn];
        btn.frame = CGRectMake(40, 23, Width-80, 44);
//        [XtomFunction addbordertoView:btn radius:6.0f width:0.0f color:[UIColor clearColor]];
        [btn setBackgroundColor:NavColor];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //btn.titleLabel.textColor = BackGorundColor;
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        //[btn setTitleColor:BB_White_Color forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn addTarget:self action:@selector(sureButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    }

    return footView;
}

-(void)sureButtonPress:(UIButton*)sender
{
    UITextField *textField  = (UITextField *)[myTableView viewWithTag:11];
    UITextField *textfield1 = (UITextField *)[myTableView viewWithTag:12];
    UITextField *textfield2 = (UITextField *)[myTableView viewWithTag:13];
    [textField resignFirstResponder];
    [textfield1 resignFirstResponder];
    [textfield2 resignFirstResponder];
    if (textfield1.text.length == 0)
    {
        [ToastView showTopToast:@"密码不能为空"];
        //[XtomFunction openIntervalHUD:@"密码不能为空" view:self.view];
        return;
    }
    if (textfield2.text.length == 0)
    {
        [ToastView showTopToast:@"两次新密码输入不一致"];
        //[XtomFunction openIntervalHUD:@"密码不能为空" view:self.view];
        return;
    }

    if ((textfield2.text.length< 6||textfield2.text.length > 20) ||(textfield1.text.length< 6||textfield1.text.length > 12))
    {
        //[XtomFunction openIntervalHUD:@"密码6至12位" view:self.view];
        [ToastView showTopToast:@"密码6至20位"];
        return;
    }
    if (![ZIKFunction xfunc_isPassword:textfield2.text]) {
        [ToastView showTopToast:@"密码只能包含数字，字母和下划线"];
        return;
    }
    if(![textfield2.text isEqualToString:textfield1.text])
    {
        [ToastView showTopToast:@"两次新密码输入不一致"];
        //[XtomFunction openIntervalHUD:@"两次新密码输入不一致" view:self.view];
        return;
    }
    [textfield1 resignFirstResponder];
    [textfield2 resignFirstResponder];


    [self requestMyResetPassword:textField.text mynew:textfield1.text];
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
    UITableViewCell *temCell = (UITableViewCell*)[myTableView cellForRowAtIndexPath:indexPath];
    UITextField *passwords = (UITextField*)[temCell viewWithTag:11];
    [passwords becomeFirstResponder];
}

#pragma mark- 委托

- (BOOL)textFieldShouldReturn:(id)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- 连接服务器
#pragma mark- 保存新密码
-(void)requestMyResetPassword:(NSString*)myold mynew:(NSString*)mynew
{

    [HTTPCLIENT changeUserPwdWithToken:nil WithAccessID:nil WithClientID:nil WithClientSecret:nil WithDeviceID:nil WithOldPassWord:myold WithNewPassWord:mynew
    Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue] == 1) {
            [ToastView showTopToast:@"密码修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [ToastView showTopToast:responseObject[@"msg"]];
        }

    } failure:^(NSError *error) {

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
