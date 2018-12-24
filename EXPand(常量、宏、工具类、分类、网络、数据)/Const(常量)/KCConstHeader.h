//
//  KCConstHeader.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/11.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#ifndef KCConstHeader_h
#define KCConstHeader_h
#pragma mark - 服务器地址

/*
 * 测试
 */
static NSString *const ServerUrl=@"http://139.196.210.223:9999/";
//static NSString *const ServerUrl=@"http://192.168.0.115:10001/";

/*
 * 线上
 */
//static NSString *const ServerUrl=@"https://flytalk.flypaas.com/";
/*
 * 图片服务器地址
 */
static NSString *const PhotoUrl=@"https://imagetest.flypaas.com/";

static NSString *const defaultIconUrl=@"https://img2.woyaogexing.com/2018/10/18/dff8259a6d5d40728ae907d18d68e7d3!400x400.jpeg";
#pragma mark - 通知

/*****  登录成功通知 *****/
static NSString *const KCLoginInSuccessNoti = @"KCLoginInSuccessNoti";
/*****  退出登录通知 *****/
static NSString *const KCLoginOutSucessNoti = @"KCLoginOutSucessNoti";
/* ****  联系人页面刷新数据  **** */
static NSString *const KCContactsChangeNoti=@"KCContactsChangeNoti";
#endif /* KCConstHeader_h */

