//
//  ChatModel.m
//  chat
//
//  Created by T_Yang on 15/9/2.
//  Copyright © 2015年 杨 天. All rights reserved.
//

#import "ChatModel.h"

@implementation ChatModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"time"]) {
        _recieveTime=(long long)value;
    }
   
}
//通过未定义的key取值时，不重写此方法就会崩溃
-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
