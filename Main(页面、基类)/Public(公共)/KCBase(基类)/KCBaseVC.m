//
//  KCBaseVC.m
//  SuperFriendsApp
//
//  Created by Hawky on 2018/10/12.
//  Copyright © 2018年 Hawky. All rights reserved.
//

#import "KCBaseVC.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
@interface KCBaseVC ()

@end

@implementation KCBaseVC


- (void)viewDidLoad {
    [super viewDidLoad];
   // self.automaticallyAdjustsScrollViewInsets = NO;
  //  self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setSubViews];
    // Do any additional setup after loading the view.
}
-(void)setSubViews
{
    self.view.backgroundColor=[UIColor whiteColor];
    
}

-(void)qurtButClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshHeader
{
    XLLog(@"refreshheader...");
}
-(void)loadMoreData
{
    XLLog(@"loadMoreData...");
}

#pragma mark 请求通讯录权限
- (void)requestContactAuthorAfterSystemVersion9{
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error) {
                XLLog(@"授权失败");
            }else {
                XLLog(@"成功授权");
                [self openContact];
            }
        }];
    }
    else if(status == CNAuthorizationStatusRestricted)
    {
        XLLog(@"用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusDenied)
    {
        XLLog(@"用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusAuthorized)//已经授权
    {
        //有通讯录权限-- 进行下一步操作
        [self openContact];
    }
    
}

//有通讯录权限-- 进行下一步操作
- (void)openContact{
    
    NSMutableArray *contactsArr=[NSMutableArray array];
    NSMutableArray *phoneNumberArr=[NSMutableArray array];
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey,CNContactImageDataKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        XLLog(@"-------------------------------------------------------%@",contact);
        ContactRLMModel *model=[[ContactRLMModel alloc] init];
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        XLLog(@"givenName=%@, familyName=%@", givenName, familyName);
        //拼接姓名
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        NSArray *phoneNumbers = contact.phoneNumbers;
        /*
        NSData *imageData=contact.thumbnailImageData;
        UIImage *image=nil;
        NSString *imageStr=[NSString stringWithFormat:@"%@",imageData];
        if (!imageStr||[imageStr containsString:@"null"]||[imageStr isEqualToString:@""]) {
            image=KImage(@"超级好友");
        }else
        {
            image=[UIImage imageWithData:imageData];
        }
       */
        
    
        for (CNLabeledValue *labelValue in phoneNumbers) {
            //遍历一个人名下的多个电话号码
          
            CNPhoneNumber *phoneNumber = labelValue.value;
            
            NSString * string = phoneNumber.stringValue;
            
            //去掉电话中的特殊字符
            string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
            XLLog(@"姓名=%@, 电话号码是=%@,%ld", nameStr, string,string.length);
            NSString *cleaned = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
            XLLog(@"姓名=%@, 电话号码是=%@", nameStr, cleaned);
            
            if (![phoneNumberArr containsObject:cleaned]&&[cleaned phoneNumberIsCorrect]) {
                model.nickName=nameStr;
                model.phoneNum=cleaned;
              //  model.headImage = image;
                [phoneNumberArr addObject:cleaned];
                [contactsArr addObject:model];
            }
            break;
        }
        
    }];
    if (_contactBlock&&contactsArr>0) {
        self.contactBlock(contactsArr);
    }
}




//提示没有通讯录权限
- (void)showAlertViewAboutNotAuthorAccessContact{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"请授权通讯录权限"
                                          message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许超级好友访问你的通讯录"
                                          preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
