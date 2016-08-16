//
//  QRCodeViewController.m
//  SoNice
//
//  Created by 孔思哲 on 15/9/5.
//  Copyright (c) 2015年 Sanmi. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width//设备宽
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height//设备高
#define kDeviceFrame [UIScreen mainScreen].bounds//设备坐标

static const float kLineMinY = 185;
static const float kLineMaxY = 385;
static const float kReaderViewWidth = 200;
static const float kReaderViewHeight = 200;

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *kSession;//会话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *kVideoPreviewLayer;//读取
@property (nonatomic, strong) UIImageView *interactiveLine;//交互线
@property (nonatomic, strong) NSTimer *interactiveLineTimer;//交互线控制

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self setOverlayPickerView];
    [self startSYQRCodeReading];
    self.vcTitle = @"扫一扫";
    [self createBackBtn];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    if (_kSession) {
        [_kSession stopRunning];
    }
    if (_interactiveLineTimer) {
        [_interactiveLineTimer invalidate];
    }
}

- (void)createBackBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(20, 28, 15, 22)];
    [btn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancleSYQRCodeReading) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //摄像头判断
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
//        [XtomFunction openIntervalHUD:@"没有找到可用的摄像头 -_-||" view:self.view];
        [ToastView showTopToast:@"没有找到可用的摄像头 -_-||"];
        return;
    }
    //设置输出（Metadata元数据）
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //设置输出地代理
    //使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [output setRectOfInterest:[self getReaderViewBoundsWithSize:CGSizeMake(kReaderViewWidth, kReaderViewHeight)]];
    //拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    //读取质量，质量越高，可读取小尺寸的二维码
    if ([session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        [session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    else if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        [session setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    else {
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    //设置输出地格式
    //一定要先设置会话的输出为output之后，再指定输出地元数据类型;
    
    //[output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
        
       // output.metadataObjectTypes = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];
         [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        
        NSLog(@"1");
    }
    else {
        // output.metadataObjectTypes = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];
        NSLog(@"2");
        //[XtomFunction openIntervalHUDOK:@"摄像头不可用" view:self.view];
//        [XtomFunction openIntervalDownHUD:@"摄像头不可用" view:self.view];
        [ToastView showTopToast:@"摄像头不可用"];

        [self cancleSYQRCodeReading];
        //output.availableMetadataObjectTypes = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];
    }

    //output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypePDF417Code];
    //[output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    //设置预览图层
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    //设置preview图层的属性
    //preview.borderColor = [UIColor redColor].CGColor;
    //preview.borderWidth = 1.5;
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //设置preview图层的大小
    preview.frame = self.view.layer.bounds;
    //[preview setFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    //将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    self.kVideoPreviewLayer = preview;
    self.kSession = session;
}

- (CGRect)getReaderViewBoundsWithSize:(CGSize)ksize {
    return CGRectMake(kLineMinY / kDeviceHeight, ((kDeviceWidth - ksize.width) / 2.0) / kDeviceWidth, ksize.height / kDeviceHeight, ksize.width / kDeviceWidth);
}

- (void)setOverlayPickerView
{
    //画中间的基准线
    _interactiveLine = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth - 300) / 2.0, kLineMinY, 300, 12 * 300 / 320.0)];
    [_interactiveLine setImage:[UIImage imageNamed:@"ff_QRCodeScanLine@2x"]];
    [self.view addSubview:_interactiveLine];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kLineMinY)];//80
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMinY, (kDeviceWidth - kReaderViewWidth) / 2.0, kReaderViewHeight)];
    leftView.alpha = 0.3;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth - CGRectGetMaxX(leftView.frame), kLineMinY, CGRectGetMaxX(leftView.frame), kReaderViewHeight)];
    rightView.alpha = 0.3;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    CGFloat space_h = kDeviceHeight - kLineMaxY;
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMaxY, kDeviceWidth, space_h)];
    downView.alpha = 0.3;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    //四个边角
    UIImage *cornerImage = [UIImage imageNamed:@"ScanQR1@2x"];
    
    //左侧的view
    UIImageView *leftView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    leftView_image.image = cornerImage;
    [self.view addSubview:leftView_image];
    
    cornerImage = [UIImage imageNamed:@"ScanQR2@2x"];
    
    //右侧的view
    UIImageView *rightView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMaxY(upView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    rightView_image.image = cornerImage;
    [self.view addSubview:rightView_image];
    
    cornerImage = [UIImage imageNamed:@"ScanQR3@2x"];
    
    //底部view
    UIImageView *downView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    downView_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView_image];
    
    cornerImage = [UIImage imageNamed:@"ScanQR4@2x"];
    
    UIImageView *downViewRight_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width / 2.0, CGRectGetMinY(downView.frame) - cornerImage.size.height / 2.0, cornerImage.size.width, cornerImage.size.height)];
    downViewRight_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downViewRight_image];
    
    //说明label
    UILabel *labIntroudction = [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame = CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(downView.frame) + 25, kReaderViewWidth, 20);
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.font = [UIFont boldSystemFontOfSize:13.0];
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"将二维码置于框内,即可自动扫描";
    [self.view addSubview:labIntroudction];
    
    UIView *scanCropView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame) - 1,kLineMinY,kDeviceWidth - 2 * CGRectGetMaxX(leftView.frame) + 2, kReaderViewHeight + 2)];
    scanCropView.layer.borderColor = [UIColor greenColor].CGColor;
    scanCropView.layer.borderWidth = 2.0;
    [self.view addSubview:scanCropView];
}

