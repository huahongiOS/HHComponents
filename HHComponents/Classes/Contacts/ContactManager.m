//
//  ContactManager.m
//  HuaHong
//
//  Created by 华宏 on 2020/11/2.
//  Copyright © 2020 huahong. All rights reserved.
//


#import "ContactManager.h"
#import <ContactsUI/ContactsUI.h>

@implementation ContactModel

@end

@implementation ContactManager

SingletonM()

//MARK: - 通讯录权限
-(void)p_ContactsAuthStatusWithCompletionHandler:(void(^)(CNAuthorizationStatus status))handler
{
    
    if (@available(iOS 9.0, *)) {
            CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (authStatus) {
            case CNAuthorizationStatusNotDetermined:
            {
               CNContactStore *contactStore = [[CNContactStore alloc] init];
               [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                   
                   CNAuthorizationStatus newStatus = granted ? CNAuthorizationStatusAuthorized : CNAuthorizationStatusDenied;

                   dispatch_async(dispatch_get_main_queue(), ^{
                       !handler ?: handler(newStatus);
                   });
               }];
            }
                break;
            
            default:
                !handler ?: handler(authStatus);
                break;
        }
            
    }
    

}

#pragma mark - 自定义通讯录
- (void)getContactsWithComplate:(void(^)(NSArray<ContactModel *> *list))complate
{
    
    //判断授权状态
    __weak typeof(self) weakSelf = self;

    [self p_ContactsAuthStatusWithCompletionHandler:^(CNAuthorizationStatus status) {
       
        if (status == CNAuthorizationStatusAuthorized) {
            
           [weakSelf getContactListWithComplate:complate];
            
        }else{
           NSLog(@"无通讯录权限");
            !complate ?: complate(@[]);
        }
    }];
    
}

-(void)getContactListWithComplate:(void(^)(NSArray<ContactModel *> *list))complate
{
    
    NSMutableArray *contactList = [NSMutableArray array];
    
    CNContactStore *store = [[CNContactStore alloc]init];
    // 3. 创建联系人信息的请求对象
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey];
    
    // 4. 根据请求Key, 创建请求对象
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keys];
    
    // 5. 发送请求
    [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
        ContactModel *model = [[ContactModel alloc]init];
        
        // 6.1 获取姓名
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        NSString *name = [givenName stringByAppendingString:familyName];
        model.name = name;
        NSLog(@"givenName:%@--familyName:%@", givenName, familyName);
        
        // 6.2 获取电话
        NSArray *phoneArr = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneArr) {
            CNPhoneNumber *phoneNumber = labelValue.value;
            model.phone = phoneNumber.stringValue;
        }
        
        //获取头像缩略图
        if ([contact isKeyAvailable:CNContactThumbnailImageDataKey]) {
            NSData *thumImageData = contact.thumbnailImageData;
            UIImage *headImage = [UIImage imageWithData:thumImageData];
            model.headImage = headImage;
        }
        [contactList addObject:model];
        
        
    }];
    
    !complate ?: complate(contactList);
    
}

@end
 
