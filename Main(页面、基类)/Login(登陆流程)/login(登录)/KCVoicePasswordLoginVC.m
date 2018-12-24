//
//  KCVoicePasswordLoginVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/7.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCVoicePasswordLoginVC.h"
#import "SWQRCodeViewController.h"

#import "KCBaseTabbarVC.h"

#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>

#define BUTWIDTH 78
#define SPACE (KScreen_Width-78)/2

@interface KCVoicePasswordLoginVC ()<AVAudioRecorderDelegate,NSURLConnectionDelegate>

@property (nonatomic, strong) NSString *urlPlay;

@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, strong) UIImageView *voiceIV;


@property (nonatomic, strong) NSTimer *rippleTimer;
@end

@implementation KCVoicePasswordLoginVC
#pragma mark - life cycle
/*
 * <#description#>
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - setUI
/*
 * 布局子视图
 */
-(void)setSubViews
{
    [super setSubViews];
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(15, 42+KSafeTopHeight, 40,20)];
    [but setTitle:@"取消" forState:UIControlStateNormal];
    [but setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [but.titleLabel setFont:AppointTextFontSecond];
    [but addTarget:self action:@selector(qurtButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    UIButton *scanQRCodeLoginBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [scanQRCodeLoginBut setFrame:CGRectMake(KScreen_Width-57, KSafeTopHeight+15, 52, 52)];
    [scanQRCodeLoginBut setImage:KImage(@"KCLogin-扫码用户线索") forState:UIControlStateNormal];
    [scanQRCodeLoginBut addTarget:self action:@selector(scanQRCodeLoginButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanQRCodeLoginBut];
    
    CGFloat imgwidth=82;
    CGFloat topspace=24;
    CGFloat butwidth=78;
    
    UIImageView *headIV=[[UIImageView alloc] init];
    [headIV setFrame:CGRectMake((KScreen_Width-imgwidth)/2.0, KSafeAreaTopNaviHeight+10, imgwidth, imgwidth)];
    headIV.tag=100;
    [self.view addSubview:headIV];
    
    UILabel *accountLab=[[UILabel alloc] init];
    accountLab.tag=101;
    [accountLab setFont:AppointTextFontSecond];
    [accountLab setTextColor:APPOINTCOLORSecond];
    [accountLab setFrame:CGRectMake(0, KSafeAreaTopNaviHeight+10+imgwidth+topspace, KScreen_Width, 24)];
    [accountLab setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:accountLab];
    
    UILabel *titleLab=[[UILabel alloc] init];
    [titleLab setFont:AppointTextFontMain];
    [titleLab setTextColor:APPOINTCOLORSecond];
    [titleLab setFrame:CGRectMake(0, KSafeAreaTopNaviHeight+10+imgwidth+topspace*2+24, KScreen_Width, 24)];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"请匀速读出以下数字"];
    [self.view addSubview:titleLab];
    
    UILabel *numLab=[[UILabel alloc] init];
    [numLab setFont:AppointTextFontMain];
    [numLab setTextColor:APPOINTCOLORThird];
    [numLab setFrame:CGRectMake(0, KSafeAreaTopNaviHeight+10+imgwidth+topspace*3+24*3, KScreen_Width, 24)];
    [numLab setTextAlignment:NSTextAlignmentCenter];
    [numLab setText:[NSString randomNumString]];
    [self.view addSubview:numLab];
   
    self.voiceIV=[[UIImageView alloc] init];
    _voiceIV.tag=500;
    [_voiceIV setFrame:CGRectMake((KScreen_Width-butwidth)/2.0, KScreen_Height-KSafeAreaBottomHeight-CHeight(140), butwidth, butwidth)];
    [_voiceIV setImage:KImage(@"KCLogin-miscro")];
    [self.view addSubview:_voiceIV];
    
}

#pragma mark - network

#pragma mark - events
/*
 * 扫码登录
 */
-(void)scanQRCodeLoginButClick:(UIButton *)sender
{
    SWQRCodeViewController *VC=[[SWQRCodeViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    XLLog(@"");
}


-(void)dealWithRecorder
{
    [self closeRippleTimer];
    if (!_recorder) {
        return;
    }
    
    //获取当前录音时长
    float voiceSize = self.recorder.currentTime;
    
    XLLog(@"录音时长 = %f",voiceSize);
    
    if(voiceSize < 1){
        [self.recorder deleteRecording];
        [KCUIAlertTools showAlertWithTitle:@"" message:@"时长小于1秒，重新录制" cancelTitle:@"确认" alertStyle:UIAlertControllerStyleAlert titleArray:@[] viewController:self confirm:^(NSInteger buttonTag) {
            
        }];
    }else if (voiceSize > 60){
        
        [self.recorder deleteRecording];
        
        [KCUIAlertTools showAlertWithTitle:@"" message:@"时长大于1分钟，重新录制" cancelTitle:@"确认" alertStyle:UIAlertControllerStyleAlert titleArray:@[] viewController:self confirm:^(NSInteger buttonTag) {
            
        }];
    }else
    {
        self.urlPlay=[KCFileManager getAndCreatePlayableFileFromPcmData:self.urlPlay];
        [self goNext];
    }
    [self.recorder stop];
    
    self.recorder=nil;
}

/* ****  下一页面  **** */
-(void)goNext
{
    [KCNetWorkManager POSTFile:KNSSTR(@"/userController/loginOfAppAudio") WithParams:@{@"account":_datamodel.accountName} AndView:self.view constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data2=[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.urlPlay]];
        [formData appendPartWithFileData:data2 name:@"file" fileName:@"file" mimeType:@"application/octet-stream"];
    } ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            KCProfileInfoModel *model=[KCProfileInfoModel new];
            [model mj_setKeyValues:response[@"data"]];
            [KCUserDefaultManager setInfoModel:model];
            [KCUserDefaultManager setLoginStatus:YES];
            [KNotificationCenter postNotificationName:KCLoginInSuccessNoti object:nil];
            /* ****  验证声纹密码 调登录接口  **** */
            KCBaseTabbarVC *TabbarVC=[[KCBaseTabbarVC alloc] init];
            self.view.window.rootViewController=TabbarVC;
        }else
        {
            [MBProgressHUD showMessage:@"验证失败"];
        }
        [KCFileManager removeFileFromPath:self.urlPlay];
    } AndFaild:^(NSError * _Nonnull error) {
        [KCFileManager removeFileFromPath:self.urlPlay];
    }];
}
#pragma mark - delegate
/*
 * <#description#>
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    XLLog(@"touchBegan");
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self.view];
    BOOL isTouchIV= ((point.x>=SPACE)&&(point.x<=SPACE+BUTWIDTH))&&((point.y>=KSafeTopHeight+CHeight(542))&&(point.y<=(KSafeTopHeight+CHeight(542)+BUTWIDTH)));
    if (isTouchIV) {
        XLLog(@"100");
        AVAudioSession * session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [session setActive:YES error:nil];
        //录音设置
        NSMutableDictionary * recordSetting = [[NSMutableDictionary alloc]init];
        //设置录音格式
        [recordSetting  setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        //设置录音采样率（HZ）
        [recordSetting setValue:[NSNumber numberWithFloat:16000] forKey:AVSampleRateKey];
        //录音通道数
        [recordSetting setValue:[NSNumber  numberWithInt:1] forKey:AVNumberOfChannelsKey];
        //线性采样位数
        [recordSetting  setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        //        //录音的质量
        [recordSetting  setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
        //获取沙盒路径 作为存储录音文件的路径
        NSString * strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        XLLog(@"path = %@",strUrl);
        NSString *path=[NSString stringWithFormat:@"%@/%@voice.lpcm",strUrl,[NSString dateString]];
        //创建url
        NSURL * url = [NSURL fileURLWithPath:path];
        self.urlPlay = path;
        XLLog(@"path=%@",url);
        NSError * error ;
        //初始化AVAudioRecorder
        self.recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
        //开启音量监测
        self.recorder.meteringEnabled = YES;
        self.recorder.delegate = self;
        if(error){
            XLLog(@"创建录音对象时发生错误，错误信息：%@",error.localizedDescription);
        }
        if([_recorder prepareToRecord]){
            //开始
            [_recorder record];
            [self showWithRipple];
            XLLog(@"开始录音");
        }
    }else
    {
        [self dealWithRecorder];
        XLLog(@"101");
    }
}
/*
 * <#description#>
 */
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    XLLog(@"touchMoved");
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self.view];
    BOOL isTouchIV= ((point.x>=SPACE)&&(point.x<=SPACE+BUTWIDTH))&&((point.y>=KSafeTopHeight+CHeight(542))&&(point.y<=(KSafeTopHeight+CHeight(542)+BUTWIDTH)));
    if (isTouchIV) {
        XLLog(@"100");
    }else
    {
        [self dealWithRecorder];
    }
}
/*
 * <#description#>
 */
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dealWithRecorder];
    XLLog(@"101");
}

