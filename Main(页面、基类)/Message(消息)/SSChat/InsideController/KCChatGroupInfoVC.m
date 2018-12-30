
//
//  KCChatGroupInfoVC.m
//  SuperFriendsApp
//
//  Created by KCMac on 2018/12/25.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCChatGroupInfoVC.h"
#import "SSChatController.h"
#import "KCTMessageCreatGroupVC.h"
#import "KCTNormalChangeInfoVC.h"
#import "UIImageView+WebCache.h"
#import "KCTAlertView.h"
@interface KCChatGroupInfoVC ()
{
    UIScrollView *_scroll;
}

/* ****  全部头像  **** */
@property (nonatomic, strong) UIView *allHeaderIconView;
/* ****  全部群聊信息  **** */
@property (nonatomic, strong) UIView *groupInfoView;
/* ****  数据源  **** */
@property (nonatomic, strong) NSMutableArray *dataSource;
/* ****  组数据模型  **** */
@property (nonatomic, copy) GroupRLMModel *model;

@end

@implementation KCChatGroupInfoVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"聊天信息";
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUI
-(void)setUpSubViews
{
    if (!_scroll)
    {
        _scroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width, KScreen_Height-KSafeAreaTopNaviHeight-KSafeAreaBottomHeight)];
        _scroll.backgroundColor=RGB(244, 244, 244);
        [self.view addSubview:_scroll];
    }
    CGFloat height=[self setAllHeaderIconView];
    
    XLLog(@"%.f",height);
    
    CGFloat heightH=[self setGroupInfoViewFromHeight:height+CHeight(10)];
    
    XLLog(@"%.f",heightH);
    
}
/* ****  设置头像  **** */
-(CGFloat)setAllHeaderIconView
{
    CGFloat height=0;
    
    if (!_allHeaderIconView) {
        _allHeaderIconView=[[UIView alloc] init];
        _allHeaderIconView.backgroundColor=[UIColor whiteColor];
    }else
    {
         [_allHeaderIconView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
   
    CGFloat topMarin=15.0;
    CGFloat Iwidth=KScreen_Width/8.0;
    CGFloat Iheight=Iwidth+8+12;
    
    CGFloat Imarin=(KScreen_Width-5*Iwidth)/6;
    NSInteger headerButCount;
    NSInteger account;
    if ([self.model.groupOwner isEqualToString:[KCUserDefaultManager getAccount]]) {
        account=2;
    }else
    {
        account=1;
    }
        headerButCount =self.dataSource.count+account;
    
    if (headerButCount>15) {
        headerButCount=15;
        self.allHeaderIconView.frame=CGRectMake(0, 0, KScreen_Width, (topMarin+Iheight)*3+topMarin+23+topMarin);
        UIButton *checkMoreGroupMemberBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [checkMoreGroupMemberBut setFrame:CGRectMake(0, (topMarin+Iheight)*3+topMarin, KScreen_Width, 23)];
        [checkMoreGroupMemberBut setTitle:@"查看更多群成员" forState:UIControlStateNormal];
        [checkMoreGroupMemberBut.titleLabel setFont:AppointTextFontThird];
        [self.allHeaderIconView addSubview:checkMoreGroupMemberBut];
        height=height+(topMarin+Iheight)*3+topMarin+23+topMarin;
    }else
    {
        self.allHeaderIconView.frame=CGRectMake(0, 0, KScreen_Width, (topMarin+Iheight)*((headerButCount-1)/5+1)+topMarin);
        height=height+(topMarin+Iheight)*(headerButCount/5+1)+topMarin;
    }
    
    for (int i=0; i<headerButCount; i++) {
        UIButton *headerBut=[UIButton buttonWithType:UIButtonTypeCustom];
        headerBut.layer.borderColor=[RGB(0, 0, 0) CGColor];
        headerBut.frame=CGRectMake(Imarin+(i%5)*(Iwidth+Imarin), i/5*(Iheight+topMarin)+topMarin, Iwidth, Iheight);
        headerBut.tag=100+i;
        UIImageView *IV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Iwidth, Iwidth)];
        
        [headerBut addSubview:IV];
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, Iwidth+8, Iwidth, 12)];
        lab.font=AppointTextFontFourth;
        lab.textColor=APPOINTCOLORSecond;
        lab.textAlignment= NSTextAlignmentCenter;
        [headerBut addSubview:lab];
        
        if (i<headerButCount-account)
        {
            ContactRLMModel *model=self.dataSource[i];
            [IV sd_setImageWithURL:KNSPHOTOURL(model.portraitUri)];
            lab.text=model.aliasName;
            if (model.friendType==0) {
                [headerBut addTarget:self action:@selector(checkContactInfoButClick:) forControlEvents:UIControlEventTouchUpInside];
            }else if(model.friendType==1)
            {
                if ([model.account isEqualToString:[KCUserDefaultManager getAccount]]) {

                }else
                {
                    UIImageView *addFriendIV=[[UIImageView alloc] initWithFrame:CGRectMake(Iwidth-8, -8, 16, 16)];
                    addFriendIV.layer.cornerRadius=8.0;
                    addFriendIV.layer.backgroundColor=[[UIColor redColor] CGColor];
                    [IV addSubview:addFriendIV];
                    [headerBut addTarget:self action:@selector(AddFriendsButClick:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }else if(i==(headerButCount-account))
        {
            [IV setImage:KImage(@"KCMessage-addGroupMember")];
            [headerBut addTarget:self action:@selector(insertGroupMemberButClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [IV setImage:KImage(@"KCMessage-removeGroupMember")];
            [headerBut addTarget:self action:@selector(removeGroupMemberButClick:) forControlEvents:UIControlEventTouchUpInside];
        }
       
        [self.allHeaderIconView addSubview:headerBut];
    }
    
    [_scroll addSubview:self.allHeaderIconView];
    return height;
}

/* ****  群信息  **** */
-(CGFloat)setGroupInfoViewFromHeight:(CGFloat)localHeight
{
    CGFloat height=0;
    if (!_groupInfoView) {
        _groupInfoView=[[UIView alloc] initWithFrame:CGRectMake(0, localHeight, KScreen_Width, 192+20+50)];
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreen_Width, 192)];
        [view setBackgroundColor:[UIColor whiteColor]];
        [_groupInfoView addSubview:view];
        
        [_scroll addSubview:_groupInfoView];
        
        /*
         * 群名称
         */
        UIButton *groupNameBut=[UIButton buttonWithType:UIButtonTypeCustom];
        groupNameBut.frame=CGRectMake(0, 0, KScreen_Width, 50);
        [_groupInfoView addSubview:groupNameBut];
        
        UILabel *groupnameLab=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
        groupnameLab.font=AppointTextFontSecond;
        groupnameLab.textColor=APPOINTCOLORSecond;
        groupnameLab.text=@"群名称";
        
        UILabel *groupnameLab1=[[UILabel alloc] initWithFrame:CGRectMake(KScreen_Width-32-200, 0, 200, 50)];
        groupnameLab1.font=AppointTextFontSecond;
        groupnameLab1.textColor=APPOINTCOLORFirst;
        groupnameLab1.textAlignment=NSTextAlignmentRight;
        groupnameLab1.text=_model.groupName;
        groupnameLab1.tag=200;
        UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(KScreen_Width-32, 17, 9, 16)];
//        [iv setImage:KImage(@"")];
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 49, KScreen_Width, 1)];
        line.backgroundColor=RGB(244, 244, 244);
        
        [groupNameBut addSubview:groupnameLab];
        [groupNameBut addSubview:groupnameLab1];
        [groupNameBut addSubview:iv];
        [groupNameBut addSubview:line];
        
        /*
         *  群昵称
         */
        UIButton *nickNameBut=[UIButton buttonWithType:UIButtonTypeCustom];
        nickNameBut.frame=CGRectMake(0, 50, KScreen_Width, 50);
        [_groupInfoView addSubview:nickNameBut];
        
        UILabel *nickNameLab=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
        nickNameLab.font=AppointTextFontSecond;
        nickNameLab.textColor=APPOINTCOLORSecond;
        nickNameLab.text=@"在本群的昵称";
        UILabel *nickNameLab1=[[UILabel alloc] initWithFrame:CGRectMake(KScreen_Width-32-200, 0, 200, 50)];
        nickNameLab1.font=AppointTextFontSecond;
        nickNameLab1.textColor=APPOINTCOLORFirst;
        nickNameLab1.textAlignment=NSTextAlignmentRight;
        nickNameLab1.text=[KCUserDefaultManager getNickName];
        nickNameLab1.tag=201;
        UIImageView *iv2=[[UIImageView alloc] initWithFrame:CGRectMake(KScreen_Width-32, 17, 9, 16)];
        //        [iv setImage:KImage(@"")];
        UIView *line2=[[UIView alloc] initWithFrame:CGRectMake(0, 49, KScreen_Width, 1)];
        line2.backgroundColor=RGB(244, 244, 244);
        
        [nickNameBut addSubview:nickNameLab];
        [nickNameBut addSubview:nickNameLab1];
        [nickNameBut addSubview:iv2];
        [nickNameBut addSubview:line2];
        
        BOOL selfIsGroupOwner=[_model.groupOwner isEqualToString:[KCUserDefaultManager getAccount]];
        if ([_model.groupType isEqualToString:@"1"]) {
            /* ****  群类型 1。班级群 2。普通群 3.家庭群   **** */
            
        }else if([_model.groupType isEqualToString:@"2"])
        {
            if (selfIsGroupOwner) {
                /*
                 * 群头像
                 */
                UIButton *groupPhotoBut=[UIButton buttonWithType:UIButtonTypeCustom];
                groupPhotoBut.frame=CGRectMake(0, 120, KScreen_Width, 50);
                [_groupInfoView addSubview:groupPhotoBut];
                
                UILabel *groupNickNameLab=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
                groupNickNameLab.font=AppointTextFontSecond;
                groupNickNameLab.textColor=APPOINTCOLORSecond;
                groupNickNameLab.text=@"群头像";
                
                UIImageView *iv3=[[UIImageView alloc] initWithFrame:CGRectMake(KScreen_Width-32-47, 1.5, 47, 47)];
                [iv3 sd_setImageWithURL:KNSPHOTOURL(_model.groupPhoto)];
                
                UIImageView *iv4=[[UIImageView alloc] initWithFrame:CGRectMake(KScreen_Width-32, 17, 9, 16)];
                //        [iv setImage:KImage(@"")];
                
                [groupPhotoBut addSubview:groupNickNameLab];
                [groupPhotoBut addSubview:iv3];
                [groupPhotoBut addSubview:iv4];
                
                [groupPhotoBut addTarget:self action:@selector(changeGroupPhotoButClick:) forControlEvents:UIControlEventTouchUpInside];
                [groupNameBut addTarget:self action:@selector(changeGroupNameButClick:) forControlEvents:UIControlEventTouchUpInside];
                [nickNameBut addTarget:self action:@selector(changeGroupNickNameButClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }else if ([_model.groupType isEqualToString:@"3"])
        {
            XLLog(@"-1-2-3-4-5-6-7-8-9-0-%@",@"");
        }
        
        UIButton *KCAccountLoginBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [KCAccountLoginBut setFrame:CGRectMake(CWidth(29), 192+20, KScreen_Width-CWidth(58), 50)];
        [KCAccountLoginBut setBackgroundColor:RGBHexAlpha(0x008ffb, 1.0)];
        KCAccountLoginBut.layer.cornerRadius=5;
        CAGradientLayer *galayer=[CAGradientLayer layer];
        galayer.frame=KCAccountLoginBut.bounds;
        galayer.startPoint=CGPointMake(0, 0);
        galayer.endPoint=CGPointMake(1, 1);
        galayer.locations=@[@(0),@(1)];
        [galayer setColors:@[RGBHex(0x0087fd),RGBHex(0x01A2f5)]];
        galayer.cornerRadius=5;
        [KCAccountLoginBut.layer addSublayer:galayer];
        
        [KCAccountLoginBut addTarget:self action:@selector(dissolveGroupButClick:) forControlEvents:UIControlEventTouchUpInside];
        [_groupInfoView addSubview:KCAccountLoginBut];
        if (selfIsGroupOwner) {
            [KCAccountLoginBut setTitle:@"解散群" forState:UIControlStateNormal];
        }else
        {
            [KCAccountLoginBut setTitle:@"退出群" forState:UIControlStateNormal];
        }
        
    }else
    {
        CGRect rect=_groupInfoView.frame;
        _groupInfoView.frame=CGRectMake(rect.origin.x, localHeight, rect.size.width, rect.size.height);
    }
    
    return height;
}

#pragma mark - network

-(void)getData
{
 //   WeakSelf;
    [KCNetWorkManager POST:KNSSTR(@"/chatGroupController/getGroupInfo") WithParams:@{@"groupNum":_groupNum} ForSuccess:^(NSDictionary * _Nonnull response) {
     
        if ([response[@"code"] integerValue]==200) {
            NSDictionary *groupDic=response[@"data"];
            [self.dataSource removeAllObjects];
            GroupRLMModel *model=[[GroupRLMModel alloc] init];
            [model mj_setKeyValues:groupDic];
            [KCTRealmManager addOrUpdateObject:model];
            for (NSDictionary *dic in groupDic[@"members"]) {
                ContactRLMModel *Cmodel=[[ContactRLMModel alloc] init];
                [Cmodel mj_setKeyValues:dic];
                [self.dataSource addObject:Cmodel];
            }
            [KCTRealmManager addOrUpdateObjects:self.dataSource];
            [self  setUpSubViews];
        }

    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - events
/*
 * 添加好友
 */
-(void)AddFriendsButClick:(UIButton *)sender
{
    ContactRLMModel *model=self.dataSource[sender.tag-100];
    XLLog(@"add friends %@",model);
    [KCNetWorkManager POST:KNSSTR(@"/friendController/applyFriend") WithParams:@{@"toAccount":model.account} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            [MBProgressHUD showMessageWithImageName:@"KCContact-添加成功" message:@"已发送添加邀请"];
        }
    } AndFaild:^(NSError * _Nonnull error) {
        
    }];
}
/*
 * 查看好友资料
 */
-(void)checkContactInfoButClick:(UIButton *)sender
{
    ContactRLMModel *model=self.dataSource[sender.tag-100];
    XLLog(@"check %@",model);
    KCTAlertView *alertView=[[KCTAlertView alloc] initCantactsAlertViewWithModel:model];
    alertView.aliasBlock = ^{
        XLLog(@"备注");
    };
    alertView.messageBlock = ^{
        XLLog(@"消息");
        
        RoomRLMModel *Rmodel= [KCTRealmManager roomModelWithContactModel:model];
        SSChatController *VC=[[SSChatController alloc] init];
        VC.model=Rmodel;
        VC.hidesBottomBarWhenPushed=YES;
        NSArray *array=@[self.navigationController.viewControllers.firstObject,VC];
        self.navigationController.viewControllers=array;
    };
    alertView.readOnBlock = ^{
        XLLog(@"读播");
    };
    alertView.videoBlock  = ^{
        XLLog(@"视频");
    };
    [alertView showRSAlertView];
}
/*
 * 添加群成员
 */
-(void)insertGroupMemberButClick:(UIButton *)sender
{
    XLLog(@"insert ");
    
    
    KCTMessageCreatGroupVC *VC=[[KCTMessageCreatGroupVC alloc] init];
    VC.dataSource=(NSMutableArray *)[ContactRLMModel objectsWhere:@"friendType == 0"];
    WeakSelf;
    VC.sureSelectBlock = ^(NSArray<ContactRLMModel *> * _Nonnull contactsArr) {
        XLLog(@"%@",contactsArr);
        
        NSMutableArray *temp=[NSMutableArray new];
        for (ContactRLMModel *model in contactsArr) {
            [temp addObject:model.account];
        }
        NSString *str=[temp componentsJoinedByString:@","];
        [KCNetWorkManager POST:KNSSTR(@"/chatGroupController/addMember") WithParams:@{@"accounts":str,@"groupNum":self.model.groupNum} ForSuccess:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue]==200) {
                [self.dataSource addObjectsFromArray:contactsArr];
                [self setUpSubViews];
                
            }
        } AndFaild:^(NSError * _Nonnull error) {
            
        }];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:VC animated:YES];
}
/*
 * 删除群成员
 */
