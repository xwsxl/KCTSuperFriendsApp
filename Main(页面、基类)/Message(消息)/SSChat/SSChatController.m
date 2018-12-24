//
//  SSChatController.m
//  SSChatView
//
//  Created by soldoros on 2018/9/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

//if (IOS7_And_Later) {
//    self.automaticallyAdjustsScrollViewInsets = NO;
//}

#import "SSChatController.h"
#import "SSChatKeyBoardInputView.h"
#import "SSAddImage.h"
#import "SSChatBaseCell.h"
#import "SSChatLocationController.h"
#import "SSImageGroupView.h"
#import "SSChatMapController.h"
#import "KCTModelManager.h"
#import "YYKit.h"


#import "SSChatImageCell.h"
#import "SSChatTextCell.h"
#import "SSChatVoiceCell.h"
#import "SSChatMapCell.h"
#import "SSChatVideoCell.h"
@interface SSChatController ()<SSChatKeyBoardInputViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SSChatBaseCellDelegate>

//承载表单的视图 视图原高度
@property (strong, nonatomic) UIView    *mBackView;
@property (assign, nonatomic) CGFloat   backViewH;

//表单
@property(nonatomic,strong)UITableView *mTableView;
@property(nonatomic,strong)NSMutableArray *datas;

//底部输入框 携带表情视图和多功能视图
@property(nonatomic,strong)SSChatKeyBoardInputView *mInputView;

//访问相册 摄像头
@property(nonatomic,strong)SSAddImage *mAddImage;

/* ****  <#description#>  **** */
@property (nonatomic, strong) RLMNotificationToken *RLMNotificationToken;

@end

@implementation SSChatController

-(instancetype)init{
    if(self = [super init]){
        _chatType = SSChatConversationTypeChat;
        _datas = [NSMutableArray new];
    }
    return self;
}

//不采用系统的旋转
- (BOOL)shouldAutorotate{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str= (self.model.type==1)?_model.group.groupName:_model.contact.aliasName;
    self.navigationItem.title = str;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mInputView = [SSChatKeyBoardInputView new];
    _mInputView.delegate = self;
    [self.view addSubview:_mInputView];
    
    _backViewH = SCREEN_Height-SSChatKeyBoardInputViewH-SafeAreaTop_Height-SafeAreaBottom_Height;
    
    _mBackView = [UIView new];
    _mBackView.frame = CGRectMake(0, SafeAreaTop_Height, SCREEN_Width, _backViewH);
    _mBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mBackView];
    
    _mTableView = [[UITableView alloc]initWithFrame:_mBackView.bounds style:UITableViewStylePlain];
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    _mTableView.backgroundColor = SSChatCellColor;
    _mTableView.backgroundView.backgroundColor = SSChatCellColor;
    
    [_mBackView addSubview:self.mTableView];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    _mTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _mTableView.scrollIndicatorInsets = _mTableView.contentInset;
    if (@available(iOS 11.0, *)){
        _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
    }
    
    [self.mTableView registerClass:[SSChatTextCell class] forCellReuseIdentifier:SSChatTextCellId];
    [self.mTableView registerClass:[SSChatImageCell class] forCellReuseIdentifier:SSChatImageCellId];
    [self.mTableView registerClass:[SSChatVoiceCell class] forCellReuseIdentifier:SSChatVoiceCellId];
    [self.mTableView registerClass:[SSChatMapCell class] forCellReuseIdentifier:SSChatMapCellId];
    [self.mTableView registerClass:[SSChatVideoCell class] forCellReuseIdentifier:SSChatVideoCellId];
    
    [self getData];
    
}

