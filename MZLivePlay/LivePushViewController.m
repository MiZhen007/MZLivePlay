
//
//  LivePushViewController.m
//  XuanYan
//
//  Created by mz on 2017/11/6.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import "LivePushViewController.h"

@interface LivePushViewController (){
    //推流地址
    NSString *pushUrl;
    /////
    //承载直播的底层视图
    UIView *bottomLiveView;
    ///直播播放视图
    UIView *liveView;
    //加载转圈
    MZActivityIndicatorView *activityIndView;
    
    //开始直播按钮
    UIButton *startPushBtn;
    //创建介绍栏
    UIButton *introduceBtn;
    //全屏按钮
    UIButton *fullScreenBtn;
    //切换摄像头按钮
    UIButton *switchBtn;
    //打开闪光灯
    UIButton *toggleTorchBtn;
    //控制条
    UIImageView *controlView;
    
    CGRect originalVideoViewFrame;//记录videoView的原始尺寸
    CGRect originalQaViewFrame;//记录问答视图的原始尺寸
    CGRect largeWindow;//转屏后的大窗口frame
    CGRect subWindow; //转屏后侧栏的大小
    CGFloat topBtnWidth;//顶部控制按钮直径
    
    CGRect originalIntroduceBtnFrame;//记录简介栏原始frame
    
    CGSize fullScreenBtnSize;
    CGSize exchangeBtnSize;
    NSInteger controlHeight;
    
    BOOL hasOrientation;
    //
    //清晰度选择按钮
    UIButton *definitionBtn;
    //创建返回按钮
    UIButton *returnButton;
    //弹幕按钮
    UIButton *commentButton;
    //顶部工具栏
    UIView *topControlView;
    //创建右侧详情按钮
    UIButton *detailButton;
    //仪表盘
    UILabel *indicator;
    //单击计时器
    NSTimer *singleTapTimer;
}
@end

@implementation LivePushViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    ////
    self.view.backgroundColor=[UIColor whiteColor];
    //    self.extendedLayoutIncludesOpaqueBars = YES;
    //    self.navigationController.navigationBar.translucent = NO;
    //    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
    //    self.title=@"视频";
    self.navigationController.navigationBar.barTintColor=StyleColor;
    //    self.navigationController.title=@"视频";
    [UIApplication sharedApplication].statusBarHidden=NO;

    //
    topBtnWidth=40;
    CGFloat topViewHeight=44;
    //
    //顶部工具栏栏
    topControlView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_RHEIGHT-50, topViewHeight)];
