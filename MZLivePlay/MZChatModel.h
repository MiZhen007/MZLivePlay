//
//  MZChatModel.h
//  XuanYan
//
//  Created by mz on 17/2/18.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  聊天消息
 */
@interface MZChatModel : NSObject

/**
 *  消息文本
 */
@property (nonatomic, copy) NSString *text;

/**
 *  消息文本2，和text相互辅助支持SDK自带emoji
 */
@property (nonatomic, copy) NSString *richText;

/**
 *  发送者名字
 */
@property (nonatomic, copy) NSString *senderName;

/**
 *  发送者用户ID
 */
@property (nonatomic, assign) long long senderUserID;

/**
 *  发送者聊天ID
 */
@property (nonatomic, assign) unsigned int senderChatID;

/**
 *  收到消息的时间
 */
@property (nonatomic, assign) long long receiveTime;

/**
 *  聊天类型
 */
@property (nonatomic, assign) GSPChatType chatType;

/**
 *  接收消息的用户的UserID
 */
@property (nonatomic, assign) long long targetUserID;


/**
 *  接收消息的用户的昵称
 */
@property (nonatomic, copy) NSString *targetUserName;

/**
 *  角色
 */
@property (nonatomic, assign) NSUInteger role;

@end
















