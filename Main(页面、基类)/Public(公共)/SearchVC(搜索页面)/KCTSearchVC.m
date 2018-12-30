//
//  KCTSearchVC.m
//  SuperFriendsApp
//
//  Created by KCMac on 2018/12/30.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTSearchVC.h"
#import "XLSearchPopView.h"
#import "SearchCoreManager.h"
#import "NSString+chineseTransform.h"
#import "Masonry.h"
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
@interface KCTSearchVC ()<UISearchBarDelegate>

/**
 The search bar
 */
@property (nonatomic, weak) UISearchBar *searchBar;
/*
 * 搜索结果
 */
@property (nonatomic,strong) XLSearchPopView * searchPopView;

@property (nonatomic,strong) NSMutableDictionary * dataDict;//搜索数据源

@property (nonatomic,strong) NSMutableArray * searchNameResultArry;

@end

@implementation KCTSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initData
{
    if (self.searchType==1) {
        for (int i = 0; i<self.dataSource.count; i++) {
            ContactRLMModel * model = self.dataSource[i];
            [[SearchCoreManager share]AddContact:@(i) name:model.aliasName phone:nil];
            [self.dataDict setObject:model forKey:@(i)];
        }
    }else
    {
        for (int i = 0; i<self.dataSource.count; i++) {
            MessageRLMModel * model = self.dataSource[i];
            [[SearchCoreManager share]AddContact:@(i) name:model.msg phone:nil];
            [self.dataDict setObject:model forKey:@(i)];
        }
    }
    
    
}

-(void)setSubViews
{
    [super setSubViews];
    UIBarButtonItem *bar=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(qurtButClick)];
    [self.navigationItem setLeftBarButtonItem:bar];
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0,0, KScreen_Width-60, 44)];
    UISearchBar *searchBar=[[UISearchBar alloc] initWithFrame:customView.bounds];
    searchBar.delegate=self;
    searchBar.placeholder = @"搜索";
    searchBar.layer.cornerRadius = 15;
    searchBar.layer.masksToBounds = YES;
    //设置背景图是为了去掉上下黑线
    searchBar.backgroundImage = [[UIImage alloc] init];
    UITextField *searchField=[searchBar valueForKey:@"searchField"];
    searchField.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:0.3];
    [customView addSubview:searchBar];
    self.navigationItem.titleView=customView;
    [searchBar becomeFirstResponder];
    
    self.searchPopView = ({
        XLSearchPopView * popView = [[XLSearchPopView alloc]initWithAttributeBlock:^(XLSearchPopView *popView) {
            popView.animationTime = 0.25;
        }];
        [self.view addSubview:popView];
        [popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_bottom);
            make.left.mas_equalTo(self.view.mas_left);
            make.width.mas_equalTo(self.view.mas_width);
            make.height.mas_equalTo(self.view.bounds.size.height - KSafeAreaTopNaviHeight);
        }];
        popView;
    });
    [self.searchPopView showThePopViewWithArray:[@[] mutableCopy]];
    WeakSelf;
    self.searchPopView.selectPopElement = ^(id model) {
        if (weakSelf.selectPopElement) {
            weakSelf.selectPopElement(model);
        }
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
   // self.searchPopView
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.searchType==1) {
        [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:self.searchNameResultArry phoneMatch:nil];
        NSNumber * localID;
        NSMutableString *matchString = [NSMutableString string];//为了在库中找到匹配的号码或者是拼音 有那个显示那个
        NSMutableArray * tmpArry = NSMutableArray.new;
        NSMutableArray *matchPos = [NSMutableArray array];
        for (int i = 0; i < self.searchNameResultArry.count; i ++) {
            localID = [self.searchNameResultArry objectAtIndex:i];
            
            if ([searchText length]) {
                [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
                ContactRLMModel * model = [self.dataDict objectForKey:localID];
                [tmpArry addObject:model];
                NSMutableAttributedString * attributedString = [NSString lightStringWithSearchResultName:model.aliasName matchArray:matchPos inputString:searchText lightedColor:RGBHex(0x467dff)];
                model.attributedString = attributedString;
            }
        }
        self.searchPopView.dataSource = tmpArry.mutableCopy;
        
    }else
    {
        [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:self.searchNameResultArry phoneMatch:nil];
        NSNumber * localID;
        NSMutableString *matchString = [NSMutableString string];//为了在库中找到匹配的号码或者是拼音 有那个显示那个
        NSMutableArray * tmpArry = NSMutableArray.new;
        NSMutableArray *matchPos = [NSMutableArray array];
        NSMutableSet *set=[[NSMutableSet alloc] init];
        for (int i = 0; i < self.searchNameResultArry.count; i ++) {
            localID = [self.searchNameResultArry objectAtIndex:i];
            if ([searchText length]) {
                [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
                MessageRLMModel * model = [self.dataDict objectForKey:localID];
               
                NSMutableAttributedString * attributedString = [NSString lightStringWithSearchResultName:model.msg matchArray:matchPos inputString:searchText lightedColor:RGBHex(0x467dff)];
                model.attributedString = attributedString;
                
                if (![set containsObject:model.roomNo]) {
                    RLMResults *rs=[RoomRLMModel objectsWhere:[NSString stringWithFormat:@"roomNo = '%@'",model.roomNo]];
                    
                    if (rs.count>0) {
                        RoomRLMModel *Rmodel=rs.lastObject;
                        RoomRLMModel *rModel1=[[RoomRLMModel alloc] init];
                        rModel1.type=Rmodel.type;
                        rModel1.roomNo=Rmodel.roomNo;
                        rModel1.timestamp=model.timeStamp;
                        rModel1.unreadNum=0;
                        rModel1.contact=Rmodel.contact;
                        rModel1.group=Rmodel.group;
                        rModel1.chat=model;
                        [tmpArry addObject:rModel1];
                    }
                    [set addObject:model.roomNo];
                }
            }
        }
        self.searchPopView.dataSource = tmpArry.mutableCopy;
        
    }
    
    
    
    
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0)
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSMutableDictionary *)dataDict{
    
    if (!_dataDict) {
        _dataDict = NSMutableDictionary.new;
    }
    return _dataDict;
}

- (NSMutableArray *)searchNameResultArry{
    
    if (!_searchNameResultArry) {
        _searchNameResultArry = [NSMutableArray array];
    }
    return _searchNameResultArry;
}

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource=dataSource;
    [self initData];
}

-(NSInteger)searchType
{
    if (!_searchType) {
        _searchType=1;
    }
    _searchPopView.searchType=_searchType;
    return _searchType;
}
@end
