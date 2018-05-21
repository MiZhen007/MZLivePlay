//
//  LivePlayViewController.m
//  XuanYan
//
//  Created by mz on 2017/11/2.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import "LivePlayViewController.h"

@interface LivePlayViewControlle (){
    //
    NSString *pullUrl;
    //播放模式/清晰度 0:音频。1：普清，2：高清，3：超清
    NSInteger videoDefinition;
    /////
    //承载直播的底层视图
    UIView *bottomLiveView;
    //重新连接按钮蒙板
    UIView *refreshBottomView;
    
    UIButton *refreshBtn;
    
    //播放渲染会视图
    UIView *liveView;
    //加载转圈
    MZActivityIndicatorView *activityIndView;
    //中断提示视图
//    UILabel *pushPauseTipView;
    //音频图
    UIImageView *audioPlayView;
    //创建介绍栏
    UIButton *introduceBtn;
    //音频模式切换
    UIButton *audioBtn;
    //全屏按钮
    UIButton *fullScreenBtn;
    //切换按钮
    UIButton *exchangeBtn;
    //控制条
    UIImageView *controlView;
    
    CGRect smallWindow;
    CGRect originalVideoViewFrame;//记录videoView的原始尺寸
    CGRect originalQaViewFrame;//记录问答视图的原始尺寸
    CGRect largeWindow;//转屏后的大窗口frame
    CGRect subWindow; //转屏后侧栏的大小
    
    CGRect originalIntroduceBtnFrame;//记录简介栏原始frame
    
    CGSize fullScreenBtnSize;
    CGSize exchangeBtnSize;
    NSInteger controlHeight;
    
    BOOL hasOrientation;
    //顶部工具栏
    UIView *topControlView;
    //创建返回按钮
    UIButton *returnButton;
    //清晰度选择按钮
    UIButton *definitionBtn;
    //字幕按钮
    UIButton *commentButton;
    //创建右侧详情按钮
    UIButton *detailButton;
    //仪表盘
    UILabel *indicator;
    //单击计时器
    NSTimer *singleTapTimer;
    //
}
@property(nonatomic,strong)UILabel *pushPauseTipView;    //中断提示视图

@end

@implementation LivePlayViewControlle
@synthesize pushPauseTipView;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor whiteColor];
    //    self.extendedLayoutIncludesOpaqueBars = YES;
    //    self.navigationController.navigationBar.translucent = NO;
    //    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
    //    self.title=@"视频";
    self.navigationController.navigationBar.barTintColor=StyleColor;
    //    self.navigationController.title=@"视频";
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //
    CGFloat topBtnWidth=40;
    CGFloat topViewHeight=44;
    
    //顶部工具栏栏
    topControlView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_RHEIGHT-50, topViewHeight)];
    topControlView.userInteractionEnabled=YES;
    ////////
