//
//  KCFillInfoView.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KCFillInfoView : KCBaseView

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) NSString *titleLabText;

@property (nonatomic, copy) NSString *placeHolderText;

@end

NS_ASSUME_NONNULL_END
