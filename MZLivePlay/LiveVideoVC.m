
//
//  VideoLiveVC.m
//  XuanYan
//
//  Created by mz on 16/9/27.
//  Copyright © 2016年 mizhen. All rights reserved.
//  

#import "LiveVideoVC.h"

@interface LiveVideoVC ()<GSPPlayerManagerDelegate>{
    //承载直播的底层视图
    UIView *bottomLiveView;
    //创建介绍栏
    UIButton *introduceBtn;
    //全屏按钮
    UIButton *fullScreenBtn;
    //切换按钮
    UIButton *exchangeBtn;
    //控制条
    UIImageView *controlView;
    
    CGRect originalVideoViewFrame;//记录videoView的原始尺寸
    CGRect originalQaViewFrame;//记录问答视图的原始尺寸
    CGRect originalDocViewFrame;//记录文档视图的原始尺寸
    CGRect originalSmallWindow; //原始小窗口尺寸
    CGRect smallWindow;//转屏后的小窗口frame
    CGRect largeWindow;//转屏后的大窗口frame
    CGRect subWindow; //转屏后侧栏的大小

    CGRect originalIntroduceBtnFrame;//记录简介栏原始frame
    
    CGSize fullScreenBtnSize;
    CGSize exchangeBtnSize;
    NSInteger controlHeight;
    
    BOOL hasOrientation;
    //创建返回按钮
    UIButton *returnButton;
    //创建右侧详情按钮
    UIButton *detailButton;
    //单击计时器
    NSTimer *singleTapTimer;
}
@end

@implementation LiveVideoVC

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
    //创建返回按钮
    returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,13,22)];
    [returnButton addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [returnButton setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnButton];
    self.navigationItem.leftBarButtonItem = returnButtonItem;
    //创建右侧详情按钮
    detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,22,22)];
    [detailButton addTarget:self action:@selector(liveDetail) forControlEvents:UIControlEventTouchUpInside];
    [detailButton setImage:[UIImage imageNamed:@"Detail"] forState:UIControlStateNormal];
    UIBarButtonItem *detailButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
//    self.navigationItem.rightBarButtonItem = detailButtonItem;
    
    [self setUpView];
    
    if (_playType==1) {
        [self setUpDataWithModel:_liveRoomModel];
    }
    else{
        [self downloadDataViaNet];
    }
}

-(void)setUpDataWithModel:(LiveRoomDetailModel *)model{
    [introduceBtn setTitle:model.lessonSubject forState:UIControlStateNormal];
    //问答视图刷新数据
//    [_qaView.qaTableView reloadData];
    //判断是否已购买
    if (model.price.floatValue==0) {
        [MZTools showAlertHUD:@"此视频免费！" atView:self.view withTime:HudPresentTime];
    }
    
    if (_liveRoomModel.roomStatus==2) {
        //判断网络状态，提醒移动网络会耗费流量
        if ([MZNetwork obtainCurrentNetwork]==1) {
            [MZTools confirmAlertViewAboveVC:self Title:@"提醒" Message:@"检测到您当前连接状态为移动网络，将会耗费较多流量！" ActionLeft:@"继续播放" ActionRight:@"停止播放" Yes:^{
                
            } Cancle:^{
                [self returnBack];
            }];
        }
    }
    
    GSPJoinParam *joinPara=[GSPJoinParam new];
    joinPara.domain=DomainName;
    joinPara.serviceType=GSPServiceTypeWebcast;
    joinPara.roomNumber=model.playNumber;
    joinPara.nickName=[MZUserKit obtainUserInforModelFromDocument].nickName;
    joinPara.watchPassword=model.audienceJoinToken;
    //若未登录
    if (![MZUserKit userLoginStatus]) {
        joinPara.nickName=@"匿名游客";
    }
    
    _playerManager=[[GSPPlayerManager alloc] init];
    _playerManager.delegate=self;
    [_playerManager joinWithParam:joinPara];
    
    _playerManager.videoView=_videoView;
    _playerManager.docView=_docView;
    //
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
//    smallWindow=CGRectMake(0, 0, Adapt(LiveSmallWindow_Size).width, Adapt(LiveSmallWindow_Size).height);
//    largeWindow=CGRectMake(Adapt(LiveSmallWindow_Size).width, 0, SCREEN_HEIGHT-Adapt(LiveSmallWindow_Size).width, SCREEN_WIDTH);
    largeWindow=CGRectMake(SCREEN_HEIGHT-SCREEN_WIDTH/3*4, 0, SCREEN_WIDTH/3*4, SCREEN_WIDTH);
    smallWindow=CGRectMake(0, 0, largeWindow.origin.x,largeWindow.origin.x/4*3);
    originalSmallWindow=CGRectMake(0, 0, SCREEN_WIDTH/3, SCREEN_WIDTH/3/4*3);
    fullScreenBtnSize=CGSizeMake(24, 24);
    originalVideoViewFrame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/4*3);
    subWindow=CGRectMake(0, smallWindow.size.height, Adapt(LiveSmallWindow_Size).width, SCREEN_WIDTH-Adapt(LiveSmallWindow_Size).height);
    
    //创建底层承载视图
    bottomLiveView=[[UIView alloc] initWithFrame:originalVideoViewFrame];
    bottomLiveView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomLiveView];