//    if ([MZTools version:IOSVersion isGreaterThan:@"11.0"]) {
//        topControlView.frame=CGRectMake(0, -25, SCREEN_RHEIGHT-50, topViewHeight);
//    }
    //创建返回按钮
    returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0,topViewHeight-topBtnWidth-5,topBtnWidth,topBtnWidth)];
    
    [returnButton addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [returnButton setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    returnButton.backgroundColor=LiveBtnBackColor;
    [returnButton.layer setMasksToBounds:YES];
    [returnButton.layer setCornerRadius:returnButton.current_w/2];
    [topControlView addSubview:returnButton];
//    [returnButton makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(topBtnWidth);
//        make.height.equalTo(topBtnWidth);
//        make.left.equalTo(0);
//        make.centerY.equalTo(topControlView);
//    }];
    //清晰度选择按钮
    definitionBtn = [[UIButton alloc] initWithFrame:CGRectMake(returnButton.current_x_w+30,returnButton.current_y,topBtnWidth,topBtnWidth)];
    [definitionBtn addTarget:self action:@selector(changeVideoDefinition) forControlEvents:UIControlEventTouchUpInside];
//    [definitionBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [definitionBtn setTitle:@"普清" forState:UIControlStateNormal];
    definitionBtn.backgroundColor=LiveBtnBackColor;
    [definitionBtn.layer setMasksToBounds:YES];
    [definitionBtn.layer setCornerRadius:definitionBtn.current_w/2];
    [topControlView addSubview:definitionBtn];
//    [definitionBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(topBtnWidth);
//        make.height.equalTo(topBtnWidth);
//        make.left.equalTo(returnButton.mas_right).offset(30);
//        make.centerY.equalTo(topControlView);
//    }];
    definitionBtn.hidden=YES;
    //弹幕按钮
    commentButton = [[UIButton alloc] initWithFrame:CGRectMake(definitionBtn.current_x_w+20,definitionBtn.current_y,topBtnWidth,topBtnWidth)];
    [commentButton addTarget:self action:@selector(showComment) forControlEvents:UIControlEventTouchUpInside];
    //    [commentButton setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    [commentButton setTitle:@"字幕" forState:UIControlStateNormal];
    commentButton.backgroundColor=LiveBtnBackColor;
    [commentButton.layer setMasksToBounds:YES];
    [commentButton.layer setCornerRadius:commentButton.current_w/2];
    [topControlView addSubview:commentButton];
    commentButton.hidden=YES;
    //
    indicator=[[UILabel alloc] initWithFrame:CGRectMake(commentButton.current_x_w+30,commentButton.current_y,120,topBtnWidth)];
    //    indicator.backgroundColor=LiveBtnBackColor;
    indicator.textColor=[UIColor whiteColor];
    indicator.font=[UIFont systemFontOfSize:15.0];
    indicator.textAlignment=NSTextAlignmentCenter;
    [topControlView addSubview:indicator];
    
//    [indicator makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(120);
//        make.height.equalTo(40);
//        make.left.equalTo(definitionBtn.mas_right).offset(80);
//        make.centerY.equalTo(topControlView);
//    }];
    //
    indicator.hidden=YES;
    //时间电量信息
//    UILabel *timeLabel=[[UILabel alloc] init];
//    timeLabel.backgroundColor=[UIColor clearColor];
//    timeLabel.textColor=[UIColor whiteColor];
//    timeLabel.font=[UIFont systemFontOfSize:15.0];
//    timeLabel.textAlignment=NSTextAlignmentRight;
//    NSString *batteryStr=[NSString stringWithFormat:@"%d%",[MZTools getCurrentBatteryLevel]];
//    timeLabel.text=[NSString stringWithFormat:@"时间:%@   电量:%@%% ",[MZTools getCurrentTime],batteryStr];
//    [topControlView addSubview:timeLabel];
//    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(topControlView);
//        make.width.equalTo(200);
//        make.height.equalTo(topViewHeight);
//        make.right.equalTo(topControlView).offset(100);
//    }];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:topControlView];
//    self.navigationItem.leftBarButtonItem = returnButtonItem;
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] initWithCustomView:topControlView];
    self.navigationItem.leftBarButtonItem = returnButtonItem;

    [self setUpView];
    //
}

-(void)setUpDataWithModel:(LiveRoomDetailModel *)model{
    [introduceBtn setTitle:model.lessonSubject forState:UIControlStateNormal];

    [MZActivityIndicatorView loadingAnimationStart];
}

