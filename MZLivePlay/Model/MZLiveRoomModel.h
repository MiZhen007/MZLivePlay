//
//  MZLiveRoomModel.h
//  XuanYan
//
//  Created by mz on 2018/5/18.
//  Copyright © 2018年 mizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark --单个直播室模型

@interface MZLiveRoomModel : NSObject
//新增参数
@property(nonatomic,copy)NSString *courseID;
@property(nonatomic,copy)NSString *purchaseStatus;//课时购买状态
@property(nonatomic,copy)NSString *liveStatus;//直播课时开播状态
//原版参数
@property(nonatomic,copy)NSString *playID;//
@property(nonatomic,copy)NSString *lessonSubject;
@property(nonatomic,copy)NSString *playNumber;//*
@property(nonatomic,assign)int roomStatus;
@property(nonatomic,copy)NSString *liveDescription;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *createdTime;
@property(nonatomic,copy)NSString *audienceJoinUrl;
@property(nonatomic,copy)NSString *audienceJoinToken;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *thumbUrl;
@property(nonatomic,copy)NSString *plan;
@property(nonatomic,copy)NSString *contentIntro;
@property(nonatomic,copy)NSString *expert;//讲师名称
@end