//    [self.view addSubview:returnButton];
    originalIntroduceBtnFrame=CGRectMake(0, bottomLiveView.current_y_h, SCREEN_WIDTH/3,  30);
    
    //创建视频直播播放器
    _videoView=[[GSPVideoView alloc] initWithFrame:originalVideoViewFrame];
    [bottomLiveView addSubview:_videoView];
    _videoView.userInteractionEnabled=YES;
    _videoView.contentMode = UIViewContentModeScaleAspectFit;
    //双击 切换，
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewExchanged:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
//    [bottomLiveView addGestureRecognizer:doubleTapGestureRecognizer];
    //单击播放器视图
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [bottomLiveView addGestureRecognizer:singleTapGestureRecognizer];
    
    //创建文档浏览器
    originalDocViewFrame=originalSmallWindow;

    self.docView=[[GSPDocView alloc] initWithFrame:originalDocViewFrame];
    _docView.userInteractionEnabled=YES;
    _docView.zoomEnabled=YES;
    _docView.gSDocModeType=ScaleAspectFit;
    [bottomLiveView addSubview:_docView];
    //创建介绍栏
    introduceBtn=[[UIButton alloc] initWithFrame:originalIntroduceBtnFrame];
    [introduceBtn setTitle:self.liveRoomModel.lessonSubject forState:UIControlStateNormal];
    [introduceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    introduceBtn.titleLabel.numberOfLines=1;
    introduceBtn.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    introduceBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    introduceBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [self.view addSubview:introduceBtn];
    //创建问答视图
    originalQaViewFrame=CGRectMake(0, introduceBtn.current_y, SCREEN_WIDTH, SCREEN_HEIGHT-_videoView.current_h-introduceBtn.current_h+introduceBtn.current_h);
    _qaView=[[MZQaView alloc] initWithFrame:originalQaViewFrame];
    [self.view addSubview:_qaView];
    WS(weakSelf);

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
    //
    UIView *controlBackView=[[UIView alloc] init];
    controlBackView.backgroundColor=[UIColor blackColor];
    controlBackView.alpha=0.45;
    controlBackView.userInteractionEnabled=YES;
    [controlView addSubview:controlBackView];
    [controlBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(controlView).offset(0);
        make.left.equalTo(controlView).offset(0);
        make.width.equalTo(controlView);
        make.height.equalTo(controlView);
    }];
    //切换按钮
    exchangeBtnSize=CGSizeMake(fullScreenBtnSize.width/100*112, fullScreenBtnSize.height);
    exchangeBtn=[[UIButton alloc] initWithFrame:CGRectMake(originalVideoViewFrame.origin.x+10, controlHeight-fullScreenBtnSize.height-10, exchangeBtnSize.width, exchangeBtnSize.height)];
    
    exchangeBtn.alpha=0.9;
    
    [exchangeBtn setBackgroundImage:[UIImage imageNamed:@"exchangeBtn"] forState:UIControlStateNormal];
    
    //    fullScreenBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,fullScreenBtnSize.width,fullScreenBtnSize.width);
    //_fullScreenBtn.backgroundColor=[UIColor yellowColor];
    [exchangeBtn addTarget:self action:@selector(exchangeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:exchangeBtn];
//    [exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(controlView).offset(-10);
//        make.left.equalTo(controlView).offset(10);
//    }];
    
    //全屏按钮
    fullScreenBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-fullScreenBtnSize.height-10,SCREEN_HEIGHT/2-fullScreenBtnSize.width-10, fullScreenBtnSize.width, fullScreenBtnSize.width)];
    fullScreenBtn.alpha=0.9;

    [fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"FullScreen"] forState:UIControlStateNormal];
    //    fullScreenBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,fullScreenBtnSize.width,fullScreenBtnSize.width);
    //_fullScreenBtn.backgroundColor=[UIColor yellowColor];
    [fullScreenBtn addTarget:self action:@selector(fullScreenClick:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:fullScreenBtn];
    [fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(controlView).offset(-10);
        make.right.equalTo(bottomLiveView).offset(-10);
        make.width.equalTo(fullScreenBtnSize.width);
        make.height.equalTo(fullScreenBtnSize.width);
    }];
    //
    [self createTimer];
    //
}

