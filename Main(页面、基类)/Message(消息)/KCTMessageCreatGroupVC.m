//
//  KCTContactsCreatGroupVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/11/16.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCTMessageCreatGroupVC.h"
#import "KCTContacsSelectFriendsCell.h"


@interface KCTMessageCreatGroupVC ()<UITableViewDelegate,UITableViewDataSource>

/* ****  表视图  **** */
@property (nonatomic, strong) UITableView *tableview;

/* ****  用于存储选中的下标集合  **** */
@property (nonatomic, copy) NSMutableSet *selectSet;
/* ****  分区头数据源  **** */
@property (nonatomic, strong) NSMutableArray *sectionTitleArr;
/* ****  数据源  **** */
@property (nonatomic, strong) NSMutableArray *anArrayOfArrays;

@end

@implementation KCTMessageCreatGroupVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self getdatas];
    // Do any additional setup after loading the view.
    
}
#pragma mark - setUI

-(void)setSubViews
{
    
    self.title=@"选择联系人";
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(qurtButClick)];
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureSelectContacts)];
    [self.navigationItem setLeftBarButtonItem:leftBar];
    [self.navigationItem setRightBarButtonItem:rightBar];
    
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [_tableview registerClass:[KCTContacsSelectFriendsCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableview];
    
}

#pragma mark - network
/*
 * 获取数据
 */
-(void)getdatas
{
    [self method2];
}
/* ****  排序  **** */
- (void)method2 {
    
    @autoreleasepool {
        
        self.anArrayOfArrays = [NSMutableArray array];
        _sectionTitleArr=nil;
        for (int i = 0; i < self.sectionTitleArr.count; i++) {
            NSMutableArray *tmpMArray = [NSMutableArray array];
            [self.anArrayOfArrays addObject:tmpMArray];
        }
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
        for (ContactRLMModel *model in self.dataSource) {
            if (model.account) {
                NSInteger section = [collation sectionForObject:model collationStringSelector:@selector(nickName)];
                [(NSMutableArray *)self.anArrayOfArrays[section] addObject:model];
            }
        }
        
        for (NSMutableArray *arr in self.anArrayOfArrays) {
            NSArray *sortArr = [collation sortedArrayFromArray:arr collationStringSelector:@selector(nickName)];
            [arr removeAllObjects];
            [arr addObjectsFromArray:sortArr];
        }
        
        //去掉无数据的数组
        //同步 sectionTitleArr
        NSMutableArray *tmpArrA = [NSMutableArray array];
        NSMutableArray *tmpArrB = [NSMutableArray array];
        for (int i = 0; i < self.anArrayOfArrays.count; i++) {
            
            if (((NSMutableArray *)self.anArrayOfArrays[i]).count == 0) {
                [tmpArrA addObject:self.sectionTitleArr[i]];
                [tmpArrB addObject:self.anArrayOfArrays[i]];
            }
            
        }
        
        for (int i = 0; i < tmpArrA.count; i++) {
            [self.sectionTitleArr removeObject:tmpArrA[i]];
            [self.anArrayOfArrays removeObject:tmpArrB[i]];
        }
        //   [self.anArrayOfArrays insertObject:self.dataSource atIndex:0];
         
        
    }
    [self.tableview reloadData];
}
#pragma mark - events

/*
 * 确定选择
 */
-(void)sureSelectContacts
{
   
    NSMutableArray *tempArr=[NSMutableArray new];
    for (NSIndexPath *indexpath in self.selectSet) {
        ContactRLMModel *model=self.anArrayOfArrays[indexpath.section][indexpath.row];
        [tempArr addObject:model];
    }
    if (_sureSelectBlock&&(tempArr.count>0)) {
        self.sureSelectBlock(tempArr);
    }
}

#pragma mark - delegate
/* ****  分区  **** */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return self.anArrayOfArrays.count;
}
/* ****  每一个分区的行数  **** */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return ((NSArray *)self.anArrayOfArrays[section]).count;
}
/* ****  单元格  **** */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KCTContacsSelectFriendsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    BOOL isselect=[self.selectSet containsObject:indexPath];
    cell.selected=isselect;
    cell.dataModel=self.anArrayOfArrays[indexPath.section][indexPath.row];
    return cell;
}
/* ****  每一行的高度  **** */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
/* ****  分区头高度  **** */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
/* ****  分区尾高度  **** */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
/* ****  分区头视图  **** */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
/* ****  分区尾视图  **** */
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
//返回索引数组
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitleArr;
}
//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return self.sectionTitleArr.count;
    
}

/* ****  选中单元格  **** */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectSet containsObject:indexPath]) {
        [self.selectSet removeObject:indexPath];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else
    {
        [self.selectSet addObject:indexPath];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    XLLog(@"选中了单元格");
}
#pragma mark - lazy loading

/*
 * 选中的index集合
 */
-(NSMutableSet *)selectSet
{
    if (!_selectSet) {
        _selectSet=[[NSMutableSet alloc] init];
    }
    return _selectSet;
}

-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, KSafeAreaTopNaviHeight, KScreen_Width, KScreen_Height-KSafeAreaTopNaviHeight-KSafeAreaBottomHeight) style:UITableViewStyleGrouped];
    }
    return _tableview;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)sectionTitleArr {
    
    if (!_sectionTitleArr) {
        _sectionTitleArr = [NSMutableArray arrayWithArray:[UILocalizedIndexedCollation currentCollation].sectionTitles];
    }
    
    return _sectionTitleArr;
}

- (NSMutableArray *)anArrayOfArrays {
    
    if (!_anArrayOfArrays) {
        _anArrayOfArrays = [NSMutableArray array];
    }
    
    return _anArrayOfArrays;
}
@end