-(void)removeGroupMemberButClick:(UIButton *)sender
{
    XLLog(@"remove ");
    
    KCTMessageCreatGroupVC *VC=[[KCTMessageCreatGroupVC alloc] init];
    WeakSelf;
    VC.dataSource=self.dataSource;
    VC.sureSelectBlock = ^(NSArray<ContactRLMModel *> * _Nonnull contactsArr) {
        XLLog(@"%@",contactsArr);
        
        NSMutableArray *temp=[NSMutableArray new];
        for (ContactRLMModel *model in contactsArr) {
            [temp addObject:model.account];
            if ([model.account isEqualToString:[KCUserDefaultManager getAccount]]) {
                [self dissolveGroupButClick:nil];
                return;
            }
        }
        NSString *str=[temp componentsJoinedByString:@","];
        [KCNetWorkManager POST:KNSSTR(@"/chatGroupController/delMember") WithParams:@{@"accounts":str,@"groupNum":self.model.groupNum} ForSuccess:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue]==200) {
                [self.dataSource addObjectsFromArray:contactsArr];
                [self setUpSubViews];
            }
        } AndFaild:^(NSError * _Nonnull error) {
            
        }];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:VC animated:YES];
    
}
/*
 * 修改群名称
 */
-(void)changeGroupNameButClick:(UIButton *)sender
{
    XLLog(@"群名称");
    KCTNormalChangeInfoVC *VC=[[KCTNormalChangeInfoVC alloc] init];
    VC.titleStr=@"设置群名称";
    VC.placehodle=@"请输入群名称";
    VC.sureChangeTextBlock = ^(NSString *text) {
        [KCNetWorkManager POST:KNSSTR(@"/chatGroupController/updateGroupDetail") WithParams:@{@"groupNum":self.groupNum,@"groupName":text} ForSuccess:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue]==200) {
                [MBProgressHUD showMessage:@"修改成功"];
                UILabel *lab=[self.view viewWithTag:200];
                lab.text=text;
            }
        } AndFaild:^(NSError * _Nonnull error) {
            
        }];
        [self.navigationController popViewControllerAnimated:YES];
    };
    VC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:VC animated:YES];
}
/*
 * 修改群昵称
 */
