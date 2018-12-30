//
//  KCSetVoicePasswordVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/6.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCSetVoicePasswordVC.h"

#import "KCFirstVoicePasswordSettedVC.h"
#import "KCSetVoicePasswordCompletedVC.h"
#import "KCBaseTabbarVC.h"

#import <AVFoundation/AVFoundation.h>

#define BUTWIDTH 78
#define SPACE (KScreen_Width-78)/2
@interface KCSetVoicePasswordVC ()<AVAudioRecorderDelegate,NSURLConnectionDelegate,AVSpeechSynthesizerDelegate>
{
    AVSpeechSynthesizer *_synthesizer;
}

@property (nonatomic, strong) NSString *urlPlay;

@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, strong) NSMutableData  *receiveData;

@property (nonatomic, strong) UIImageView *voiceIV;

@property (nonatomic, copy) NSString *numberStr;

@property (nonatomic, strong) NSTimer *rippleTimer;

@end

@implementation KCSetVoicePasswordVC


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
 * 设置子视图
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
    
//    if (_isReset) {
//        [but setHidden:YES];
//    }
    
    UILabel *titleLab=[[UILabel alloc] init];
    titleLab.frame=CGRectMake(0, KSafeTopHeight+CHeight(149), KScreen_Width, 18);
    titleLab.font=AppointTextFontSecond;
    titleLab.textColor=APPOINTCOLORSecond;
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.text=@"请匀速读出数字";
    [self.view addSubview:titleLab];
    
    UILabel *plzSelectGender=[[UILabel alloc] init];
    plzSelectGender.frame=CGRectMake(0, KSafeTopHeight+CHeight(169)+18, KScreen_Width, 20);
    plzSelectGender.textColor=APPOINTCOLORThird;
    plzSelectGender.font=AppointTextFontFirst;
    plzSelectGender.textAlignment=NSTextAlignmentCenter;
    plzSelectGender.text=self.numberStr;
    [self.view addSubview:plzSelectGender];
    
    CGFloat butwidth=78;
    CGFloat space=(KScreen_Width-78)/2;

    self.voiceIV=[[UIImageView alloc] init];
    _voiceIV.tag=100;
    [_voiceIV setFrame:CGRectMake(space, KSafeTopHeight+CHeight(542), butwidth, butwidth)];
    [_voiceIV setImage:KImage(@"KCLogin-miscro")];
    [self.view addSubview:_voiceIV];
    if ([[[UIDevice currentDevice]systemVersion]integerValue]>=7.0) {
        NSString *broadCastStr = @"深圳快传技术有限公司";
        if (self.voiceOptions==0) {
            broadCastStr=@"请朗读账号";
        }else if (self.voiceOptions==1)
        {
            broadCastStr=@"请再朗读一遍";
        }else
        {
            broadCastStr=@"请朗读账号";
        }
        
        [self voiceBroadCastStr:broadCastStr];
    }
}
-(void)voiceBroadCastStr:(NSString *)content
{
    [self setAudioWaiFangSession];
    //初始化语音播报，控制播放、暂停
    _synthesizer = [[AVSpeechSynthesizer alloc]init];
    //语音对象，说中文（zh_CN），英文(en-US)
    AVSpeechSynthesisVoice *voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh_CN"];
    // 实例化发声的对象，及朗读的内容
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:content];
    //指定语音类型
    utterance.voice = voiceType;
    utterance.rate = 0.4;
    utterance.volume = 1.0;
    _synthesizer.delegate = self;//注意：代理方法写在启动前
    [_synthesizer speakUtterance:utterance];//启动
}
#pragma mark - network

#pragma mark - events

