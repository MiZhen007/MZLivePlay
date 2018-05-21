

//
//  CommentModel.h
//  XuanYan
//
//  Created by mz on 2017/8/21.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
//内容数据
@property(nonatomic,copy)NSString *portraitUrl;//评论人头像

@property(nonatomic,copy)NSString *title;//评论人
@property(nonatomic,copy)NSString *dateTime;//评论日期
@property(nonatomic,copy)NSString *content;//评论内容

//特性数据
@property(nonatomic,assign)CGFloat CommentHeight;//评论视图高度
//消息状态
@property(nonatomic,assign)NSInteger messageStatus;//消息发送状态 0:发送成功，1:正在发送，2:发送失败

//
-(void)initPerformanceDataWithViewWidth:(CGFloat )viewWidth;//计算初始化特征数据

@end












