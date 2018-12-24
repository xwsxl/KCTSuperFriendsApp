//
//  SWQRCodeViewController.m
//  SWQRCode_Objc
//
//  Created by zhuku on 2018/4/4.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SWQRCodeViewController.h"
#import "SWScannerView.h"
#import "KCBaseTabbarVC.h"
#import "KCTContactDetailInfoVC.h"
#import "KCProfileInfoModel.h"

@interface SWQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/** 扫描器 */
@property (nonatomic, strong) SWScannerView *scannerView;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) NSTimer *timer2;

@end

@implementation SWQRCodeViewController

- (void)dealloc {
    [self invailt];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (SWScannerView *)scannerView
{
    if (!_scannerView) {
        if (_codeConfig) {
            _codeConfig=[[SWQRCodeConfig alloc] init];
            _codeConfig.scannerType=SWScannerTypeBoth;
        }
        _scannerView = [[SWScannerView alloc]initWithFrame:self.view.bounds config:_codeConfig];;
    }
    return _scannerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [SWQRCodeManager sw_navigationItemTitleWithType:self.codeConfig.scannerType];
    [self _setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resumeScanning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.scannerView sw_setFlashlightOn:NO];
    [self.scannerView sw_hideFlashlightWithAnimated:YES];
}

- (void)_setupUI {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    


    
    [self.view addSubview:self.scannerView];
    XLNaviView *navi=[[XLNaviView alloc] initWithMessage:@"扫描二维码" ImageName:@""];
    __weak typeof(self) weakself=self;
    navi.qurtBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:navi];
    self.title=@"扫描二维码";
    UIBarButtonItem *albumItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(showAlbum)];
    [albumItem setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = albumItem;
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setTitle:@"相册" forState:UIControlStateNormal];
    [but.titleLabel setFont:AppointTextFontSecond];
    [but setFrame:CGRectMake(KScreen_Width-50, KSafeTopHeight+28, 40, 20)];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [navi addSubview:but];
    [but addTarget:self action:@selector(showAlbum) forControlEvents:UIControlEventTouchUpInside];
    // 校验相机权限
    [SWQRCodeManager sw_checkCameraAuthorizationStatusWithGrand:^(BOOL granted) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _setupScanner];
            });
        }
    }];
}

/** 创建扫描器 */
- (void)_setupScanner {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if (self.codeConfig.scannerArea == SWScannerAreaDefault) {
        metadataOutput.rectOfInterest = CGRectMake([self.scannerView scanner_y]/self.view.frame.size.height, [self.scannerView scanner_x]/self.view.frame.size.width, [self.scannerView scanner_width]/self.view.frame.size.height, [self.scannerView scanner_width]/self.view.frame.size.width);
    }
    
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:deviceInput]) {
        [self.session addInput:deviceInput];
    }
    if ([self.session canAddOutput:metadataOutput]) {
        [self.session addOutput:metadataOutput];
    }
    if ([self.session canAddOutput:videoDataOutput]) {
        [self.session addOutput:videoDataOutput];
    }
    
    metadataOutput.metadataObjectTypes = [SWQRCodeManager sw_metadataObjectTypesWithType:self.codeConfig.scannerType];
    
    AVCaptureVideoPreviewLayer *videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    videoPreviewLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:videoPreviewLayer atIndex:0];
    
    [self.session startRunning];
}

#pragma mark -- 跳转相册
- (void)imagePicker {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    // 获取扫一扫结果
    if (metadataObjects && metadataObjects.count > 0) {
        
        [self pauseScanning];
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        NSString *stringValue = metadataObject.stringValue;
        
        [self sw_handleWithValue:stringValue];
    }
}

#pragma mark -- AVCaptureVideoDataOutputSampleBufferDelegate
/** 此方法会实时监听亮度值 */
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    
    // 亮度值
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    if (![self.scannerView sw_flashlightOn]) {
        if (brightnessValue < -4.0) {
            [self.scannerView sw_showFlashlightWithAnimated:YES];
        }else
        {
            [self.scannerView sw_hideFlashlightWithAnimated:YES];
        }
    }
}

- (void)showAlbum {
    // 校验相册权限
    [SWQRCodeManager sw_checkAlbumAuthorizationStatusWithGrand:^(BOOL granted) {
        if (granted) {
            [self imagePicker];
        }
    }];
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    // 获取选择图片中识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithData:UIImagePNGRepresentation(pickImage)]];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (features.count > 0) {
            CIQRCodeFeature *feature = features[0];
            NSString *stringValue = feature.messageString;
            [self sw_handleWithValue:stringValue];
        }
        else {
            [self sw_didReadFromAlbumFailed];
        }
    }];
}