//    topControlView.backgroundColor=[UIColor yellowColor];
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] initWithCustomView:topControlView];
    self.navigationItem.leftBarButtonItem = returnButtonItem;
    //创建返回按钮
    returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0,topViewHeight-topBtnWidth-5,topBtnWidth,topBtnWidth)];
    [returnButton addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [returnButton setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    returnButton.backgroundColor=LiveBtnBackColor;
    [returnButton.layer setMasksToBounds:YES];
    [returnButton.layer setCornerRadius:returnButton.current_w/2];
    [topControlView addSubview:returnButton];
    
    //切换摄像头按钮
    switchBtn=[[UIButton alloc] initWithFrame:CGRectMake(returnButton.current_x_w+20, returnButton.current_y, topBtnWidth, topBtnWidth)];
    [switchBtn setImage:[UIImage imageNamed:@"cameraSwitch"] forState:UIControlStateNormal];
    switchBtn.backgroundColor=LiveBtnBackColor;
    [switchBtn.layer setMasksToBounds:YES];
    [switchBtn.layer setCornerRadius:switchBtn.current_w/2];
    [switchBtn addTarget:self action:@selector(switchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [topControlView addSubview:switchBtn];
    
    //打开闪光灯
    toggleTorchBtn=[[UIButton alloc] initWithFrame:CGRectMake(switchBtn.current_x_w+20, returnButton.current_y, topBtnWidth, topBtnWidth)];
    toggleTorchBtn.backgroundColor=[UIColor blueColor];
    [toggleTorchBtn setImage:[UIImage imageNamed:@"toggleTorch"] forState:UIControlStateNormal];
    toggleTorchBtn.backgroundColor=LiveBtnBackColor;
    [toggleTorchBtn.layer setMasksToBounds:YES];
    [toggleTorchBtn.layer setCornerRadius:toggleTorchBtn.current_w/2];
    [toggleTorchBtn addTarget:self action:@selector(toggleTorchOperation) forControlEvents:UIControlEventTouchUpInside];
    [topControlView addSubview:toggleTorchBtn];
    //清晰度选择按钮
    definitionBtn = [[UIButton alloc] initWithFrame:CGRectMake(toggleTorchBtn.current_x_w+20,toggleTorchBtn.current_y,topBtnWidth,topBtnWidth)];
    [definitionBtn addTarget:self action:@selector(changeVideoDefinition) forControlEvents:UIControlEventTouchUpInside];
    //    [definitionBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [definitionBtn setTitle:@"标清" forState:UIControlStateNormal];
    definitionBtn.backgroundColor=LiveBtnBackColor;
    [definitionBtn.layer setMasksToBounds:YES];
    [definitionBtn.layer setCornerRadius:definitionBtn.current_w/2];
    [topControlView addSubview:definitionBtn];
    definitionBtn.enabled=NO;
    //弹幕按钮
    commentButton = [[UIButton alloc] initWithFrame:CGRectMake(definitionBtn.current_x_w+20,definitionBtn.current_y,topBtnWidth,topBtnWidth)];
    [commentButton addTarget:self action:@selector(showComment) forControlEvents:UIControlEventTouchUpInside];
    //    [commentButton setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [commentButton setTitle:@"字幕" forState:UIControlStateNormal];
    commentButton.backgroundColor=LiveBtnBackColor;
    [commentButton.layer setMasksToBounds:YES];
    [commentButton.layer setCornerRadius:commentButton.current_w/2];
    [topControlView addSubview:commentButton];
    //时间电量信息
    UILabel *timeLabel=[[UILabel alloc] init];
    timeLabel.backgroundColor=[UIColor clearColor];
    timeLabel.textColor=[UIColor whiteColor];
    timeLabel.font=[UIFont systemFontOfSize:15.0];
    timeLabel.textAlignment=NSTextAlignmentRight;
    NSString *batteryStr=[NSString stringWithFormat:@"%d%",[MZTools getCurrentBatteryLevel]];
    timeLabel.text=[NSString stringWithFormat:@"时间:%@   电量:%@%% ",[MZTools getCurrentTime],batteryStr];
//    [topControlView addSubview:timeLabel];
//    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(topControlView);
//        make.width.equalTo(200);
//        make.height.equalTo(topViewHeight);
//        make.right.equalTo(topControlView).offset(-20);
//    }];
    ////
    indicator=[[UILabel alloc] initWithFrame:CGRectMake(commentButton.current_x_w+30,commentButton.current_y,120,topBtnWidth)];
//    indicator.backgroundColor=LiveBtnBackColor;
    indicator.textColor=[UIColor whiteColor];
    indicator.font=[UIFont systemFontOfSize:15.0];
    indicator.textAlignment=NSTextAlignmentCenter;
    [topControlView addSubview:indicator];
//    [indicator makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(100);
//        make.height.equalTo(40);
//        make.right.equalTo(bottomLiveView);
//        make.centerY.equalTo(bottomLiveView);
//    }];
    

//    if (_presentStyle==PresentModel) {
//        [self.view addSubview:topControlView];
//    }
    
    //初始化视图
    [self setUpView];
//    [self initLivePusher];
    //判断是否有权限访问相机
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status==AVAuthorizationStatusDenied) {
        [MZTools confirmAlertViewAboveVC:self Title:@"提示" Message:@"尚未开启相机权限,您可以去设置->隐私设置开启" ActionLeft:@"确定" ActionRight:@"取消" Yes:^{
            NSString *openString = @"Prefs:root=Privacy&path=CAMERA";
            NSURL *url = [NSURL URLWithString:openString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        } Cancle:^{
            
        }];
    }
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (audioStatus==AVAuthorizationStatusDenied) {
        [MZTools confirmAlertViewAboveVC:self Title:@"提示" Message:@"尚未开启麦克风权限,您可以去设置->隐私设置开启" ActionLeft:@"确定" ActionRight:@"取消" Yes:^{
            NSString *openString = @"Prefs:root=Privacy&path=MICROPHONE";
            NSURL *url = [NSURL URLWithString:openString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        } Cancle:^{
            
        }];
    }

    //初始化数据
    [self downloadDataViaNet];
}

-(void)setUpDataWithModel:(LiveRoomDetailModel *)model{
//    [introduceBtn setTitle:model.lessonSubject forState:UIControlStateNormal];
    ///
    [MZActivityIndicatorView loadingAnimationStart];
}
-(UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    /////
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)initLivePusherWithPushUrl:(NSString *)pushUrl{
    // 创建 LivePushConfig 对象，该对象默认初始化为基础配置
    
    _config = [[TXLivePushConfig alloc] init];
    // 300 为后台播放暂停图片的最长持续时间,单位是秒
    _config.pauseTime = 300;
    // 10 为后台播放暂停图片的帧率,最小值为5,最大值为20
    _config.pauseFps = 10;
    // 设置推流暂停时,后台播放的暂停图片, 图片最大尺寸不能超过1920*1920.
    _config.pauseImg = [UIImage imageNamed:@"PushPause.png"];
    //在 _config中您可以对推流的参数（如：美白，硬件加速，前后置摄像头等）做一些初始化操作，需要注意 _config不能为nil
    _config.enableHWAcceleration=YES;
    _config.homeOrientation=HOME_ORIENTATION_RIGHT;
    
    _txLivePush = [[TXLivePush alloc] initWithConfig: _config];
    _txLivePush.delegate=self;

    //
    [_txLivePush setRenderRotation:0];
    
    ////////
    [_txLivePush startPreview:liveView];  //_myView 就是step2中需要您指定的view
    
    [_txLivePush setVideoQuality:VIDEO_QUALITY_STANDARD_DEFINITION adjustBitrate:YES adjustResolution:NO];
//    [_txLivePush startPush:pushUrl];
 
}
-(void)setUpView{
    
    //初始化各部分视图原始尺寸
    //    smallWindow=CGRectMake(0, 0, Adapt(LiveSmallWindow_Size).width, Adapt(LiveSmallWindow_Size).height);
    //    largeWindow=CGRectMake(Adapt(LiveSmallWindow_Size).width, 0, SCREEN_HEIGHT-Adapt(LiveSmallWindow_Size).width, SCREEN_WIDTH);
//    fullScreenBtnSize=CGSizeMake(25, 25);
    largeWindow=CGRectMake(SCREEN_HEIGHT-SCREEN_WIDTH/3*4, 0, SCREEN_WIDTH/3*4, SCREEN_WIDTH);
    originalVideoViewFrame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/4*3);
    ///
    //创建底层承载视图
    bottomLiveView=[[UIView alloc] initWithFrame:originalVideoViewFrame];
    bottomLiveView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomLiveView];
    //    [self.view addSubview:returnButton];
//    originalIntroduceBtnFrame=CGRectMake(0, bottomLiveView.current_y_h, SCREEN_WIDTH/3,  30);
    ////
    liveView=[[UIView alloc] init];
    liveView.userInteractionEnabled=NO;
    [bottomLiveView addSubview:liveView];
    
    [liveView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomLiveView);
        make.width.equalTo(bottomLiveView);
        make.height.equalTo(bottomLiveView);
    }];
    //转圈加载
    activityIndView=[[MZActivityIndicatorView alloc] initWithFrame:originalVideoViewFrame];
    //    activityIndView.center=_vodplayer.mVideoView.center;
    activityIndView.center=CGPointMake(originalVideoViewFrame.size.width/2, originalVideoViewFrame.size.height/2);
    activityIndView.layer.cornerRadius=0;
    [liveView addSubview:activityIndView];
    //
    [activityIndView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(liveView);
        make.size.equalTo(liveView);
    }];
    
    ////////
    //indicator.hidden=YES;
    ///自定义控件 3m
    UIButton *switchBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [switchBtn addTarget:self action:@selector(switchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //    switchBtn
    
    //单击播放器视图
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [bottomLiveView addGestureRecognizer:singleTapGestureRecognizer];
    
    //创建问答视图
    originalQaViewFrame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _qaView=[[MZQaView alloc] initWithFrame:originalQaViewFrame];
    WeakObject(bottomLiveView, wBottom)
    
    [_qaView setPlayEnd:^(ReceiveAppSysMsg msg) {
        
        if (msg==AppSysMsg_NetPause){
            [MZTools showAlertHUD:@"网络连接异常" atView:wBottom withTime:2*HudPresentTime];
        }
    }];
    [self.view addSubview:_qaView];
    
    //控制条
    controlHeight=40;
    controlView =[[UIImageView alloc] init];
    controlView.backgroundColor=[UIColor clearColor];
    controlView.alpha=1;
    [bottomLiveView addSubview:controlView];//
    controlView.userInteractionEnabled=YES;
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomLiveView).offset(0);
        make.left.equalTo(bottomLiveView).offset(0);
        make.width.equalTo(bottomLiveView.width);
        make.height.equalTo(@40);
    }];
    
    //开始直播按钮
    startPushBtn=[[UIButton alloc] init];
    [startPushBtn setTitle:@"开始直播" forState:UIControlStateNormal];
    startPushBtn.backgroundColor=StyleColor;
    [startPushBtn addTarget:self action:@selector(startLivePush) forControlEvents:UIControlEventTouchUpInside];
    [bottomLiveView addSubview:startPushBtn];
    [startPushBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomLiveView);
        make.bottom.equalTo(bottomLiveView.mas_bottom).offset(-50);
        make.width.equalTo(150);
        make.height.equalTo(45);
    }];
    startPushBtn.hidden=YES;
    //
