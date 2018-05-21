//
//  LivePushViewController.h
//  XuanYan
//
//  Created by mz on 2017/11/6.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLiveHeader.h"

@interface LivePushViewController : MZBaseViewController<TXLivePushListener>


@property(nonatomic,strong)NSString *liveID;//直播ID

@property(nonatomic,strong)TXLivePush *txLivePush;
// 创建 LivePushConfig 对象，该对象默认初始化为基础配置

@property(nonatomic,strong)TXLivePushConfig* config;

//问答展示
@property(nonatomic,strong)MZQaView *qaView;
//全屏按钮
@property(nonatomic,strong)UIButton *fullScreenBtn;
////////////////////////////////////////
//通讯管理器
@property(nonatomic,strong)TIMManager * IMManager;

#pragma mark -- Network
-(void)downloadDataViaNet;
@end