-(void)changeGroupNickNameButClick:(UIButton *)sender
{
    XLLog(@"群昵称");
    KCTNormalChangeInfoVC *VC=[[KCTNormalChangeInfoVC alloc] init];
    VC.titleStr=@"设置群昵称";
    VC.placehodle=@"请输入群昵称";
    VC.sureChangeTextBlock = ^(NSString *text) {
        [KCNetWorkManager POST:KNSSTR(@"/chatGroupController/updateGroupAliasName") WithParams:@{@"groupNum":self.groupNum,@"aliasName":text} ForSuccess:^(NSDictionary * _Nonnull response) {
            if ([response[@"code"] integerValue]==200) {
                [MBProgressHUD showMessage:@"修改成功"];
                UILabel *lab=[self.view viewWithTag:201];
                lab.text=text;
            }
        } AndFaild:^(NSError * _Nonnull error) {
            
        }];
        [self.navigationController popViewControllerAnimated:YES];
    };
    VC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:VC animated:YES];
}
/*
 * 修改群头像
 */
-(void)changeGroupPhotoButClick:(UIButton *)sender
{
    XLLog(@"群头像");
}
/*
 * 修改群头像
 */
-(void)dissolveGroupButClick:(UIButton *)sender
{
    XLLog(@"解散群");
    [KCNetWorkManager POST:KNSSTR(@"/chatGroupController/exitGroup") WithParams:@{@"groupNum":_model.groupNum} ForSuccess:^(NSDictionary * _Nonnull response) {
        if ([response[@"code"] integerValue]==200) {
            [KCTRealmManager deleteGroupWithModel:self.model];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } AndFaild:^(NSError * _Nonnull error) {
       
    }];
}
#pragma mark - delegate

#pragma mark - lazy loading
-(GroupRLMModel *)model
{
    if (!_model) {
        _model=[GroupRLMModel objectsWhere:[NSString stringWithFormat:@"groupNum contains '%@'",_groupNum]].lastObject;
    }
    return _model;
}
-(NSString *)groupNum
{
    if (!_groupNum) {
        _groupNum=@"";
    }
    return _groupNum;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}
@end