#pragma mark - reuse
/* ****  处理声音  **** */
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
        NSString *token=[KUserDefaults objectForKey:@"BDAccess_token"];
        self.urlPlay=[KCFileManager getAndCreatePlayableFileFromPcmData:self.urlPlay];
        NSData *voiceData=[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.urlPlay]];
        NSDictionary *params2=@{@"cuid":KDeviceID,@"token":token,@"dev_pid":@"1536"};
        
        [KCNetWorkManager POSTBDVoice:@"" WithParams:params2 voiceData:voiceData ForSuccess:^(NSDictionary * _Nonnull response) {
                NSArray *array=response[@"result"];
                NSString *str=[array objectAtIndex:0];
                BOOL equal=[str containsString:self.numberStr];
                if (equal) {
                    [self jumpToNextVC];
                }
               // [KCFileManager removeFileFromPath:self.urlPlay];
            
        } AndFaild:^(NSError * _Nonnull error) {
           // [KCFileManager removeFileFromPath:self.urlPlay];
        }];
        
    }
    [self.recorder stop];
    
    self.recorder=nil;
    
}
/* ****  声纹识别通过跳转下一界面  **** */
-(void)jumpToNextVC
{
    
    
    if (self.voiceOptions==0) {
        
        /* ****  第一次设置声纹密吗  **** */
        KCFirstVoicePasswordSettedVC *VC=[[KCFirstVoicePasswordSettedVC alloc] init];
        [KCFileManager saveVoicePasswordPath:self.urlPlay];
        VC.isReset=_isReset;
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if(self.voiceOptions ==1)
    {
        /* ****  第二次重复声纹密码 调注册接口  **** */
        NSString *path1=self.urlPlay;
        NSString *path2=[KCFileManager getVoicePasswordPath];
        NSString *urlStr=KNSSTR(@"userController/registerApp");
        NSDictionary *params=@{@"sex":[KUserDefaults stringForKey:@"tempsex"]};
        if (_isReset) {
            urlStr=KNSSTR(@"/userInfoController/replaceSpeakinPwd");
            params=@{@"account":[KCUserDefaultManager getAccount]};
        }
        
        
        [KCNetWorkManager POSTFile:urlStr WithParams:params AndView:self.view constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *data1=[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path1]];
            NSData *data2=[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path2]];
            NSMutableData *mdata=[NSMutableData data];
            [mdata appendData:data1];
            [mdata appendData:data2];
            [formData appendPartWithFileData:data1 name:@"file1" fileName:@"file1" mimeType:@"application/octet-stream"];
            [formData appendPartWithFileData:data2 name:@"file2" fileName:@"file2" mimeType:@"application/octet-stream"];
//            [formData appendPartWithFileData:mdata name:@"files" fileName:@"files" mimeType:@"application/octet-stream"];
        } ForSuccess:^(NSDictionary * _Nonnull response) {
            
            if ([response[@"code"] integerValue]==200) {
               if([urlStr isEqualToString:KNSSTR(@"userController/registerApp")])
               {
                   [KCUserDefaultManager setAccount:response[@"data"]];
               }
                KCSetVoicePasswordCompletedVC *VC=[[KCSetVoicePasswordCompletedVC alloc] init];
                VC.voiceStatusOption=0;
                VC.isReset=self.isReset;
                [self.navigationController pushViewController:VC animated:YES];
            }
            [KCFileManager removeFileFromPath:path1];
            [KCFileManager removeFileFromPath:path2];
        } AndFaild:^(NSError * _Nonnull error) {
            [KCFileManager removeFileFromPath:path1];
            [KCFileManager removeFileFromPath:path2];
        }];
        
    }else
    {
        NSDictionary *params=@{@"account":[KCUserDefaultManager getAccount]};
        [KCNetWorkManager POSTFile:KNSSTR(@"/userController/loginOfAppAudio") WithParams:params AndView:self.view constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
        [_synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
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
        //录音的质量 - 逆天邪神 拖更火星 -
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

/* ****  页面种类  **** */
-(KCSetVoiceOptions)voiceOptions
{
    if (!_voiceOptions) {
        _voiceOptions=0;
    }
    return _voiceOptions;
}

/* ****  数字字符串  **** */
-(NSString *)numberStr
{
    if (!_numberStr) {
        _numberStr=[NSString randomNumString];
    }
    return _numberStr;
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

//听筒模式
-(void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}
//扬声器模式
-(void)setAudioWaiFangSession
{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
}
@end