-(UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)setUpView{
    
    //初始化各部分视图原始尺寸
    smallWindow=CGRectMake(0, 0, Adapt(LiveSmallWindow_Size).width, Adapt(LiveSmallWindow_Size).height);
    //    largeWindow=CGRectMake(Adapt(LiveSmallWindow_Size).width, 0, SCREEN_HEIGHT-Adapt(LiveSmallWindow_Size).width, SCREEN_WIDTH);
    subWindow=CGRectMake(0, SCREEN_WIDTH-SCREEN_WIDTH/2, 200, SCREEN_WIDTH/2);
    fullScreenBtnSize=CGSizeMake(35, 35);
    largeWindow=CGRectMake(SCREEN_HEIGHT-SCREEN_WIDTH/3*4, 0, SCREEN_WIDTH/3*4, SCREEN_WIDTH);
    originalVideoViewFrame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9);
    //
    //创建底层承载视图
    bottomLiveView=[[UIView alloc] initWithFrame:originalVideoViewFrame];
    bottomLiveView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomLiveView];
    //    [self.view addSubview:returnButton];
    originalIntroduceBtnFrame=CGRectMake(0, bottomLiveView.current_y_h, SCREEN_WIDTH/3,  30);
    //
    ////
    liveView=[[UIView alloc] init];
    liveView.userInteractionEnabled=NO;
    [bottomLiveView addSubview:liveView];
    
    [liveView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomLiveView);
        make.width.equalTo(bottomLiveView);
        make.height.equalTo(bottomLiveView);
    }];
    //音频播放图
    audioPlayView=[[UIImageView alloc] initWithFrame:CGRectZero];
    [audioPlayView setImage:[UIImage imageNamed:@"AudioPlayBgi"]];
    [bottomLiveView addSubview:audioPlayView];
    [audioPlayView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomLiveView);
        make.width.equalTo(bottomLiveView);
        make.height.equalTo(bottomLiveView);
    }];
    audioPlayView.hidden=YES;
    //视频中断提示视图
    pushPauseTipView=[[UILabel alloc] initWithFrame:CGRectZero];
    pushPauseTipView.textAlignment=NSTextAlignmentCenter;
    pushPauseTipView.backgroundColor=[UIColor colorWithWhite:0.2 alpha:0.3];
    [pushPauseTipView setFont:[UIFont systemFontOfSize:18.0]];
    pushPauseTipView.textColor=[UIColor whiteColor];
    pushPauseTipView.text=@"主播暂时离开啦...稍等";
    [bottomLiveView addSubview:pushPauseTipView];
    [pushPauseTipView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomLiveView);
        make.width.equalTo(bottomLiveView);
        make.height.equalTo(bottomLiveView);
    }];
    pushPauseTipView.hidden=YES;
   
    //转圈加载
    activityIndView=[[MZActivityIndicatorView alloc] initWithFrame:originalVideoViewFrame];
    //    activityIndView.center=_vodplayer.mVideoView.center;
    [activityIndView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndView.center=CGPointMake(originalVideoViewFrame.size.width/2, originalVideoViewFrame.size.height/2);
    activityIndView.layer.cornerRadius=0;
    [liveView addSubview:activityIndView];
    [activityIndView startAnimating];
    //
    [activityIndView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(liveView);
        make.size.equalTo(liveView);
    }];
    //创建视频直播播放器
    //////////
    _txLivePlayer = [[TXLivePlayer alloc] init];
    _txLivePlayer.delegate=self;
    //用 setupVideoWidget 给播放器绑定决定渲染区域的view，其首个参数 frame 在 1.5.2 版本后已经被废弃
    [_txLivePlayer setupVideoWidget:liveView.frame containView:liveView insertIndex:0];
    ////////////////////、
    _config = [[TXLivePlayConfig alloc] init];
    //自动模式
    _config.bAutoAdjustCacheTime   = YES;
    _config.minAutoAdjustCacheTime = 1;
    _config.maxAutoAdjustCacheTime = 5;
    ///
    //    //极速模式
    //    _config.bAutoAdjustCacheTime   = YES;
    //    _config.minAutoAdjustCacheTime = 1;
    //    _config.maxAutoAdjustCacheTime = 1;
    //    //流畅模式
    //    _config.bAutoAdjustCacheTime   = NO;
    //    _config.cacheTime              = 5;
    //
    [_txLivePlayer setConfig:_config];
    //
//    NSString* flvUrl = @"http://10596.liveplay.myqcloud.com/live/10596_4b8fa9999b.flv";
//    [_txLivePlayer startPlay:flvUrl type:PLAY_TYPE_LIVE_FLV];
    /////
    [_txLivePlayer setRenderRotation:90];
    /////
    //单击播放器视图
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [bottomLiveView addGestureRecognizer:singleTapGestureRecognizer];
    
    //创建介绍栏
    introduceBtn=[[UIButton alloc] initWithFrame:originalIntroduceBtnFrame];
    [introduceBtn setTitle:@"直播" forState:UIControlStateNormal];
    [introduceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    introduceBtn.titleLabel.numberOfLines=1;
    introduceBtn.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    introduceBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    introduceBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [self.view addSubview:introduceBtn];
    //创建问答视图
    originalQaViewFrame=CGRectMake(0, introduceBtn.current_y, SCREEN_WIDTH, SCREEN_HEIGHT-bottomLiveView.current_h-introduceBtn.current_h+introduceBtn.current_h);
    //
    _qaView=[[MZQaView alloc] initWithFrame:originalQaViewFrame];
//    [_qaView joinLiveRoom:@"QZ030103" handler:^(int handle) {
//        
//    }];
    _qaView.currentCountLb.hidden=YES;
    [self.view addSubview:_qaView];
    ///
//    WS(weakSelf);
    ///
    WeakObj(pushPauseTipView, weakTipView)
    WeakObj(pullUrl, wPullUrl)
    WeakObj(_txLivePlayer, wPlayer)
    WeakObj(definitionBtn, wBtn)
    WeakObj(activityIndView, wIndView)
    WeakObj(bottomLiveView, wBottom)
    ////
//    [_qaView setInforViewClicked:^{
//        [weakSelf liveDetail];
//    }];
    [_qaView setPlayEnd:^(ReceiveAppSysMsg msg) {
        ///////
        if (msg==AppSysMsg_PushPause) {
            weakTipView.hidden=NO;

        }
        else if (msg==AppSysMsg_PushRecover){
            weakTipView.hidden=YES;

            [wPlayer stopPlay];
            //
            NSString *realPullUrl=[wPullUrl stringByAppendingString:@"_550"];
            //
            videoDefinition=1;

            [wPlayer startPlay:realPullUrl type:PLAY_TYPE_LIVE_RTMP];
            //
            [wBtn setTitle:@"普清" forState:UIControlStateNormal];
            //
            [wIndView startAnimating];
        }
        else if (msg==AppSysMsg_NetPause){
            [MZTools showAlertHUD:@"网络连接异常" atView:wBottom withTime:2*HudPresentTime];
        }
    }];
    //控制条
    controlHeight=40;
    controlView =[[UIImageView alloc] init];
    controlView.backgroundColor=[UIColor clearColor];
    [controlView setImage:[UIImage imageNamed:@"controlBackImg.png"]];
    controlView.alpha=1;
    [bottomLiveView addSubview:controlView];//
    controlView.userInteractionEnabled=YES;
    
    //
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomLiveView).offset(0);
        make.left.equalTo(bottomLiveView).offset(0);
        make.width.equalTo(bottomLiveView.width);
        make.height.equalTo(@40);
    }];
    //