#pragma mark - lazy loading

-(void)setDatamodel:(KCProfileInfoModel *)datamodel
{
    _datamodel=datamodel;
    UIImageView *iv=[self.view viewWithTag:100];
    UILabel *lab=[self.view viewWithTag:101];
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",PhotoUrl,datamodel.headerIconStr];
    [iv sd_setImageWithURL:KNSURL(urlStr) placeholderImage:KImage(@"超级好友")];
    [lab setText:datamodel.nickName];
    
}

- (void)showWithRipple
{
    self.rippleTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(addRippleLayer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_rippleTimer forMode:NSRunLoopCommonModes];
}

- (CGRect)makeEndRect
{
    CGRect endRect = CGRectMake(_voiceIV.frame.origin.x, _voiceIV.frame.origin.y, 78, 78);
    endRect = CGRectInset(endRect, -50, -50);
    return endRect;
}

- (void)addRippleLayer
{
    CAShapeLayer *rippleLayer = [[CAShapeLayer alloc] init];
    rippleLayer.position = CGPointMake(200, 200);
    rippleLayer.bounds = CGRectMake(0, 0, 400, 400);
    rippleLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_voiceIV.frame.origin.x, _voiceIV.frame.origin.y, 78, 78)];
    rippleLayer.path = path.CGPath;
    rippleLayer.strokeColor = RGBHex(0x0087fd).CGColor;
    rippleLayer.lineWidth = 5;
    [rippleLayer setFillColor:[UIColor clearColor].CGColor];
    [self.view.layer insertSublayer:rippleLayer below:_voiceIV.layer];
    
    //addRippleAnimation
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_voiceIV.frame.origin.x, _voiceIV.frame.origin.y, 78, 78)];
    CGRect endRect = CGRectInset([self makeEndRect], -50, -50);
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    
    rippleLayer.path = endPath.CGPath;
    rippleLayer.opacity = 0.0;
    
    CABasicAnimation *rippleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    rippleAnimation.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    rippleAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    rippleAnimation.duration = 1.8;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.duration = 1.8;
    
    [rippleLayer addAnimation:opacityAnimation forKey:@""];
    [rippleLayer addAnimation:rippleAnimation forKey:@""];
    
    [self performSelector:@selector(removeRippleLayer:) withObject:rippleLayer afterDelay:1.8];
}

- (void)removeRippleLayer:(CAShapeLayer *)rippleLayer
{
    [rippleLayer removeFromSuperlayer];
    rippleLayer = nil;
}

- (void)closeRippleTimer
{
    if (_rippleTimer) {
        if ([_rippleTimer isValid]) {
            [_rippleTimer invalidate];
        }
        _rippleTimer = nil;
    }
}

@end
