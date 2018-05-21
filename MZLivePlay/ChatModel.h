//
//  ChatModel.h
//  chat
//
//  Created by T_Yang on 15/9/2.
//  Copyright © 2015年 杨 天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject


@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, assign, getter = isHiddenTime) BOOL hiddenTime;
///////////////////////////
/**
 *  问题ID
 */
@property (nonatomic, strong)NSString *questionID;

/**
 *  答案ID
 */
@property (nonatomic, strong)NSString *answerID;

/**
 * 问题或者答案的内容
 */
@property (nonatomic, strong)NSString *content;

/**
 *  问题发送者的名字
 */
@property (nonatomic, strong)NSString *ownerName;

/**
 *  收到问题的时间，微秒级时间戳。1毫秒 ＝ 1000微秒
 */
@property (nonatomic, assign)long long recieveTime;

/**
 *  表示这个数据是问题还是答案
 */
@property (nonatomic, assign) BOOL isQuestion;

/**
 *  问题发送者的ID
 */
@property (nonatomic, assign) long long ownnerID;

/**
 *  表示是否撤销发布这个问题
 */
@property (nonatomic, assign) BOOL isCanceled;


@property (nonatomic, assign) long long receiveFlag;

@end
