//
//  KCMyQRCodeVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/23.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCMyQRCodeVC.h"
#import "UIImageView+WebCache.h"
@interface KCMyQRCodeVC ()
@property (nonatomic, strong) UIImage *qrCodeImage;
@end

@implementation KCMyQRCodeVC


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - setUI
/*
 * 设置界面
 */
-(void)setSubViews
{
    [super setSubViews];
//    [self.view setBackgroundColor:MAINSEPRATELINECOLOR];
//    XLNaviView *navi=[[XLNaviView alloc] initWithMessage:@"我的二维码" ImageName:@""];
//    __weak typeof(self) weakself=self;
//    navi.qurtBlock = ^{
//        [weakself qurtButClick];
//    };
//    [self.view addSubview:navi];
    
    self.navigationItem.title=@"我的二维码";
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake( CWidth(27), KSafeAreaTopNaviHeight+29, CWidth(321), CWidth(442))];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:contentView];
    
    UILabel *nameLab=[[UILabel alloc] initWithFrame:CGRectMake(30, 29, 120, 20)];
    [nameLab setFont:AppointTextFontMain];
    [nameLab setTextColor:APPOINTCOLORSecond];
    [nameLab setText:@"Name"];
    [contentView addSubview:nameLab];
    
    UIImageView *icon=[[UIImageView alloc] initWithFrame:CGRectMake(CWidth(321-25)-59, 8, 59, 59)];
    [icon.layer setCornerRadius:59/2.0];
    icon.clipsToBounds=YES;
    [icon sd_setImageWithURL:KNSURL(defaultIconUrl) placeholderImage:KImage(@"")];
    [contentView addSubview:icon];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 80, CWidth(321), 1)];
    [line setBackgroundColor:MAINSEPRATELINECOLOR];
    [contentView addSubview:line];

    UIImageView *qrcodeView=[[UIImageView alloc] initWithFrame:CGRectMake(CWidth(36), 117, CWidth(250), CWidth(250))];
    qrcodeView.tag=1000;
    
    
    [contentView addSubview:qrcodeView];

     
    
    
    UIView *bottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, CWidth(404), CWidth(321), 1)];
    [bottomLine setBackgroundColor:MAINSEPRATELINECOLOR];
    [contentView addSubview:bottomLine];
    
    UIButton *bottomBut=[UIButton buttonWithType:UIButtonTypeCustom];
    bottomBut.frame=CGRectMake(0, CWidth(405), CWidth(321), CWidth(38));
    [bottomBut setTitle:@"扫一扫加我吧!" forState:UIControlStateNormal];
    [bottomBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [bottomBut.titleLabel setFont:AppointTextFontFourth];
    [bottomBut setImage:KImage(@"KCMine-Scan-扫一扫") forState:UIControlStateNormal];
    [contentView addSubview:bottomBut];
    
    UIButton *saveToPhoneBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [saveToPhoneBut setFrame:CGRectMake(CWidth(26), CWidth(405+20+38)+KSafeAreaTopNaviHeight+29, (KScreen_Width-CWidth(60))/2.0, 45)];
    [saveToPhoneBut setBackgroundColor:[UIColor whiteColor]];
    [saveToPhoneBut setTitle:@"保存到手机" forState:UIControlStateNormal];
    [saveToPhoneBut.titleLabel setFont:AppointTextFontSecond];
    [saveToPhoneBut addTarget:self action:@selector(saveToPhoneButClick:) forControlEvents:UIControlEventTouchUpInside];
    [saveToPhoneBut setTitleColor:APPOINTCOLORSecond forState:UIControlStateNormal];
    [self.view addSubview:saveToPhoneBut];
    
    UIButton *shareBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBut setFrame:CGRectMake(CWidth(26)+CWidth(8)+(KScreen_Width-CWidth(60))/2.0, CWidth(405+20+38)+KSafeAreaTopNaviHeight+29, (KScreen_Width-CWidth(60))/2.0, 45)];
    [shareBut setBackgroundColor:APPOINTCOLORThird];
    [shareBut setTitle:@"分享" forState:UIControlStateNormal];
    [shareBut.titleLabel setFont:AppointTextFontSecond];
    [shareBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:shareBut];
    [self getData];
    
}
#pragma mark - network

-(void)getData
{
    UIImageView *IV=[self.view viewWithTag:1000];
    [KCNetWorkManager POST:KNSSTR(@"/userInfoController/getCountQrCode") WithParams:@{@"account":[KCUserDefaultManager getAccount]} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            
            self.qrCodeImage=[UIImage createQRCodeImageWithString:response[@"data"] andSize:CGSizeMake(CWidth(250), CWidth(250)) andBackColor:[UIColor whiteColor] andFrontColor:[UIColor blackColor] andCenterImage:KImage(@"")];
            [IV setImage:self.qrCodeImage];
        }
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - events
/*
 * 保存到手机
 */
-(void)saveToPhoneButClick:(UIButton *)sender
{
    
    XLLog(@"save photo");
    [self loadImageFinished:self.qrCodeImage];
    
}
#pragma mark - reuse
/*
 * 添加照片到系统相册
 */
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if (!error) {
        [KCUIAlertTools showAlertWithTitle:@"" message:@"添加成功" cancelTitle:@"确定" alertStyle:UIAlertControllerStyleAlert titleArray:@[] viewController:self confirm:^(NSInteger buttonTag) {
            
        }];
    }
    XLLog(@"image = %@, error = %@, contextInfo = %@", image, error.localizedDescription, contextInfo);
}
#pragma mark - delegate

#pragma mark - lazy loading


@end