//    [self createTimer];
    //
//    [self rotationVideoView:1];
    self.navigationController.interactivePopGestureRecognizer.enabled=NO;
    hasOrientation = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        //            self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
        //            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        bottomLiveView.frame=CGRectMake(0, 0, SCREEN_RHEIGHT, SCREEN_RWIDTH);
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
        [_qaView changeToFullScreenMode:YES];
//        self.qaView.hidden=YES;
        detailButton.hidden=YES;
        topControlView.hidden=NO;
        self.navigationController.navigationBarHidden = NO;
        controlView.hidden=NO;
//        [self createTimer];
        
    }];
}

#pragma mark -- Network
-(void)downloadDataViaNet{
    
    [MZActivityIndicatorView loadingAnimationStartUpOnView:bottomLiveView];
//    NSString *urlStr=@"http://192.168.1.116:8091/appLive/getPushURL";
    NSString *urlStr=GetPushInfo;
//    [startPushBtn setTitle:@"正在开启.." forState:UIControlStateNormal];
//    NSMutableDictionary *paraDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys: @"07993c5f87c84d2cb99407bd38e357e7",@"id",@"258274203e0811e790d200163e3045c3",@"fkMemId", nil];
    NSMutableDictionary *paraDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys: _liveID,@"id",[UserInforModel shareUserInforModel].keyID,@"fkMemId", nil];

    [MZNetwork MZEMDPostRequest:urlStr Parameters:paraDic success:^(NSString *error, NSString *msg, id result) {
        MZLogErrorMsgResult(LiveLog);

        [MZActivityIndicatorView loadingAnimationStopOnView:bottomLiveView];
        
        if (error.integerValue==200) {
            pushUrl=[result objectForKey:@"pushURL"];
            NSString *groupId=[result objectForKey:@"GroupId"];
            NSString *userSign=[result objectForKey:@"usersig"];
            ////
            startPushBtn.hidden=NO;
            //            [_txLivePush startPush:pushUrl];
            //加入聊天室
            [_qaView initMessageHandlerWithGroupID:groupId UserSign:userSign Identifier:[UserInforModel shareUserInforModel].keyID];
        }
        else{
//            [startPushBtn setTitle:@"开始直播" forState:UIControlStateNormal];

            [MZTools confirmAlertViewAboveVC:self Title:@"提示" Message:msg ActionTitle:@"确定" Action:^{
                if (!XuanYanDebug) {
                    [self returnBack];
                }
//                [self returnBack];
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [startPushBtn setTitle:@"开始直播" forState:UIControlStateNormal];

        [MZActivityIndicatorView loadingAnimationStopOnView:bottomLiveView];
        [MZTools confirmAlertViewAboveVC:self Title:@"失败" Message:@"网络请求失败" ActionTitle:@"确定" Action:^{
            [self returnBack];
        }];
    }];
    
}

#pragma mark --开始进行推流

-(void)startLivePush{
//    [_txLivePush stopPush];
    [self initLivePusherWithPushUrl:pushUrl];
    
    [_txLivePush startPush:pushUrl];

    startPushBtn.hidden=YES;
    //打开正在直播状态标志
    [AdaptionData sharedAdaptionData].isLiving=YES;
    //转圈加载
    [activityIndView startAnimating];
//    [MZActivityIndicatorView loadingAnimationStartUpOnView:self.view];
}

#pragma mark --闪光灯
-(void)toggleTorchOperation{
    if(!_txLivePush.frontCamera) {
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (device.torchMode == AVCaptureTorchModeOff) {
            BOOL result = [_txLivePush toggleTorch: YES];
            if (result==NO) {
                [MZTools showAlertHUD:@"打开闪光灯失败" atView:bottomLiveView withTime:HudPresentTime];

            }
            //result为YES，打开成功;result为NO，打开失败
        }else{
            BOOL result = [_txLivePush toggleTorch: NO];
            if (result==NO) {
                [MZTools showAlertHUD:@"关闭闪光灯失败" atView:bottomLiveView withTime:HudPresentTime];
                
            }
            //result为YES，打开成功;result为NO，打开失败
        }
        
    }
}
#pragma mark --切换摄像头
-(void)switchBtnClicked{
    //    if (_txLivePush.frontCamera==YES) {
    //        [_txLivePush setRenderRotation:270];
    //
    //    }
    //    else{
    //        [_txLivePush setRenderRotation:270];
    //
    //    }
    // 默认是前置摄像头，可以通过修改 LivePushConfig 的配置项 frontCamera 来修改这个默认值
    [_txLivePush switchCamera];
    [self adjustWindow];

}
#pragma mark --单击播放器视图
-(void)singleTap:(UITapGestureRecognizer *)tapGestureRecognizer{
//    if (controlView.hidden==NO) {
//
//        //        fullScreenBtn.hidden=YES;
//        //        exchangeBtn.hidden=YES;
//        controlView.hidden=YES;
//        topControlView.hidden=YES;
//        [UIApplication sharedApplication].statusBarHidden=YES;
//
//        self.navigationController.navigationBarHidden = YES;
//
//    }
//    else{
//        //        fullScreenBtn.hidden=NO;
//        //        exchangeBtn.hidden=NO;
//        controlView.hidden=NO;
//        topControlView.hidden=NO;
//        [UIApplication sharedApplication].statusBarHidden=NO;
//
//        self.navigationController.navigationBarHidden = NO;
//
//        [self createTimer];
//    }
    //[self fullScreenBtnShow];
    [_qaView fatherViewTapped];
}
-(void)createTimer{
    if (singleTapTimer) {
        [singleTapTimer invalidate];
    }
    
    NSString *version = [UIDevice currentDevice].systemVersion;
    
    if (version.doubleValue >= 10.0) { // iOS系统版本 >= 10.0
        singleTapTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            controlView.hidden=YES;
            topControlView.hidden=YES;
            [UIApplication sharedApplication].statusBarHidden=YES;

            self.navigationController.navigationBarHidden = YES;
        }];
        
    } else{ //iOS系统版本 < 10.0
        singleTapTimer=[NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(timerOperation) userInfo:NULL repeats:YES];
        
    }    
}