//    UIView *controlBackView=[[UIView alloc] init];
//    controlBackView.backgroundColor=[UIColor blackColor];
//    controlBackView.alpha=0.45;
//    controlBackView.userInteractionEnabled=YES;
//    [controlView addSubview:controlBackView];
//    [controlBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(controlView).offset(0);
//        make.left.equalTo(controlView).offset(0);
//        make.width.equalTo(controlView);
//        make.height.equalTo(controlView);
//    }];
    //音频模式
    audioBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-fullScreenBtnSize.height-10,SCREEN_HEIGHT/2-fullScreenBtnSize.width-10, fullScreenBtnSize.width, fullScreenBtnSize.width)];
    audioBtn.alpha=0.9;
    
    [audioBtn setImage:[UIImage imageNamed:@"AudioPlayIcon"] forState:UIControlStateNormal];
    
    [audioBtn addTarget:self action:@selector(swithAudioPlayMode) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:audioBtn];
    [audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(controlView);
        make.right.equalTo(bottomLiveView).offset(-20-fullScreenBtnSize.width);
        make.width.equalTo(fullScreenBtnSize.width);
        make.height.equalTo(fullScreenBtnSize.width);
    }];
    //全屏按钮
    fullScreenBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-fullScreenBtnSize.height-10,SCREEN_HEIGHT/2-fullScreenBtnSize.width-10, fullScreenBtnSize.width, fullScreenBtnSize.width)];
    fullScreenBtn.alpha=0.9;

    [fullScreenBtn setImage:[UIImage imageNamed:@"FullScreen"] forState:UIControlStateNormal];
    //    fullScreenBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,fullScreenBtnSize.width,fullScreenBtnSize.width);
    //_fullScreenBtn.backgroundColor=[UIColor yellowColor];
    [fullScreenBtn addTarget:self action:@selector(fullScreenClick:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:fullScreenBtn];
    [fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(controlView);
        make.right.equalTo(bottomLiveView).offset(-10);
        make.width.equalTo(fullScreenBtnSize.width);
        make.height.equalTo(fullScreenBtnSize.width);
    }];
    //////
    refreshBottomView=[[UIView alloc] initWithFrame:bottomLiveView.frame];
    refreshBottomView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
    refreshBottomView.userInteractionEnabled=NO;
    [bottomLiveView addSubview:refreshBottomView];
    refreshBottomView.hidden=YES;
    [refreshBottomView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(bottomLiveView);
        make.height.equalTo(bottomLiveView);
        make.center.equalTo(bottomLiveView);
    }];
    
    refreshBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    [refreshBtn.layer setMasksToBounds:YES];
    [refreshBtn.layer setCornerRadius:10];
    [refreshBtn addTarget:self action:@selector(repullVideoData) forControlEvents:UIControlEventTouchUpInside];
    [refreshBtn.layer setBorderColor:[UIColor redColor].CGColor];
    [refreshBtn.layer setBorderWidth:2.0];
    [refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refreshBtn setTitle:@"刷新" forState: UIControlStateNormal];
    [self.view addSubview:refreshBtn];
    refreshBtn.hidden=YES;
    [refreshBtn makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomLiveView);
        make.width.equalTo(@120);
        make.height.equalTo(@40);
        
    }];
    ////////
    //
    [self createTimer];
    //
    [self downloadDataViaNet];
    //
}
#pragma mark -- 刷新拉流数据
-(void)repullVideoData{
    [_txLivePlayer stopPlay];
    videoDefinition=1;

    [_txLivePlayer startPlay:[pullUrl stringByReplacingOccurrencesOfString:@"?" withString:@"_550?"] type:PLAY_TYPE_LIVE_RTMP];
    refreshBottomView.hidden=YES;
    refreshBtn.hidden=YES;
    [definitionBtn setTitle:@"普清" forState:UIControlStateNormal];

    [activityIndView startAnimating];
}
#pragma mark -- Network
-(void)downloadDataViaNet{
    //
    [MZActivityIndicatorView loadingAnimationStart];
    NSString *urlStr=GetPullInfo;
//    NSMutableDictionary *paraDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"07993c5f87c84d2cb99407bd38e357e7",@"id",[UserInforModel shareUserInforModel].keyID,@"memId", nil];
    NSMutableDictionary *paraDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys: _liveID,@"id",[UserInforModel shareUserInforModel].keyID,@"memId", nil];
    