#pragma mark -- Network
-(void)downloadDataViaNet{
    
    [MZActivityIndicatorView loadingAnimationStart];

    NSMutableDictionary *paraDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:_liveRoomModel.playID,@"id", nil];
    
    [MZNetwork MZNewPostRequest:ObtainLiveDetail Parameters:paraDic success:^(NSString *error, NSString *msg, id result) {
        MZLogErrorMsgResult(LiveLog);;
        
        [MZActivityIndicatorView loadingAnimationStop];
        
        if (error.integerValue==1) {
            
            //问答视图刷新数据
//            [_qaView.qaTableView reloadData];
            //直播室数据获取成功，加载直播配置和界面
//            [self setUpDataWithModel:detailModel];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *netError) {
        
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
        self.navigationController.navigationBarHidden = YES;
        
    }
    else{
//        fullScreenBtn.hidden=NO;
//        exchangeBtn.hidden=NO;
        controlView.hidden=NO;
        self.navigationController.navigationBarHidden = NO;
        
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
            self.navigationController.navigationBarHidden = YES;
        }];
        
    } else{ //iOS系统版本 < 10.0
        singleTapTimer=[NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(timerOperation) userInfo:NULL repeats:YES];
    
    }
    
}
-(void)timerOperation{
    controlView.hidden=YES;
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark --双击切换视图
-(void)viewExchanged:(UITapGestureRecognizer *)tapGestureRecognizer{
    [bottomLiveView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];

    if (!hasOrientation) {
        if (_videoView.frame.size.width>originalSmallWindow.size.width) {
            _videoView.frame=originalSmallWindow;
            _docView.frame=originalVideoViewFrame;
        }
        else{
            _videoView.frame = originalVideoViewFrame;
            _docView.frame=originalSmallWindow;
        }
    }
    else if (hasOrientation){
        if (_videoView.frame.size.width>smallWindow.size.width) {
            _videoView.frame=smallWindow;
            _docView.frame=largeWindow;
        }
        else{
            _videoView.frame = largeWindow;
            _docView.frame=smallWindow;
        }
    }
    //文档视图的frame修正
//    _docView.frame=CGRectMake(_docView.frame.origin.x, 0, _docView.frame.size.width, _docView.frame.size.height);
}
#pragma mark --全屏按钮响应事件
-(void)exchangeBtnClick:(UIButton *)button{
    [self viewExchanged:nil];
}

-(void)fullScreenClick:(UIButton *)button{
    [self rotationVideoView:1];
//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];

}

#pragma mark - videoView
-(void)rotationVideoView:(NSInteger )manual{
    _docView.backgroundColor=[UIColor blackColor];
    _videoView.backgroundColor=[UIColor blackColor];
    [self.view endEditing:YES];//收起键盘
    //[self fullScreenBtnShow];


    //强制旋转
    if (!hasOrientation) {
        self.navigationController.interactivePopGestureRecognizer.enabled=NO;
        hasOrientation = YES;

        [UIView animateWithDuration:0.5 animations:^{
            
//            self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
//            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            bottomLiveView.frame=CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
            if (manual) {
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
            }//
//            [self updateViewConstraints];
            
            introduceBtn.frame=subWindow;
            introduceBtn.titleLabel.numberOfLines=0;
            introduceBtn.titleLabel.lineBreakMode=NSLineBreakByCharWrapping;
            introduceBtn.backgroundColor=[UIColor blackColor];
            [introduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            if (_docView.frame.size.width>originalSmallWindow.size.width) {
                _docView.frame = largeWindow;
                _videoView.frame=smallWindow;
            }
            else{
                _videoView.frame = largeWindow;
                _docView.frame=smallWindow;
            }
            exchangeBtn.frame=CGRectMake(largeWindow.origin.x+10, controlHeight-fullScreenBtnSize.height-10, exchangeBtnSize.width, exchangeBtnSize.height);
            //_fullScreenBtn.frame=CGRectMake(SCREEN_HEIGHT-10-fullScreenBtnSize.width, SCREEN_WIDTH-10-fullScreenBtnSize.width, fullScreenBtnSize.width, fullScreenBtnSize.width);
            //self.chatView.hidden = YES;
            //elf.docView.hidden=YES;
            self.qaView.hidden=YES;
            detailButton.hidden=YES;

            self.navigationController.navigationBarHidden = NO;
            controlView.hidden=NO;
            [self createTimer];
            
            [fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"ShrinkScreen"] forState:UIControlStateNormal];
//            [[UIApplication sharedApplication] setStatusBarHidden:YES];
//            self.navigationController.navigationBar
            //文档视图的frame修正
//            _docView.frame=CGRectMake(_docView.frame.origin.x, 0, _docView.frame.size.width, _docView.frame.size.height);
            
        }];
    } else {
        
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];

        self.navigationController.interactivePopGestureRecognizer.enabled=YES;

        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformInvert(CGAffineTransformMakeRotation(0));
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            //[bottomLiveView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
            bottomLiveView.frame=originalVideoViewFrame;
            introduceBtn.frame=originalIntroduceBtnFrame;
            introduceBtn.titleLabel.numberOfLines=1;
            introduceBtn.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
            introduceBtn.backgroundColor=LightBackgroundColor;
            [introduceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            if (_docView.frame.size.width>smallWindow.size.width) {
                _docView.frame = originalVideoViewFrame;
                _videoView.frame=originalSmallWindow;
            }
            else{
                _videoView.frame = originalVideoViewFrame;
                _docView.frame=originalSmallWindow;
            }
            exchangeBtn.frame=CGRectMake(originalVideoViewFrame.origin.x+10, controlHeight-fullScreenBtnSize.height-10, exchangeBtnSize.width, exchangeBtnSize.height);

            //文档视图的frame修正
//            _docView.frame=CGRectMake(_docView.frame.origin.x, 0, _docView.frame.size.width, _docView.frame.size.height);
            
            //_fullScreenBtn.frame=CGRectMake(originalVideoViewFrame.size.width-10-fullScreenBtnSize.width, originalVideoViewFrame.size.height-10-fullScreenBtnSize.width, fullScreenBtnSize.width, fullScreenBtnSize.width);
            hasOrientation = NO;
            //self.chatView.hidden = NO;
            self.docView.hidden=NO;
            self.qaView.hidden=NO;
            detailButton.hidden=NO;
            self.navigationController.navigationBarHidden = NO;
            controlView.hidden=NO;
            [self createTimer];
            
            [fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"FullScreen"] forState:UIControlStateNormal];
//            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            
        }];
    }
}
#pragma mark --PlayerSDK 回调方法
- (void)playerManagerWillReconnect:(GSPPlayerManager *)playerManager {
//        //用于断线重连
//        if (_progressHUD != nil) {
//            [_progressHUD hideAnimated:YES];
//            _progressHUD = nil;
//        }
    [MZTools showAlertHUD:@"已重新连接" atWindowWithTime:HudPresentTime]; 
//    [_qaView.dataArray removeAllObjects];
//    [_qaView.qaTableView reloadData];
}