/* ****  初始化数据  **** */
-(void)getData
{
    
    RLMResults *roomrs=[RoomRLMModel objectsWhere:[NSString stringWithFormat:@"roomNo contains '%@'",_model.roomNo]];
    RoomRLMModel *room=roomrs.lastObject;
    NSInteger count=[[UIApplication sharedApplication] applicationIconBadgeNumber];
    count=count-room.unreadNum;
    if (count<0) {
        count=0;
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
    if (room.unreadNum!=0) {
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            room.unreadNum=0;
        }];
    }
    
    if (roomrs.count>0) {
        [KUserDefaults removeObjectForKey:room.roomNo];
    }
    RLMResults *rs=[MessageRLMModel objectsWhere:[NSString stringWithFormat:@"roomNo contains '%@'",_model.roomNo]];
    rs=[rs sortedResultsUsingKeyPath:@"timeStamp" ascending:YES];
    WeakSelf
    self.RLMNotificationToken= [rs addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        XLLog(@"收到通知了");
        
        if (change!=nil) {
            
            [weakSelf.datas removeAllObjects];
            for (MessageRLMModel *model in results) {
                [weakSelf.datas addObject:[SSChatDatas receiveMessage:model]];
            }
           

            dispatch_async(dispatch_get_main_queue(), ^{
             //   XLLogSize(weakSelf.mTableView.contentSize);
                [weakSelf.mTableView reloadData];
                [weakSelf MTableScrollTobottomWithAnimate:YES];
            });
            
        }
        
       
        
        
    }];
    XLLog(@"%@",rs);
    for (MessageRLMModel *model in rs) {
          [_datas addObject:[SSChatDatas receiveMessage:model]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        XLLogSize(self.mTableView.contentSize);
        [self MTableScrollTobottomWithAnimate:NO];
    });

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _datas.count==0?0:1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _datas.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [(SSChatMessagelLayout *)_datas[indexPath.row] cellHeight];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SSChatMessagelLayout *layout = _datas[indexPath.row];
    SSChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:layout.message.cellString];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.layout = layout;
    return cell;
    
}


//视图归位
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_mInputView SetSSChatKeyBoardInputViewEndEditing];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_mInputView SetSSChatKeyBoardInputViewEndEditing];
}


