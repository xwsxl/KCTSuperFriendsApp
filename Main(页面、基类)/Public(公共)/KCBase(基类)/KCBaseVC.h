//
//  KCBaseVC.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^contactsBlock)(NSArray *contactsArr);

@interface KCBaseVC : UIViewController

@property (nonatomic, copy) contactsBlock contactBlock;

-(void)setSubViews;
-(void)qurtButClick;
-(void)refreshHeader;
-(void)loadMoreData;
- (void)requestContactAuthorAfterSystemVersion9;
@end

NS_ASSUME_NONNULL_END