-(void)timerOperation{
    controlView.hidden=YES;
    topControlView.hidden=YES;
    [UIApplication sharedApplication].statusBarHidden=YES;

    self.navigationController.navigationBarHidden = YES;
}
#pragma mark --弹幕
-(void)showComment{
    if (_qaView.isHidden==YES) {
        _qaView.hidden=NO;
    }
    else{
        _qaView.hidden=YES;
    }

}
#pragma mark --调节清晰度
-(void)changeVideoDefinition{

    /////
    [MZTools confirmAlertViewAboveVC:self Title:@"清晰度" Message:@"" ActionTitle1:@"标清" ActionTitle2:@"高清" ActionTitle3:@"超清" ActionTitle4:@"取消" Action1:^{
        //
        //
//        [_txLivePush stopPush];
        //
        
        //
        [definitionBtn setTitle:@"标清" forState:UIControlStateNormal];
        //
        [_txLivePush setVideoQuality:VIDEO_QUALITY_STANDARD_DEFINITION adjustBitrate:YES adjustResolution:NO];
        [_txLivePush startPush:pushUrl];
        
        [self adjustWindow];
        //
        [activityIndView startAnimating];
        
    } Action2:^{
        //
        //
//        [_txLivePush stopPush];
        //
        //
        [definitionBtn setTitle:@"高清" forState:UIControlStateNormal];
        //
        [_txLivePush setVideoQuality:VIDEO_QUALITY_HIGH_DEFINITION adjustBitrate:YES adjustResolution:NO];
        [_txLivePush startPush:pushUrl];
        [self adjustWindow];

        ///
        [activityIndView startAnimating];
        ///////
        
    } Action3:^{
//        [_txLivePush stopPush];
        //
        //
        [_txLivePush setVideoQuality:VIDEO_QUALITY_SUPER_DEFINITION adjustBitrate:YES adjustResolution:NO];
        [_txLivePush startPush:pushUrl];
        [self adjustWindow];

        //
        [definitionBtn setTitle:@"超清" forState:UIControlStateNormal];
        [activityIndView startAnimating];
        
    }Action4:^{
        
    }];
}
#pragma mark - videoView