//////////////////////////////
    [MZNetwork MZEMDPostRequest:urlStr Parameters:paraDic success:^(NSString *error, NSString *msg, id result) {
        MZLogErrorMsgResult(LiveLog);
        ////
        [MZActivityIndicatorView loadingAnimationStop];
        ////
        if (error.integerValue==200) {
            NSString *playUrl=[result objectForKey:@"playURL"];
            NSString *groupId=[result objectForKey:@"GroupId"];
            NSString *userSign=[result objectForKey:@"usersig"];
            //开始直播播放
            pullUrl=playUrl;
            //开始普清播放
            videoDefinition=1;

            [_txLivePlayer startPlay:[pullUrl stringByReplacingOccurrencesOfString:@"?" withString:@"_550?"] type:PLAY_TYPE_LIVE_RTMP];
            //加入聊天室
            [_qaView initMessageHandlerWithGroupID:groupId UserSign:userSign Identifier:[UserInforModel shareUserInforModel].keyID];
            //刷新信息
            [_qaView getLivePlayDetail:_liveID];
        }
        ////
        else{
            [MZTools confirmAlertWithTitle:@"提示" Message:msg Yes:^{
                
            }];
            /////
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MZActivityIndicatorView loadingAnimationStop];
        [MZTools confirmAlertViewAboveVC:self Title:@"失败" Message:@"网络请求失败" ActionTitle:@"确定" Action:^{
            [self returnBack];
        }];
    }];
}

#pragma mark --单击播放器视图
-(void)singleTap:(UITapGestureRecognizer *)tapGestureRecognizer{
    if (controlView.hidden==NO) {
        
        //        fullScreenBtn.hidden=YES;
        //        exchangeBtn.hidden=YES;
        controlView.hidden=YES;
        
        //[self.navigationController.navigationBar  setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
       
        [UIApplication sharedApplication].statusBarHidden=YES;

        self.navigationController.navigationBarHidden = YES;
        
    }
    else{
        //        fullScreenBtn.hidden=NO;
        //        exchangeBtn.hidden=NO;
        controlView.hidden=NO;
        self.navigationController.navigationBarHidden = NO;

        [UIApplication sharedApplication].statusBarHidden=NO;

        
        [self createTimer];
    }
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
            [UIApplication sharedApplication].statusBarHidden=YES;

            self.navigationController.navigationBarHidden = YES;
        }];
        
    } else{ //iOS系统版本 < 10.0
        singleTapTimer=[NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(timerOperation) userInfo:NULL repeats:YES];
        
    }
    
}

-(void)timerOperation{
    controlView.hidden=YES;
    [UIApplication sharedApplication].statusBarHidden=YES;

    self.navigationController.navigationBarHidden = YES;
}

