//
//  KCRadarAddFriendsVC.m
//  SuperFriendsApp
//
//  Created by KCMac on 2018/12/5.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCRadarAddFriendsVC.h"
#import <CoreLocation/CoreLocation.h>
#import "XHRadarView.h"
@interface KCRadarAddFriendsVC ()<CLLocationManagerDelegate,XHRadarViewDataSource, XHRadarViewDelegate>
{
   // coordinate.latitude,coordinate.longitude
    double _latitude;//经度
    double _longitude;//纬度
}
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray *pointsArray;

@property (nonatomic, strong) XHRadarView *radarView;
@end

@implementation KCRadarAddFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(qurtButClick)];
    self.navigationItem.leftBarButtonItem =leftBar;
    XHRadarView *radarView = [[XHRadarView alloc] initWithFrame:self.view.bounds];
    radarView.dataSource = self;
    radarView.delegate = self;
    radarView.radius = 200;
    radarView.backgroundColor = [UIColor colorWithRed:0.251 green:0.329 blue:0.490 alpha:1];
    radarView.backgroundImage = [UIImage imageNamed:@"radar_background"];
   // radarView.labelText = @"正在搜索附近的目标";
    [self.view addSubview:radarView];
    _radarView = radarView;
    
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-39, self.view.center.y-39, 78, 78)];
    avatarView.layer.cornerRadius = 39;
    avatarView.layer.masksToBounds = YES;
    
    [avatarView setImage:[UIImage imageNamed:@"avatar"]];
    [_radarView addSubview:avatarView];
    [_radarView bringSubviewToFront:avatarView];
    
    //目标点位置
    _pointsArray = @[
                     @[@6, @90],
                     @[@-140, @108],
                     @[@-83, @98],
                     @[@-25, @142],
                     @[@60, @111],
                     @[@-111, @96],
                     @[@150, @145],
                     @[@25, @144],
                     @[@-55, @110],
                     @[@95, @109],
                     @[@170, @180],
                     @[@125, @112],
                     @[@-150, @145],
                     @[@-7, @160],
                     ];
    
    [self.radarView scan];
    [self startUpdatingRadar];
    
    self.locationManager=[[CLLocationManager alloc] init];
    // 设置定位精度，十米，百米，最好
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //每隔多少米定位一次（这里的设置为任何的移动）
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.delegate = self; //代理设置
    // 开始时时定位
    if ([CLLocationManager locationServicesEnabled])
    {
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        [self.locationManager startUpdatingLocation];
    }else
    {
        XLLog(@"请开启定位功能");
    }
    if (!_timer) {
        self.timer=[NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(timerChange) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
       // [[NSRunLoop currentRunLoop] run];
    }
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void)startUpdatingRadar {
    typeof(self) __weak weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      //  weakSelf.radarView.labelText = [NSString stringWithFormat:@"搜索已完成，共找到%lu个目标", (unsigned long)weakSelf.pointsArray.count];
        [weakSelf.radarView show];
    });
}

#pragma mark - XHRadarViewDataSource
- (NSInteger)numberOfSectionsInRadarView:(XHRadarView *)radarView {
    return 4;
}
- (NSInteger)numberOfPointsInRadarView:(XHRadarView *)radarView {
    return [self.pointsArray count];
}
- (UIView *)radarView:(XHRadarView *)radarView viewForIndex:(NSUInteger)index {
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 25)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [imageView setImage:[UIImage imageNamed:@"point"]];
    [pointView addSubview:imageView];
    return pointView;
}
- (CGPoint)radarView:(XHRadarView *)radarView positionForIndex:(NSUInteger)index {
    NSArray *point = [self.pointsArray objectAtIndex:index];
    return CGPointMake([point[0] floatValue], [point[1] floatValue]);
}

#pragma mark - XHRadarViewDelegate

- (void)radarView:(XHRadarView *)radarView didSelectItemAtIndex:(NSUInteger)index {
    XLLog(@"didSelectItemAtIndex:%lu", (unsigned long)index);
    
}

#pragma mark - events
/* ****  定时器时间改变  **** */
-(void)timerChange
{
    if (_longitude&&_latitude) {
        
        [KCNetWorkManager POST:KNSSTR(@"/nearbyPeopleController/queryRadiusByMember") WithParams:@{@"longitude":[NSNumber numberWithDouble:_longitude],@"latitude":[NSNumber numberWithDouble:_latitude]} ForSuccess:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue]==200) {
                for (NSDictionary *dic in response[@"data"]) {
                    ContactRLMModel *model=[[ContactRLMModel alloc] init];
                    [model mj_setKeyValues:dic];
                }
            }
        } AndFaild:^(NSError * _Nonnull error) {
            
        }];
    }
    
}

#pragma mark - location delegate
//开启定位后会先调用此方法，判断有没有权限
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
    {
        //判断ios8 权限
        
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            
        {
            
            [self.locationManager requestAlwaysAuthorization]; // 永久授权
            
            [self.locationManager requestWhenInUseAuthorization]; //使用中授权
            
        }
        
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [self.locationManager startUpdatingLocation];
    }
}

/* 定位完成后 回调 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *location = [locations lastObject];
    
    CLLocationCoordinate2D coordinate = location.coordinate;
    //  经纬度
    XLLog(@"---x:%f---y:%f",coordinate.latitude,coordinate.longitude);
    _latitude=coordinate.latitude;
    _longitude=coordinate.longitude;
  //  [self.locationManager stopUpdatingLocation];   //停止定位
}

// 定位失败错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    XLLog(@"error");
}




#pragma mark - dealloc

-(void)dealloc
{
    [self XLinvaild];
}

-(void)XLinvaild
{
    if (_timer) {
         [_timer invalidate];
        _timer=nil;
    }
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
//离开页面时还原为全局设置：橙色
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self XLinvaild];
}

@end