#pragma mark --PlaySDK 回调方法
-(void) onPushEvent:(int)EvtID withParam:(NSDictionary*)param{
    NSLog(@"====%@======",param);
    NSLog(@"_txLivePush.config.homeOrientation: %d",_txLivePush.config.homeOrientation);
    if (EvtID==PUSH_EVT_PUSH_BEGIN) {
//        [MZActivityIndicatorView loadingAnimationStopOnView:self.view];
        [activityIndView stopAnimating];
        [self adjustWindow];
        
        startPushBtn.hidden=YES;
        definitionBtn.enabled=YES;
    }
    else if (EvtID==PUSH_EVT_CONNECT_SUCC){
        
        [activityIndView startAnimating];
        if (XuanYanDebug) {
            [MZTools showAlertHUD:@"已经连接推流服务器" atView:bottomLiveView withTime:HudPresentTime];
        }
    }
    else if (EvtID==PUSH_EVT_START_VIDEO_ENCODER){
        if (XuanYanDebug) {
            [MZTools showAlertHUD:@"启动编码器" atView:bottomLiveView withTime:HudPresentTime];
        }
    }
    else if (EvtID==PUSH_EVT_OPEN_CAMERA_SUCC){
        if (XuanYanDebug) {
            [MZTools showAlertHUD:@"打开摄像头成功" atView:bottomLiveView withTime:HudPresentTime];
        }
    }
    else if (EvtID==PUSH_ERR_OPEN_CAMERA_FAIL){
        if (XuanYanDebug) {
            [MZTools showAlertHUD:@"打开摄像头失败" atView:bottomLiveView withTime:HudPresentTime];
        }
    }
    else if (EvtID==PUSH_EVT_FIRST_FRAME_AVAILABLE){
        if (XuanYanDebug) {
            [MZTools showAlertHUD:@"首帧画面采集完成" atView:bottomLiveView withTime:HudPresentTime];
        }
    }
    else if (EvtID==PUSH_WARNING_RECONNECT){
        [MZTools showAlertHUD:@"网络断连, 已启动自动重连" atView:bottomLiveView withTime:HudPresentTime];
    }
    else if (EvtID==PUSH_ERR_NET_DISCONNECT){
//        [_txLivePush stopPush];
        [_txLivePush startPush:pushUrl];
        [activityIndView startAnimating];
        [MZTools showAlertHUD:@"网络断连超过3次, 视频重连" atView:bottomLiveView withTime:HudPresentTime];
    }
    else if (EvtID==PUSH_ERR_OPEN_MIC_FAIL){
        [MZTools showAlertHUD:@"打开麦克风失败" atView:bottomLiveView withTime:HudPresentTime];
    }
    else if (EvtID==PUSH_ERR_VIDEO_ENCODE_FAIL){
//        [_txLivePush stopPush];
        [MZTools showAlertHUD:@"视频重连" atView:bottomLiveView withTime:HudPresentTime];
        [_txLivePush startPush:pushUrl];
        [activityIndView startAnimating];

    }
    else if (EvtID==PUSH_ERR_AUDIO_ENCODE_FAIL){
//        [_txLivePush stopPush];
        
        [MZTools showAlertHUD:@"音频重连" atView:bottomLiveView withTime:HudPresentTime];
        [_txLivePush startPush:pushUrl];
        [activityIndView startAnimating];
//        [MZTools showAlertHUD:@"音频编码失败" atView:bottomLiveView withTime:HudPresentTime];
    }
    else if (EvtID==PUSH_ERR_UNSUPPORTED_RESOLUTION){
        [MZTools showAlertHUD:@"不支持的视频分辨率" atView:bottomLiveView withTime:HudPresentTime];
    }
    else if (EvtID==PUSH_WARNING_NET_BUSY){
        [MZTools showAlertHUD:@"您当前的网络状况不佳，推荐您离 WiFi 近一点" atView:bottomLiveView withTime:2*HudPresentTime];
    }
}
/**
 *
 *
 */
