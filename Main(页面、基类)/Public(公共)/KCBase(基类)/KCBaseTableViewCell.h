//
//  KCBaseTableViewCell.h
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/22.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
NS_ASSUME_NONNULL_BEGIN

@interface KCBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) id dataModel;

-(void)setUpSubviews;

@end

NS_ASSUME_NONNULL_END