#pragma SSChatKeyBoardInputViewDelegate 底部输入框代理回调
//点击按钮视图frame发生变化 调整当前列表frame
-(void)SSChatKeyBoardInputViewHeight:(CGFloat)keyBoardHeight changeTime:(CGFloat)changeTime{
 
    CGFloat height = _backViewH - keyBoardHeight;
    [UIView animateWithDuration:changeTime animations:^{
        self.mBackView.frame = CGRectMake(0, SafeAreaTop_Height, SCREEN_Width, height);
        self.mTableView.frame = self.mBackView.bounds;
        [self MTableScrollTobottomWithAnimate:YES];
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)MTableScrollTobottomWithAnimate:(BOOL)animated
{
    if (_datas.count>0) {
        NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:self.datas.count-1 inSection:0];
        [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

//发送文本 列表滚动至底部
-(void)SSChatKeyBoardInputViewBtnClick:(NSString *)string{
    
    NSDictionary *dic = @{@"text":string};
    [self sendMessage:dic messageType:SSChatMessageTypeText];
}


//发送语音
-(void)SSChatKeyBoardInputViewBtnClick:(SSChatKeyBoardInputView *)view sendVoice:(NSString *)path time:(NSInteger)second{

    [KCNetWorkManager QNUploadFile:path Withkey:path.lastPathComponent ForSuccess:^(QNResponseInfo * _Nonnull info, NSString * _Nonnull key, NSDictionary * _Nonnull resp) {
        NSDictionary *dic = @{@"text":resp[@"key"],
                              @"duration":@(second)};
        [self sendMessage:dic messageType:SSChatMessageTypeVoice];
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
    
   
}


//多功能视图点击回调  图片10  视频11  位置12
-(void)SSChatKeyBoardInputViewBtnClickFunction:(NSInteger)index{
    
    if(index==10){
        if(!_mAddImage) _mAddImage = [[SSAddImage alloc]init];

        [_mAddImage pickerWithController:self wayStyle:SSImagePickerWayFormIpc modelType:SSImagePickerModelAll pickerBlock:^(SSImagePickerWayStyle wayStyle, SSImagePickerModelType modelType, id object) {
            NSString *path=object;
            if (modelType==SSImagePickerModelImage) {
                [KCNetWorkManager QNUploadFile:path Withkey:path.lastPathComponent ForSuccess:^(QNResponseInfo * _Nonnull info, NSString * _Nonnull key, NSDictionary * _Nonnull resp) {
                    [self sendMessage:@{@"text":resp[@"key"]} messageType:SSChatMessageTypeImage];
                } AndFaild:^(NSError * _Nonnull error) {
                    XLLog(@"上传失败");
                }];
            }else if (modelType==SSImagePickerModelVideo)
            {
                [KCNetWorkManager QNUploadFile:path Withkey:path.lastPathComponent ForSuccess:^(QNResponseInfo * _Nonnull info, NSString * _Nonnull key, NSDictionary * _Nonnull resp) {
                    [self sendMessage:@{@"text":resp[@"key"]} messageType:SSChatMessageTypeVideo];
                } AndFaild:^(NSError * _Nonnull error) {
                    XLLog(@"上传失败");
                }];
            }
        }];
    }else if (index==11)
    {
        if(!_mAddImage) _mAddImage = [[SSAddImage alloc]init];
        [_mAddImage pickerWithController:self wayStyle:SSImagePickerWayCamer modelType:SSImagePickerModelAll pickerBlock:^(SSImagePickerWayStyle wayStyle, SSImagePickerModelType modelType, id object) {
            NSString *path=object;
            if (modelType==SSImagePickerModelImage) {
                [KCNetWorkManager QNUploadFile:path Withkey:path.lastPathComponent ForSuccess:^(QNResponseInfo * _Nonnull info, NSString * _Nonnull key, NSDictionary * _Nonnull resp) {
                    [self sendMessage:@{@"text":resp[@"key"]} messageType:SSChatMessageTypeImage];
                } AndFaild:^(NSError * _Nonnull error) {
                    XLLog(@"上传失败");
                }];
            }else if (modelType==SSImagePickerModelVideo)
            {
                [KCNetWorkManager QNUploadFile:path Withkey:path.lastPathComponent ForSuccess:^(QNResponseInfo * _Nonnull info, NSString * _Nonnull key, NSDictionary * _Nonnull resp) {
                    [self sendMessage:@{@"text":resp[@"key"]} messageType:SSChatMessageTypeVideo];
                } AndFaild:^(NSError * _Nonnull error) {
                    XLLog(@"上传失败");
                }];
            }
        }];
    }else if(index==14){
        SSChatLocationController *vc = [SSChatLocationController new];
        
        vc.locationBlock = ^(NSDictionary *locationDic, NSError *error) {
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//发送消息
-(void)sendMessage:(NSDictionary *)dic messageType:(SSChatMessageType)messageType{

    [SSChatDatas sendMessage:dic roomModel:_model messageType:messageType messageBlock:^(SSChatMessagelLayout *layout, NSError *error, NSProgress *progress) {
        
        [self.datas addObject:layout];
        [self.mTableView reloadData];
        [self MTableScrollTobottomWithAnimate:YES];
        
    }];
}


#pragma SSChatBaseCellDelegate 点击图片 点击短视频
-(void)SSChatImageVideoCellClick:(NSIndexPath *)indexPath layout:(SSChatMessagelLayout *)layout{
    
    NSInteger currentIndex = 0;
    NSMutableArray *groupItems = [NSMutableArray new];
    
    for(int i=0;i<self.datas.count;++i){
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        SSChatBaseCell *cell = [_mTableView cellForRowAtIndexPath:ip];
        SSChatMessagelLayout *mLayout = self.datas[i];
        
        SSImageGroupItem *item = [SSImageGroupItem new];
        if(mLayout.message.messageType == SSChatMessageTypeImage){
            item.imageType = SSImageGroupImage;
            item.fromImgView = cell.mImgView;
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            NSString* key = [manager cacheKeyForURL:KNSPHOTOURL(mLayout.message.textString)];
            SDImageCache* cache = [SDImageCache sharedImageCache];
            //此方法会先从memory中取。
            item.fromImage = [cache imageFromDiskCacheForKey:key];
        }
        else if (mLayout.message.messageType == SSChatMessageTypeVideo){
            item.imageType = SSImageGroupVideo;
            item.videoPath = mLayout.message.textString;
            item.fromImgView = cell.mImgView;
            item.fromImage = mLayout.message.videoImage;
        }
        else continue;
        
        item.contentMode = mLayout.message.contentMode;
        item.itemTag = groupItems.count + 10;
        if([mLayout isEqual:layout])currentIndex = groupItems.count;
        [groupItems addObject:item];
        
    }
    
    SSImageGroupView *imageGroupView = [[SSImageGroupView alloc]initWithGroupItems:groupItems currentIndex:currentIndex];
    [self.navigationController.view addSubview:imageGroupView];
    
    __block SSImageGroupView *blockView = imageGroupView;
    blockView.dismissBlock = ^{
        [blockView removeFromSuperview];
        blockView = nil;
    };
    
    [self.mInputView SetSSChatKeyBoardInputViewEndEditing];
}

#pragma SSChatBaseCellDelegate 点击定位
-(void)SSChatMapCellClick:(NSIndexPath *)indexPath layout:(SSChatMessagelLayout *)layout{
    
    SSChatMapController *vc = [SSChatMapController new];
    vc.latitude = layout.message.latitude;
    vc.longitude = layout.message.longitude;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //TODO: 页面appear 禁用
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //TODO: 页面Disappear 启用
    [[IQKeyboardManager sharedManager] setEnable:YES];
    self.navigationController.navigationBar.translucent=YES;
}

@end
