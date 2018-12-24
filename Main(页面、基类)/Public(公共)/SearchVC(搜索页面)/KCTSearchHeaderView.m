//
//  KCTSearchHeaderView.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/14.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTSearchHeaderView.h"

@implementation KCTSearchHeaderView

-(void)setSubviews
{
    [super setSubviews];
    CGRect rect=self.bounds;
    UIView *searchView=[[UIView alloc] initWithFrame:rect];
    [searchView setBackgroundColor:RGB(244, 244, 244)];
    [self addSubview:searchView];
    
    UIView *searchBackView=[[UIView alloc] initWithFrame:CGRectMake(10, 10, rect.size.width-20, rect.size.height-20)];
    searchBackView.layer.cornerRadius=(rect.size.height-20)/2.0;
    [searchBackView.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [searchView addSubview:searchBackView];
    
    self.searchIcon=[[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 20, 20)];
    [_searchIcon setImage:KImage(@"KCMessage-搜索")];
    [searchBackView addSubview:_searchIcon];
   
    self.searchPlaceholdLab=[[UILabel alloc] initWithFrame:CGRectMake(50, 8, rect.size.width-50, 20)];
    self.searchPlaceholdLab.font=AppointTextFontSecond;
    self.searchPlaceholdLab.textColor=APPOINTCOLORFifth;
    [self.searchPlaceholdLab setText:@"搜索"];
    [searchBackView addSubview:self.searchPlaceholdLab];
    
    UIButton *searchBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBackButton.frame=rect;
    [searchBackButton addTarget:self action:@selector(searchBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBackButton];
}

-(void)searchBarButtonClick:(UIButton *)sender
{
    if (self.searchButClick) {
        self.searchButClick();
    }
    XLLog(@"点击了搜索");
}

@end
