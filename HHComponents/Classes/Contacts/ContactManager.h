//
//  ContactManager.h
//  HuaHong
//
//  Created by 华宏 on 2020/11/2.
//  Copyright © 2020 huahong. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "Singleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactModel : BaseModel

@property (copy  ,nonatomic) NSString *name;
@property (copy  ,nonatomic) NSString *phone;
@property (copy  ,nonatomic) UIImage *headImage;
@end

@interface ContactManager : NSObject

SingletonH()

- (void)getContactsWithComplate:(void(^)(NSArray<ContactModel *> *list))complate;

@end

NS_ASSUME_NONNULL_END