#pragma mark --视频播放器底部按钮响应方法
-(void)swithAudioPlayMode{
    //
    if (videoDefinition!=0) {
        NSString *realPullUrl=[pullUrl stringByReplacingOccurrencesOfString:@"?" withString:@"_100?"];
        //
        [_txLivePlayer stopPlay];
        ///
        videoDefinition=0;
        [_txLivePlayer startPlay:realPullUrl type:PLAY_TYPE_LIVE_RTMP];
        ////
        [audioBtn setImage:[UIImage imageNamed:@"VideoPlayIcon"] forState:UIControlStateNormal];
        ////
    }
    else{
        NSString *realPullUrl=[pullUrl stringByReplacingOccurrencesOfString:@"?" withString:@"_550?"];
        //
        [_txLivePlayer stopPlay];
        //
        audioPlayView.hidden=YES;
        videoDefinition=1;
        [_txLivePlayer startPlay:realPullUrl type:PLAY_TYPE_LIVE_RTMP];
        [audioBtn setImage:[UIImage imageNamed:@"AudioPlayIcon"] forState:UIControlStateNormal];

    }
    //
    [activityIndView startAnimating];
    ///
}
-(void)fullScreenClick:(UIButton *)button{
    [self rotationVideoView:1];
}
#pragma mark --字幕
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
    
    __block NSString *realPullUrl;
    [MZTools confirmAlertViewAboveVC:self Title:@"清晰度" Message:@"" ActionTitle1:@"普清" ActionTitle2:@"高清" ActionTitle3:@"超清" ActionTitle4:@"取消" Action1:^{
        /////
        realPullUrl=[pullUrl stringByReplacingOccurrencesOfString:@"?" withString:@"_550?"];
        ////
        [_txLivePlayer stopPlay];
        //////
        videoDefinition=1;
        audioPlayView.hidden=YES;
        /////
        [_txLivePlayer startPlay:realPullUrl type:PLAY_TYPE_LIVE_RTMP];
        //////
        [definitionBtn setTitle:@"普清" forState:UIControlStateNormal];
        [activityIndView startAnimating];

    } Action2:^{
        realPullUrl=[pullUrl stringByReplacingOccurrencesOfString:@"?" withString:@"_900?"];
        [_txLivePlayer stopPlay];
        //
        audioPlayView.hidden=YES;

        videoDefinition=2;
        [_txLivePlayer startPlay:realPullUrl type:PLAY_TYPE_LIVE_RTMP];
        //
        [definitionBtn setTitle:@"高清" forState:UIControlStateNormal];
        [activityIndView startAnimating];

    } Action3:^{
        realPullUrl=[pullUrl stringByReplacingOccurrencesOfString:@"?" withString:@"_1200?"];
        [_txLivePlayer stopPlay];
        //
        [_txLivePlayer startPlay:realPullUrl type:PLAY_TYPE_LIVE_RTMP];
        //
        audioPlayView.hidden=YES;

        videoDefinition=3;
        [definitionBtn setTitle:@"超清" forState:UIControlStateNormal];
        [activityIndView startAnimating];

    }Action4:^{
        
    }];
//    [_txLivePlayer resume];
//    [_txLivePlayer startPlay:pullUrl type:PLAY_TYPE_LIVE_RTMP];
    //
}

