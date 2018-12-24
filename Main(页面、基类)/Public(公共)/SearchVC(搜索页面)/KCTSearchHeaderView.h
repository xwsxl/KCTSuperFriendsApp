//
//  KCTSearchHeaderView.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/14.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KCTSearchHeaderView : KCBaseView

@property (nonatomic, strong) UIImageView *searchIcon;

@property (nonatomic, strong) UILabel *searchPlaceholdLab;

@property (nonatomic, copy) void (^searchButClick) (void);

@end

NS_ASSUME_NONNULL_END