-(void) onNetStatus:(NSDictionary*) param{
    if (indicator) {
        indicator.text=[NSString stringWithFormat:@"%@ Kpbs",[param objectForKey:@"VIDEO_BITRATE"]];
    }
}
#pragma mark --屏幕旋转回调事件

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    ///
//    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight&&hasOrientation==NO) {
//    }
//    else if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft&&hasOrientation==NO){
//
//    }
//    else if (toInterfaceOrientation==UIInterfaceOrientationPortrait&&hasOrientation==YES){
//    }
    [self orientationToPortrait:UIInterfaceOrientationLandscapeRight];
}

#pragma mark --按钮点击事件
//
-(void)returnBack{
    /////
    if (_txLivePush.isPublishing) {
        /////
        LivePopView *quitPopView=[[LivePopView alloc] init];
        [quitPopView setViewCancle:^{
            ////
        }];
        [quitPopView setViewQuit:^{
            _txLivePush.config.homeOrientation=HOME_ORIENTATION_DOWN;
            [_txLivePush setRenderRotation:0];
            [self orientationToPortrait:UIInterfaceOrientationPortrait];
            
            //结束直播，即将销毁页面
            [self finishLivePush];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        [quitPopView showAlertView];
        ///
    }
    else{
        [self orientationToPortrait:UIInterfaceOrientationPortrait];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ////////////
    [self.navigationController.navigationBar  setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar  setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
    [self.navigationController.navigationBar  setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar  setTranslucent:YES];
    ///////////
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NaviBarBottomImage"] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [UIApplication sharedApplication].statusBarHidden=YES;
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NaviBarBottomImage"]forBarMetrics:UIBarMetricsDefault];
    //
    [UIApplication sharedApplication].idleTimerDisabled=YES;//不自动锁屏

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceOrientation" object:@"YES"];
    // 强制转为横屏
    [self orientationToPortrait:UIInterfaceOrientationLandscapeRight];
    ///
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:@"applicationWillResignActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:@"applicationDidBecomeActive" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    //退出聊天室
    [_qaView quitLiveChat];
    // 停止播放
    [_txLivePush stopPreview]; // 记得销毁view控件
    [_txLivePush stopPush];
    _txLivePush.delegate=nil;
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationWillResignActive" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationDidBecomeActive" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    //关闭正在直播状态标志
    [AdaptionData sharedAdaptionData].isLiving=NO;
    
    [singleTapTimer invalidate];
    
    [MZActivityIndicatorView loadingAnimationStop];
    [UIApplication sharedApplication].statusBarHidden=NO;
    [self.navigationController.navigationBar  setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    [UIApplication sharedApplication].idleTimerDisabled=NO;//自动锁屏
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceOrientation" object:@"NO"];
    ///
    [self orientationToPortrait:UIInterfaceOrientationPortrait];
}
-(void)applicationWillResignActive:(NSNotification *)notification{
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    }];
    [_txLivePush pausePush];
    if (_txLivePush.isPublishing) {
        [self livePushPause];
    }
}
-(void)applicationDidBecomeActive:(NSNotification *)notification{
//    if (_txLivePush) {
//        <#statements#>
//    }
//    [self livePushRecover];
    [_txLivePush resumePush];
    // 强制转为横屏
//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeRight] forKey:@"orientation"];
    [self adjustWindow];
}
#pragma mark -- 结束直播，发送系统通知
-(void)sendSystemMessageGroupID:(NSString *)groupId MsgCode:(NSString *)mmsgCode{
    [MZActivityIndicatorView loadingAnimationStart];
    //    NSString *urlStr=@"http://192.168.1.116:8091/appLive/getPushURL";
    NSString *urlStr=SendLiveChatRoomSysMessage;
    
    [MZTools showAlertHUD:[NSString stringWithFormat:@"发送直播系统通知%@",mmsgCode] atWindowWithTime:HudPresentTime];

    NSMutableDictionary *paraDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys: _qaView.groupId,@"groupId",mmsgCode,@"sysMsgCode", nil];
    
    [MZNetwork MZEMDPostRequest:urlStr Parameters:paraDic success:^(NSString *error, NSString *msg, id result) {
        MZLogErrorMsgResult(LiveLog);
        
        [MZActivityIndicatorView loadingAnimationStop];
        
        if (error.integerValue==200) {
            if (mmsgCode.integerValue==7001) {
                [MZTools showAlertHUD:@"已发送直播结束的系统通知" atWindowWithTime:2*HudPresentTime];
            }
            if (mmsgCode.integerValue==7002) {
                [MZTools showAlertHUD:@"已发送直播暂停的系统通知" atWindowWithTime:2*HudPresentTime];
            }
            if (mmsgCode.integerValue==7003) {
                [MZTools showAlertHUD:@"已发送直播恢复的系统通知" atWindowWithTime:HudPresentTime];
            }
        }
        else{
            [MZTools showAlertHUD:[NSString stringWithFormat:@"error:%@-%@",error,msg] atWindowWithTime:HudPresentTime];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MZActivityIndicatorView loadingAnimationStop];
        //        [MZTools confirmAlertViewAboveVC:self Title:@"失败" Message:@"网络请求失败" ActionTitle:@"确定" Action:^{
        //            [self returnBack];
        //        }];
    }];
}
-(void)livePushPause{
    [self sendSystemMessageGroupID:_qaView.groupId MsgCode:@"7003"];
    //
}
-(void)livePushRecover{
    [self sendSystemMessageGroupID:_qaView.groupId MsgCode:@"7002"];
    //
}
-(void)finishLivePush{
    [self sendSystemMessageGroupID:_qaView.groupId MsgCode:@"7001"];
}

- (void)dealloc {
    //退出聊天室
    [_qaView quitLiveChat];
    // 停止播放
    [_txLivePush stopPreview]; // 记得销毁view控件
    [_txLivePush stopPush];
    _txLivePush.delegate=nil;
    
}
-(void)adjustWindow{
    //
//    [self orientationToPortrait:UIInterfaceOrientationLandscapeRight];
//    UIWindow *keyboardWindow=nil;
//    UIWindow *keyWindow=[[UIApplication sharedApplication] keyWindow];
//    NSArray *windows=[[UIApplication sharedApplication] windows];
//    BOOL versionIOS9=[MZTools version:IOSVersion isGreaterThan:@"9.0"];
//
//    for (UIWindow *window in windows) {
//        if (versionIOS9) {
//            if ([NSStringFromClass([window class]) isEqualToString:@"UIRemoteKeyboardWindow"]) {
//                keyboardWindow=window;
//
//            }
//            break;
//        }
//        else{
//            if ([NSStringFromClass([window class]) isEqualToString:@"UITextEffectsWindow"]) {
//                keyboardWindow=window;
//            }
//            break;
//        }
//    }
//    keyboardWindow.transform=keyWindow.transform;
//    keyboardWindow.center=CGPointMake([[UIScreen mainScreen] bounds].size.width*0.5f,[[UIScreen mainScreen] bounds].size.height*0.5f);
//    keyboardWindow.bounds=keyWindow.bounds;
}

#warning 使用的时候需要注意, 不要在这个方法里发送停止自动旋转的通知, 应该在viewDidDisappear方法里发送

//强制旋转屏幕
- (void)orientationToPortrait:(UIInterfaceOrientation)orientation {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];//前两个参数已被target和selector占用
    [invocation invoke];
    
}

-(BOOL)shouldAutorotate{
    return YES;

}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{

    return UIInterfaceOrientationMaskLandscapeRight;
//    return UIInterfaceOrientationMaskLandscape;
    //只支持这一个方向(正常的方向)
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

@end










