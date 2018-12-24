//
//  XLNaviView.m
//  XLTaoMall
//
//  Created by Hawky on 2018/5/29.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "XLNaviView.h"



@interface XLNaviView ()
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UIImageView *backIV;
@property (nonatomic,strong)UIButton *qurtBut;

@property (nonatomic,strong)UIImage *BackImage;

@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *imgNam;
@end

@implementation XLNaviView


-(NSString *)title
{
    if (!_title) {
        _title=@"订单详情";
    }
    return _title;
}
-(NSString *)imgNam
{
    if (!_imgNam) {
        _imgNam=@"KCNaviBar-返回";
    }
    return _imgNam;
}


-(instancetype)initWithFrame:(CGRect )frame AndMessage:(NSString *)msg ImageName:(NSString *)imgName
{
    if (msg&&![msg isEqualToString:@""]&&![msg containsString:@"null"]) {
        self.title=msg;
    }
    if (imgName&&![imgName isEqualToString:@""]&&![imgName containsString:@"null"]) {
        self.imgNam=imgName;
    }
    return [self initWithFrame:frame];
}

-(instancetype)initWithMessage:(NSString *)msg ImageName:(NSString *)imgName
{
    if (msg&&![msg isEqualToString:@""]&&![msg containsString:@"null"]) {
        self.title=msg;
    }
    if (imgName&&![imgName isEqualToString:@""]&&![imgName containsString:@"null"]) {
        self.imgNam=imgName;
    }
    CGRect frame=CGRectMake(0, 0, KScreen_Width, KSafeAreaTopNaviHeight);
    return [self initWithFrame:frame];
}

-(instancetype)initWithFrame:(CGRect)frame
{

    if (self=[super initWithFrame:frame]) {
        [self setUpSubviews];
    }
    return self;
}

-(void)setUpSubviews
{
    [self setBackgroundColor:[UIColor whiteColor]];
    self.userInteractionEnabled=YES;
    [self addSubview:self.backIV];

    self.line = [[UIView alloc] init];


    self.line.backgroundColor = MAINSEPRATELINECOLOR;

    [self addSubview:self.line];

    //返回按钮

    self.qurtBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.qurtBut setImage:[UIImage imageNamed:self.imgNam] forState:UIControlStateNormal];
    [self.qurtBut addTarget:self action:@selector(QurtBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.qurtBut];

    //创建搜索
    self.titleLab=[[UILabel alloc] init];

    self.titleLab.text =self.title;

    self.titleLab.textColor = [UIColor blackColor];

    self.titleLab.font = [UIFont systemFontOfSize:19.0];

    self.titleLab.textAlignment = NSTextAlignmentCenter;

    [self addSubview:self.titleLab];

}

-(void)layoutSubviews
{
    [super layoutSubviews];

    [self.titleLab setFrame:CGRectMake(100, 25+KSafeTopHeight, [UIScreen mainScreen].bounds.size.width-200, 30)];

    [self.qurtBut setFrame:CGRectMake(10, 25+KSafeTopHeight, 30, 30)];
    [self.line setFrame:CGRectMake(0, KSafeAreaTopNaviHeight-1, [UIScreen mainScreen].bounds.size.width, 1)];
    [self.backIV setFrame:self.frame];
}

-(void)QurtBtnClick
{
    if (self.qurtBlock) {
        self.qurtBlock();
    }else
    {
        XLLog(@"当前导航栏未设置返回block");
    }
}

@end
