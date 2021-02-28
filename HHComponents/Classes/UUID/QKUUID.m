//
//  QKUUID.m
//  Pods
//
//  Created by zhf on 2019/11/21.
//

#import "QKUUID.h"
#import "QKKeyChainStore.h"

#define  KEY_QK_UUID @"com.qk365.appUUID"

@implementation QKUUID

+ (NSString *)getUUID
{
    NSString *strUUID=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_QK_UUID];
    if (!strUUID)
    {
        strUUID = (NSString *)[QKKeyChainStore qk_load:KEY_QK_UUID];
        if (!strUUID) {
            strUUID =  [[UIDevice currentDevice].identifierForVendor UUIDString];
            if (strUUID && strUUID.length>0 && ![strUUID isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
                //将该uuid保存到keychain
                @try {
                    [QKKeyChainStore qk_save:KEY_QK_UUID data:strUUID];
                } @catch (NSException *exception) {
                    NSLog(@"keychainstore save exception  %@",exception);
                } @finally {
                    
                }
            }
        }
        if (strUUID && strUUID.length>0 && ![strUUID isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
            //将uuid存放到沙盒中，避免中间卸载重装过应用，系统升级后uuid改变的问题
            [[NSUserDefaults standardUserDefaults] setObject:strUUID forKey:KEY_QK_UUID];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    if (!strUUID) {
        strUUID = @"00000000-0000-0000-0000-000000000000";
    }
    
    return strUUID;
}

@end