#pragma mark -- App 从后台进入前台
- (void)appDidBecomeActive:(NSNotification *)notify {
    [self resumeScanning];
}

#pragma mark -- App 从前台进入后台
- (void)appWillResignActive:(NSNotification *)notify {
    [self pauseScanning];
}

/** 恢复扫一扫功能 */
- (void)resumeScanning {
    if (self.session) {
        [self.session startRunning];
        [self.scannerView sw_addScannerLineAnimation];
    }
}


/** 暂停扫一扫功能 */
- (void)pauseScanning {
    if (self.session) {
        [self.session stopRunning];
        [self.scannerView sw_pauseScannerLineAnimation];
    }
}

#pragma mark -- 扫一扫API
/**
 处理扫一扫结果
 @param value 扫描结果
 */
- (void)sw_handleWithValue:(NSString *)value {
    XLLog(@"sw_handleWithValue === %@", value);
    NSString *scanString=value;
    WeakSelf;
    if (scanString.length>0) {
        NSString *paramsStr=@"";
        if (self.scanOptions==KCScanOptionsHelpLogin) {
            /* ****  协助手表登录  **** */
            //  http://flytalk.flypaas.com/scan/watchlogin={param}
            if ([scanString containsString:@"watchlogin="]) {
                paramsStr=[scanString componentsSeparatedByString:@"watchlogin="].lastObject;
                [KCNetWorkManager POST:KNSSTR(@"/userController/scanLoginHelp")  WithParams:@{@"param":paramsStr} ForSuccess:^(NSDictionary * _Nonnull response) {
                    if ([response[@"code"] integerValue]==200) {
                        [MBProgressHUD showMessage:@"登录成功"];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                } AndFaild:^(NSError * _Nonnull error) {
                    
                }];
            }else if([scanString containsString:@"synthetical="])
            {
                //添加手表好友
                paramsStr=[scanString componentsSeparatedByString:@"synthetical="].lastObject;
                KCTContactDetailInfoVC *VC=[[KCTContactDetailInfoVC alloc] init];
                VC.code=paramsStr;
                VC.hidesBottomBarWhenPushed=YES;
                [weakSelf.navigationController pushViewController:VC animated:YES];
                XLLog(@"调接口去详情");
            }else if ([scanString containsString:@"account="])
            {
                //添加手机好友
                paramsStr=[scanString componentsSeparatedByString:@"account="].lastObject;
                KCTContactDetailInfoVC *VC=[[KCTContactDetailInfoVC alloc] init];
                VC.code=paramsStr;
                VC.hidesBottomBarWhenPushed=YES;
                [weakSelf.navigationController pushViewController:VC animated:YES];
                XLLog(@"调接口去详情");
            }
            
        }else if(self.scanOptions==KCScanOptionsLogin)
            
        {
            
            /* ****  手机扫码登录  **** */
            
            //    格式http://flytalk.flypaas.com/scan/synthetical={param}
            
            if ([scanString containsString:@"synthetical="]) {
                
                NSArray *tempArr=[scanString componentsSeparatedByString:@"synthetical="];
                
                paramsStr=tempArr.lastObject;
                
            }
            
            [KCNetWorkManager POST:KNSSTR(@"userController/scanLogin") WithParams:@{@"param":paramsStr} ForSuccess:^(NSDictionary * _Nonnull response) {
                
                
                if ([response[@"code"] intValue]==200) {
                    
                    
                    
                    if (@available(iOS 10.0, *)) {
                        weakSelf.timer2 =[NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                            [weakSelf getCommitDataWithString:response[@"data"]];
                        }];
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    
                }
                
            } AndFaild:^(NSError * _Nonnull error) {
                
            }];
        }
    }
}
-(void)getCommitDataWithString:(NSString *)code
{
    [KCNetWorkManager POST:KNSSTR(@"/userController/watchCodeLogin") WithParams:@{@"param":code} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            [self invailt];
            KCProfileInfoModel *model=[KCProfileInfoModel new];
            [model mj_setKeyValues:response[@"data"]];
            XLLog(@"model=%@",model);
            [KCUserDefaultManager setLoginStatus:YES];
            [KCUserDefaultManager setInfoModel:model];
            KCBaseTabbarVC *TabbarVC=[[KCBaseTabbarVC alloc] init];
            self.view.window.rootViewController=TabbarVC;
            
        }else if ([response[@"code"] integerValue]==202)
        {
            [self invailt];
            [MBProgressHUD showMessage:@"拒绝登录"];
        }
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}
/**
 相册选取图片无法读取数据
 */
- (void)sw_didReadFromAlbumFailed {
    XLLog(@"sw_didReadFromAlbumFailed");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)invailt
{
    if (self.timer2) {
        [self.timer2 invalidate];
        self.timer2=nil;
    }
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