- (void)playerManagerWillBuffer:(GSPPlayerManager *)playerManager{
    _progressHUD = [[MBProgressHUD alloc] initWithView:_qaView];
    _progressHUD.label.text = NSLocalizedString(@"断线重连", @"");
    [self.view addSubview:_progressHUD];
    [_progressHUD showAnimated:YES];
}

- (void)playerManagerDidVideoBegin:(GSPPlayerManager*)playerManager;{
    
}
- (void)playerManager:(GSPPlayerManager *)playerManager didUserJoin:(GSPUserInfo *)userInfo {
//    //用于断线重连
//    if (_progressHUD != nil) {
//        [_progressHUD hideAnimated:YES];
//        _progressHUD = nil;
//    }
}
-(void)playerManager:(GSPPlayerManager *)playerManager didReceiveChatMessage:(GSPChatMessage *)message{
    [_qaView getNewChatMessage:message];
}
- (void)playerManager:(GSPPlayerManager *)playerManager didReceiveQaData:(NSArray *)qaDatas{
     NSLog(@"%@",((GSPQaData *)[qaDatas objectAtIndex:0]).questionID);
    [_qaView getNewQaMessage:qaDatas];
    
}

-(void)playerManager:(GSPPlayerManager *)playerManager didReceiveSelfJoinResult:(GSPJoinResult)joinResult{
    if (joinResult==GSPJoinResultOK) {
        [MZTools guideOperationViewWithTag:@"exchangeImage4" Image:@"exchangeImage" Clicked:^{
            
        }];

        [MZActivityIndicatorView loadingAnimationStop];
    }
    else if(joinResult==GSPJoinResultTOO_EARLY){
//        [MZTools confirmAlertViewAboveVC:self Title:@"加入失败" Message:@"直播还未开始!" Yes:^{
//            
//        } Cancle:^{
//            
//        }];
        [MZTools showAlertHUD:@"直播尚未开始！" atView:self.view withTime:HudPresentTime];
        [MZActivityIndicatorView loadingAnimationStop];
    }
    else{
        [MZTools confirmAlertViewAboveVC:self Title:@"加入失败" Message:@"未能成功加入直播间" ActionLeft:@"重试" ActionRight:@"取消" Yes:^{
            if (_playType==1) {
                [self setUpDataWithModel:_liveRoomModel];
            }
            else{
                [self downloadDataViaNet];

            }

        } Cancle:^{
            
        }];

        [MZActivityIndicatorView loadingAnimationStop];

//        [MZTools showAlertHUD:@"直播间加入失败" atWindowWithTime:HudPresentTime];
    }
}