#pragma mark - videoView
-(void)rotationVideoView:(NSInteger )manual{
    [self.view endEditing:YES];//收起键盘
    
    //强制旋转
    if (!hasOrientation) {
        self.zf_interactivePopDisabled=YES;
        self.navigationController.interactivePopGestureRecognizer.enabled=NO;
        hasOrientation = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            if (manual) {
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
            }//
            
            //            self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
            //            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            bottomLiveView.frame=CGRectMake(0, 0, SCREEN_RHEIGHT, SCREEN_RWIDTH);

            //            [self updateViewConstraints];
            
//            introduceBtn.frame=subWindow;
//            introduceBtn.titleLabel.numberOfLines=0;
//            introduceBtn.titleLabel.lineBreakMode=NSLineBreakByCharWrapping;
//            introduceBtn.backgroundColor=[UIColor blackColor];
//            [introduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            _qaView.frame=subWindow;
            [_qaView changeToFullScreenMode:YES];
            
//            exchangeBtn.frame=CGRectMake(largeWindow.origin.x+10, controlHeight-fullScreenBtnSize.height-10, exchangeBtnSize.width, exchangeBtnSize.height);
            
//            self.qaView.hidden=YES;
            detailButton.hidden=YES;
            
            [UIApplication sharedApplication].statusBarHidden=NO;
            self.navigationController.navigationBarHidden = NO;
            controlView.hidden=NO;
            [self createTimer];
            //
            [fullScreenBtn setImage:[UIImage imageNamed:@"ShrinkScreen"] forState:UIControlStateNormal];
            //
            definitionBtn.hidden=NO;
            commentButton.hidden=NO;
            indicator.hidden=NO;
        }];
    } else {
        
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        self.zf_interactivePopDisabled=NO;

        self.navigationController.interactivePopGestureRecognizer.enabled=YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformInvert(CGAffineTransformMakeRotation(0));
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            //[bottomLiveView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
            bottomLiveView.frame=originalVideoViewFrame;
//            introduceBtn.frame=originalIntroduceBtnFrame;
//            introduceBtn.titleLabel.numberOfLines=1;
//            introduceBtn.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
//            introduceBtn.backgroundColor=LightBackgroundColor;
//            [introduceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
//            _qaView.frame=originalQaViewFrame;
            [_qaView changeToFullScreenMode:NO];
//            exchangeBtn.frame=CGRectMake(originalVideoViewFrame.origin.x+10, controlHeight-fullScreenBtnSize.height-10, exchangeBtnSize.width, exchangeBtnSize.height);
            _qaView.hidden=NO;

            hasOrientation = NO;
            //self.chatView.hidden = NO;
//            self.docView.hidden=NO;
//            self.qaView.hidden=NO;
            detailButton.hidden=NO;
            [UIApplication sharedApplication].statusBarHidden=NO;
            self.navigationController.navigationBarHidden = NO;
            controlView.hidden=NO;
            [self createTimer];
            
            [fullScreenBtn setImage:[UIImage imageNamed:@"FullScreen"] forState:UIControlStateNormal];
            //复位清晰度
            definitionBtn.hidden=YES;
            commentButton.hidden=YES;
            indicator.hidden=YES;

//            //自动模式
//            _config.bAutoAdjustCacheTime   = YES;
//            _config.minAutoAdjustCacheTime = 1;
//            _config.maxAutoAdjustCacheTime = 5;
//            //
//            [definitionBtn setTitle:@"自动" forState:UIControlStateNormal];
//            [_txLivePlayer setConfig:_config];
//            [_txLivePlayer resume];
        }];
    }
}
#pragma mark --PlaySDK 回调方法

-(void) onPlayEvent:(int)EvtID withParam:(NSDictionary*)param{
    ///
    if (XuanYanDebug) {
        [MZTools showAlertHUD:[NSString stringWithFormat:@"EvtID:%d,%@",EvtID,[param objectForKey:@"EVT_MSG"]] atView:bottomLiveView withTime:HudPresentTime];
    }
    if (EvtID==PLAY_EVT_RTMP_STREAM_BEGIN) {
        //live begins playling....
        [activityIndView stopAnimating];
        refreshBottomView.hidden=YES;
        refreshBtn.hidden=YES;
    }
    if (EvtID==PLAY_EVT_PLAY_BEGIN) {
        //live begins playling....
        [activityIndView stopAnimating];
        refreshBottomView.hidden=YES;
        refreshBtn.hidden=YES;
        pushPauseTipView.hidden=YES;
        // 判断音视频模式
        if (videoDefinition!=0) {
            audioPlayView.hidden=YES;
            [audioBtn setImage:[UIImage imageNamed:@"AudioPlayIcon"] forState:UIControlStateNormal];

        }
        else{
            audioPlayView.hidden=NO;
        }
    }
    else if (EvtID==PLAY_EVT_PLAY_END){
//        [MZTools showAlertHUD:@"视频播放结束" atView:bottomLiveView withTime:HudPresentTime];
        [MZTools confirmAlertWithTitle:@"" Message:@"视频播放结束" Yes:^{
            
        }];
    }
//    else if (EvtID==PLAY_EVT_RTMP_STREAM_BEGIN){
//        refreshBottomView.hidden=YES;
//        [activityIndView startAnimating];
//    }
    else if (EvtID==PLAY_ERR_NET_DISCONNECT){
        pushPauseTipView.hidden=YES;
        refreshBottomView.hidden=NO;
        refreshBtn.hidden=NO;
        [activityIndView stopAnimating];

    }
    else if (EvtID==PLAY_WARNING_RECONNECT){
//        [MZTools showAlertHUD:@"网络断连, 已启动自动重连" atView:bottomLiveView withTime:HudPresentTime];
        [activityIndView startAnimating];

    }
    else if (EvtID==PUSH_ERR_OPEN_MIC_FAIL){
        [MZTools showAlertHUD:@"打开麦克风失败" atView:bottomLiveView withTime:HudPresentTime];
    }
    else if (EvtID==PUSH_ERR_VIDEO_ENCODE_FAIL){
//        [MZTools showAlertHUD:@"视频编码失败" atView:bottomLiveView withTime:HudPresentTime];
        //
        [activityIndView startAnimating];

        [_txLivePlayer stopPlay];
        //
        videoDefinition=1;
        [audioBtn setImage:[UIImage imageNamed:@"AudioPlayIcon"] forState:UIControlStateNormal];

        [definitionBtn setTitle:@"普清" forState:UIControlStateNormal];

        [_txLivePlayer startPlay:[pullUrl stringByReplacingOccurrencesOfString:@"?" withString:@"_550?"] type:PLAY_TYPE_LIVE_RTMP];
    }
    else if (EvtID==PUSH_ERR_AUDIO_ENCODE_FAIL){
//        [MZTools showAlertHUD:@"音频编码失败" atView:bottomLiveView withTime:HudPresentTime];
    }
    else if (EvtID==PUSH_ERR_UNSUPPORTED_RESOLUTION){
        [MZTools showAlertHUD:@"不支持的视频分辨率" atView:bottomLiveView withTime:HudPresentTime];
    }

}

