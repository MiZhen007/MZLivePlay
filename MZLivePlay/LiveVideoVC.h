//
//  VideoLiveVC.h
//  XuanYan
//
//  Created by mz on 16/9/27.
//  Copyright © 2016年 mizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZQaView.h"
#import "LiveViewController.h"

@interface LiveVideoVC : UIViewController

@property(nonatomic,assign)PurchaseStatus purchaseStatus;
@property(nonatomic,assign)PresentStyle presentStyle;

@property(nonatomic,strong)MBProgressHUD *progressHUD;

//初始化类型
@property(nonatomic,assign)NSInteger playType;///0代表网络请求，1代表直接播放

//直播室数据
@property(nonatomic,strong)LiveRoomDetailModel *liveRoomModel;

@property(nonatomic,strong)GSPPlayerManager *playerManager;
//视频播放器
@property(nonatomic,strong)GSPVideoView *videoView;
//文档浏览器
@property(nonatomic,strong)GSPDocView *docView;
//问答展示
//@property(nonatomic,strong)GSPQaView *qaView;
@property(nonatomic,strong)MZQaView *qaView;
//全屏按钮
@property(nonatomic,strong)UIButton *fullScreenBtn;

#pragma mark -- Network
-(void)downloadDataViaNet;

@end
