- (void)playerManager:(GSPPlayerManager *)playerManager didSelfLeaveFor:(GSPLeaveReason)reason {
    NSString *reasonStr = nil;
    switch (reason) {
        case GSPLeaveReasonEjected:
            reasonStr = NSLocalizedString(@"被踢出直播", @"");
            break;
        case GSPLeaveReasonTimeout:
            reasonStr = NSLocalizedString(@"超时", @"");
            break;
        case GSPLeaveReasonClosed:
            reasonStr = NSLocalizedString(@"直播关闭", @"");
            break;
        case GSPLeaveReasonUnknown:
            reasonStr = NSLocalizedString(@"位置错误", @"");
            break;
        default:
            break;
    }
    if (reasonStr != nil) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"退出直播", @"") message:reasonStr delegate:self cancelButtonTitle:NSLocalizedString(@"知道了", @"") otherButtonTitles:nil];
        [alertView show];
    }
    
}
/**
 *  直播是否暂停
 *
 *  @param playerManager 调用该代理的直播管理实例
 *  @param isPaused      YES表示直播已暂停，NO表示直播进行中
 */
- (void)playerManager:(GSPPlayerManager*)playerManager isPaused:(BOOL)isPaused{
    if (isPaused) {
        _qaView.inputView.hidden=NO;
        self.title=@"直播暂停中...";
        [MZTools confirmAlertViewAboveVC:self Title:@"注意" Message:@"直播暂停" Yes:^{
            
        } Cancle:^{
            
        }];
    }
    else{
        if (_qaView.inputView.isHidden==YES) {
            self.title=@"";
            [MZTools showAlertHUD:@"直播已恢复" atView:self.view withTime:HudPresentTime];
        }
//        self.title=@"视频";
        _qaView.inputView.hidden=NO;
         
    }
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
#pragma mark --按钮点击事件

-(void)liveDetail{
    return;
    LiveIntroductionViewController *introduceVC=[[LiveIntroductionViewController alloc] init];
    [introduceVC setPurchaseCompleted:^{
        [self downloadDataViaNet];
    }];
    introduceVC.videoType=LiveVideo;
    [introduceVC setUpDataWithVideoType:LiveVideo WebcastID:_liveRoomModel.playID rcvID:nil];

    [self.navigationController pushViewController:introduceVC animated:YES];
}
//
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
    [UIApplication sharedApplication].statusBarHidden=YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NaviBarBottomImage"]forBarMetrics:UIBarMetricsDefault];
    //
    [UIApplication sharedApplication].idleTimerDisabled=YES;//不自动锁屏
    //文档视图的frame修正
//    _docView.frame=CGRectMake(_docView.frame.origin.x, 0, _docView.frame.size.width, _docView.frame.size.height);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InterfaceOrientation" object:@"YES"];
    // 强制转为横屏
    [self orientationToPortrait:UIInterfaceOrientationPortrait];
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
//- (void)viewWillLayoutSubviews {
//    if (!hasOrientation) {
//        self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
//
//    }
//    else{
//        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    }
//    _playerManager.videoView.frame=_playerManager.videoView.frame;
//    _playerManager.docView.frame=_playerManager.docView.frame;
//
//}
- (void)dealloc {
    [self.playerManager leave];
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




