-(void) onNetStatus:(NSDictionary*) param{
    if (indicator) {
        
        indicator.text=[NSString stringWithFormat:@"%@ Kbps",[param objectForKey:@"VIDEO_BITRATE"]];
        if (videoDefinition==0) {//如果是音频模式
            indicator.text=[NSString stringWithFormat:@"%@ Kbps",[param objectForKey:@"AUDIO_BITRATE"]];

        }
        if (((NSString *)[param objectForKey:@"VIDEO_BITRATE"]).integerValue>300) {
            pushPauseTipView.hidden=YES;
        }
    }
//    NSLog(@"---------------%@----------",[param objectForKey:@"VIDEO_BITRATE"]);
}


#pragma mark --屏幕旋转回调事件
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight&&hasOrientation==NO) {
        [self rotationVideoView:0];
    }
    else if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft&&hasOrientation==NO){
        
        [self rotationVideoView:0];
    }
    else if (toInterfaceOrientation==UIInterfaceOrientationPortrait&&hasOrientation==YES){
        [self rotationVideoView:0];
    }
}
#pragma mark --退出

//
-(void)returnBack{
    if ([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortrait) {
        if (_presentStyle==PushOut) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
    else{
        
        [self rotationVideoView:0];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar  setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar  setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
    [self.navigationController.navigationBar  setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar  setTranslucent:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NaviBarBottomImage"] forBarMetrics:UIBarMetricsDefault];
    
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [UIApplication sharedApplication].statusBarHidden=YES;
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NaviBarBottomImage"]forBarMetrics:UIBarMetricsDefault];
    //
    [UIApplication sharedApplication].idleTimerDisabled=YES;//不自动锁屏
    //文档视图的frame修正
    //    _docView.frame=CGRectMake(_docView.frame.origin.x, 0, _docView.frame.size.width, _docView.frame.size.height);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceOrientation" object:@"YES"];
    //
   
    // 强制转为横屏
    [self orientationToPortrait:UIInterfaceOrientationPortrait];
}
-(void)viewDidAppear:(BOOL)animated{
    //统计
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}
-(void)viewDidDisappear:(BOOL)animated{
    //统计
    [MobClick endLogPageView:NSStringFromClass([self class])];
    ///////
    //退出聊天室
    [_qaView quitLiveChat];
    // 停止播放
    
    [_txLivePlayer stopPlay];
    [_txLivePlayer removeVideoWidget]; // 记得销毁view控件
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [singleTapTimer invalidate];

    
    
    [MZActivityIndicatorView loadingAnimationStop];
    [UIApplication sharedApplication].statusBarHidden=NO;
    [self.navigationController.navigationBar  setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController.navigationBar  setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    [UIApplication sharedApplication].idleTimerDisabled=NO;//自动锁屏
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceOrientation" object:@"NO"];

    
}

- (void)dealloc {
    ///
    //退出聊天室
    [_qaView quitLiveChat];
    // 停止播放
    
    [_txLivePlayer stopPlay];
    [_txLivePlayer removeVideoWidget]; // 记得销毁view控件
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

@end













