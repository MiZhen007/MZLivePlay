
//
//  LivePlayViewController.h
//  XuanYan
//
//  Created by mz on 2017/11/2.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import "MZBaseViewController.h"
#import "MZLiveHeader.h"

#import "MZQaView.h"
#import "LivePlayViewController.h"

@interface LivePlayViewControlle : MZBaseViewController <TXLivePlayListener>
////
@property(nonatomic,assign)PresentStyle presentStyle;
////
//初始化类型
@property(nonatomic,assign)NSInteger playType;///0代表网络请求，1代表直接播放
////
@property(nonatomic,copy)NSString *liveID;//直播ID
//视频播放器
@property(nonatomic,strong)TXLivePlayConfig*  config;
@property(nonatomic,strong)TXLivePlayer *txLivePlayer;
//聊天室模块
@property(nonatomic,strong)MZQaView *qaView;
////////////////////////////////////////
//通讯管理器
@property(nonatomic,strong)TIMManager * IMManager;

#pragma mark -- Network
-(void)downloadDataViaNet;


@end