#pragma mark -
#pragma mark 输出代理方法

//此方法是在识别到QRCode，并且完成转换
//如果QRCode的内容越大，转换需要的时间就越长
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描结果
    if (metadataObjects.count > 0)
    {
        [self stopSYQRCodeReading];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        if (obj.stringValue && ![obj.stringValue isEqualToString:@""] && obj.stringValue.length > 0)
        {
            NSLog(@"---------%@",obj.stringValue);
            
            if ([obj.stringValue containsString:@"http"])
            {
                if (self.QRCodeSuccessBlock) {
                    self.QRCodeSuccessBlock(self,obj.stringValue);
                }
            }
            else
            {
                if (self.QRCodeSuccessBlock) {
                    self.QRCodeSuccessBlock(self,obj.stringValue);
                }
            }
        }
        else
        {
            if (self.QRCodeFailBlock) {
                self.QRCodeFailBlock(self);
            }
        }
    }
    else
    {
        if (self.QRCodeFailBlock) {
            self.QRCodeFailBlock(self);
        }
    }
}

#pragma mark -
#pragma mark 交互事件

- (void)startSYQRCodeReading
{
    _interactiveLineTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 20 target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
    
    [self.kSession startRunning];
    
    NSLog(@"start reading");
}

- (void)stopSYQRCodeReading
{
    if (_interactiveLineTimer)
    {
        [_interactiveLineTimer invalidate];
        _interactiveLineTimer = nil;
    }
    
    [self.kSession stopRunning];
    
    NSLog(@"stop reading");
}

//取消扫描
- (void)cancleSYQRCodeReading
{
    [self stopSYQRCodeReading];
    
    if (self.QRCodeCancleBlock)
    {
        self.QRCodeCancleBlock(self);
    }
    NSLog(@"cancle reading");
}


#pragma mark -
#pragma mark 上下滚动交互线

- (void)animationLine
{
    __block CGRect frame = _interactiveLine.frame;
    
    static BOOL flag = YES;
    
    if (flag)
    {
        frame.origin.y = kLineMinY;
        flag = NO;
        
        [UIView animateWithDuration:1.0 / 20 animations:^{
            
            frame.origin.y += 5;
            _interactiveLine.frame = frame;
            
        } completion:nil];
    }
    else
    {
        if (_interactiveLine.frame.origin.y >= kLineMinY)
        {
            if (_interactiveLine.frame.origin.y >= kLineMaxY - 12)
            {
                frame.origin.y = kLineMinY;
                _interactiveLine.frame = frame;
                
                flag = YES;
            }
            else
            {
                [UIView animateWithDuration:1.0 / 20 animations:^{
                    
                    frame.origin.y += 5;
                    _interactiveLine.frame = frame;
                    
                } completion:nil];
            }
        }
        else
        {
            flag = !flag;
        }
    }
    
    //NSLog(@"_line.frame.origin.y==%f",_line.frame.origin.y);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
