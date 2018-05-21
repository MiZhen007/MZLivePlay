//
//  MZQaView.m
//  XuanYan
//
//  Created by mz on 16/9/29.
//  Copyright © 2016年 mizhen. All rights reserved.
//

#import "MZQaView.h"

@interface MZQaView()<UITableViewDelegate,UITableViewDataSource,CLInputViewDelegate,TIMGroupEventListener>{
    //frame
    CGRect qaViewFrame;
    //横屏frame
    CGRect fullScreenVQaViewFrame;
    //
    CGRect qaInputViewFrame;
    //
    NSInteger noticerWidth;
    NSInteger noticerHeight;
    //键盘弹出附加视图
    UIView *inputBottomView;
    //直播介绍视图
    LivePlayIntroView *introView;
    //弹出收起按钮
    UIButton *showViewBtn;
//    //显示IM的当前人数
//    UILabel *currentCountLb;
    //收到的未读消息个数
    NSInteger newMessageNum;
    //单击手势
    UITapGestureRecognizer *singleTapGestureRecognizer;
    //专家的私聊chatID
    unsigned expertChatID;
    //问题ID
    NSInteger questionID;
    //横竖屏标志
    BOOL fullScreenChange;
    //聊天cell的风格
    LiveChatCellStyle chatCellStyle;
    //////
    //GroupID
    NSString *roomGroupID;
    //identifier
    NSString *roomIdentifier;
    //userSig
    NSString *roomUserSig;
    //SDK初始化标志
    BOOL sdkInitFlag;
    //IM是否登录成功
    BOOL IMLoginFlag;
    //会话Conversation是否成功
    BOOL conversationFlag;
    //群组manager是否成功
    BOOL groupFlag;
    //
    __weak UITableView *wChatTableView;
    //
    __weak TIMConversation *wRoomConversation;
}

@end

@implementation MZQaView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.backgroundColor=[UIColor clearColor];

    questionID=0;
    expertChatID=0;
    qaViewFrame=frame;
    qaInputViewFrame=CGRectMake(0, self.current_h - 44, SCREEN_WIDTH, 44);
    fullScreenVQaViewFrame=CGRectMake(0, SCREEN_RWIDTH-H_ChatViewHeight, H_ChatViewWidth, H_ChatViewHeight);
    _chatDataArray=[[NSMutableArray alloc] init];
    ///
    wChatTableView=_chatTableView;
    wRoomConversation=_chatRoomConversation;
    
    [self createIntroView];
    [self createTableView];
    [self createBottomView];
    //
    [self initSDK];
    return self;
}
-(void)initSDK{
    SystemModel *sysModel=[MZConfigure obtainArchivedConfigureFileData];
    //
    ////初始化
    _IMManager=[TIMManager sharedInstance];
    //消息监听
    [[TIMManager sharedInstance] addMessageListener:self];
    TIMSdkConfig *cfg=[[TIMSdkConfig alloc] init];
    cfg.connListener=self;
    //    cfg.accountType=@"18784";
    //    cfg.sdkAppId=1400048273;
    cfg.accountType=sysModel.timAccountType;
    cfg.sdkAppId=((NSString *)sysModel.timAppidAt3rd).intValue;
    //日志事件
    [cfg setLogFunc:^(TIMLogLevel lvl, NSString *msg) {
        NSLog(@"----%ld--Message---%@",lvl, msg);
    }];
    //
    //    cfg.logFunc = ^(NSString* content) {
    //        NSLog(@"%@", content);
    //    }];
    //
    // 用户状态变更
    //    cfg.userStatusListener=self;
    int sdkInitResult=[[TIMManager sharedInstance] initSdk:cfg];
    if (sdkInitResult==0) {
        sdkInitFlag=YES;
    }
    //
    //    NSLog(@"----------%ld-------",sdkInitResult);
    [[TIMManager sharedInstance] addMessageListener:self];
}
-(void)initMessageHandlerWithGroupID:(NSString *)groupId UserSign:(NSString *)userSign Identifier:(NSString *)identifier{
    //
    roomGroupID=groupId;
    roomIdentifier=identifier;
    roomUserSig=userSign;
    SystemModel *sysModel=[MZConfigure obtainArchivedConfigureFileData];

    //登录
    TIMLoginParam * loginParam = [[TIMLoginParam alloc ]init];
    // identifier为用户名，userSig 为用户登录凭证
    // appidAt3rd 在私有帐号情况下，填写与sdkAppId 一样
    loginParam.identifier = identifier;
    loginParam.userSig = userSign;
    //
    loginParam.appidAt3rd = sysModel.timAppidAt3rd;
    //
    [_IMManager login: loginParam succ:^{
        NSLog(@"Login Succ");
        //
        IMLoginFlag=YES;
        //
        [self joinLiveRoom:groupId handler:^(int handle) {
            
        }];
    } fail:^(int code, NSString *msg) {
        NSLog(@"Login Failed: %d->%@", code, msg);
        [self checkAndFixIM];
    }];
    //消息收发
    ///群组管理
    //注销
}
#pragma mark --检测消息状态
-(void)checkAndFixIM{
    NSLog(@"进入IM检测:\n sdkInitFlag: %d \n IMLoginFlag:%d \n groupFlag:%d \n",sdkInitFlag,IMLoginFlag,groupFlag);

    if (!sdkInitFlag) {
        [MZTools showAlertHUD:@"SDK异常，启动MZWP自主修复系统" atWindowWithTime:2*HudPresentTime];

        [self initSDK];
        if (roomGroupID.length>0) {
            [self initMessageHandlerWithGroupID:roomGroupID UserSign:roomUserSig Identifier:roomIdentifier];
        }
        return;
    }
    if (!IMLoginFlag||[[TIMManager sharedInstance] getLoginStatus]==TIM_STATUS_LOGOUT) {
        [MZTools showAlertHUD:@"登录异常，启动MZWP自主修复系统" atWindowWithTime:2*HudPresentTime];

        IMLoginFlag=NO;
        if (roomGroupID.length>0) {
            [self initMessageHandlerWithGroupID:roomGroupID UserSign:roomUserSig Identifier:roomIdentifier];
        }
        else{
            [MZTools showAlertHUD:@"groupID不存在，请尝试重新进入直播间" atWindowWithTime:2*HudPresentTime];

        }
        return;
    }

    if (!groupFlag) {
        [MZTools showAlertHUD:@"群组异常，启动MZWP自主修复系统" atWindowWithTime:2*HudPresentTime];

        [self joinLiveRoom:roomGroupID handler:^(int handle) {
            
        }];
        return;
    }
    [MZTools showAlertHUD:@"IM系统正常" atWindowWithTime:HudPresentTime];
}

#pragma mark --请求主讲人信息
-(void)getLivePlayDetail:(NSString *)liveId{
    _liveID=liveId;
    NSString *orderUrl=GetLiveLectureInfo;
    
    NSMutableDictionary *paraDic=[[NSMutableDictionary alloc] init];
    
    [paraDic setObject:_liveID forKey:@"id"];
    
    [MZNetwork MZEMDPostRequest:orderUrl Parameters:paraDic success:^(NSString *error, NSString *msg, id result) {
        if (error.integerValue==200) {
            
            _expertName=[result objectForKey:@"memName"];
            _workUnit=[result objectForKey:@"orgName"];
            _expertRank=[result objectForKey:@"title"];
            
            introView.videoSubject.text=[NSString stringWithFormat:@"主讲人：%@",_expertName];
            //        cell.expertInfor.text=_expertInfor;
            introView.videoDuration.text=[NSString stringWithFormat:@"%@ %@",_workUnit,_expertRank];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MZTools showAlertHUD:@"网络请求失败" atWindowWithTime:HudPresentTime];
    }];
}

-(void)createBottomView{

    //输入框
    _inputView = [[CLInputView alloc] initWithFrame:qaInputViewFrame];
    _inputView.backgroundColor=BackColorDark;
    _inputView.textField.backgroundColor=[UIColor whiteColor];
    _inputView.placeholder=@"一起讨论吧";
    _inputView.delegate = self;
    _inputView.bottomVCView=self;
    _inputView.userInteractionEnabled=YES;
    [self addSubview:_inputView];
    //
    //单击手势
    singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fatherViewTapped)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled=NO;
    [self addGestureRecognizer:singleTapGestureRecognizer];
    //使消息提示红点可用
//    for (MZLiveButton *button in _shiftView.slideBar.labelArrays) {
//        [button enableBadge];
//    }
}

-(void)createIntroView{
    WeakObject(self, weakSelf);
    introView=[[LivePlayIntroView alloc] initWithFrame:CGRectMake(0, 0, self.current_w, 70+30)];
    introView.videoSubject.text=[NSString stringWithFormat:@"主讲人：%@",_expertName];
    //        cell.expertInfor.text=_expertInfor;
    introView.videoDuration.text=[NSString stringWithFormat:@"%@ %@",_workUnit,_expertRank];
    introView.backgroundColor=[UIColor whiteColor];
    [introView setSeeMoreClicked:^{
        [weakSelf liveIntroClicked];
    }];
    [self addSubview:introView];
}

- (void)createTableView {
    //弹出收起按钮
    showViewBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.current_w, 20)];
//    showViewBtn.backgroundColor=[UIColor yellowColor];
    showViewBtn.userInteractionEnabled=YES;
//    [showViewBtn setImage:[UIImage imageNamed:@"DownwardPackUp"] forState:UIControlStateNormal];
//    [showViewBtn addTarget:self action:@selector(showViewClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:showViewBtn];
    [showViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(0);
        make.left.equalTo(0);
        make.top.equalTo(0);
    }];
    
    UITapGestureRecognizer *showBtnTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showViewClicked)];
    showBtnTap.numberOfTapsRequired=1;
    showBtnTap.numberOfTouchesRequired=1;
//    [showViewBtn addGestureRecognizer:showBtnTap];
    //
    showViewBtn.hidden=YES;
    //当前聊天人数
    _currentCountLb=[[UILabel alloc] initWithFrame:CGRectMake(0, -5, 90, 25)];
    [_currentCountLb.layer setMasksToBounds:YES];
    [_currentCountLb.layer setCornerRadius:10];
    _currentCountLb.text=@"学员数：";
    _currentCountLb.textAlignment=NSTextAlignmentCenter;
    _currentCountLb.font=[UIFont systemFontOfSize:15.0];
//    _currentCountLb.backgroundColor=[UIColor colorWithWhite:0.3 alpha:0.7];
    _currentCountLb.backgroundColor=[UIColor clearColor];
    _currentCountLb.textColor=[UIColor whiteColor];
    [showViewBtn addSubview:_currentCountLb];
    
    //聊天模块
    _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0+introView.current_y_h, self.current_w, self.current_h - 44-introView.current_h) style:UITableViewStylePlain];
    [self addSubview:_chatTableView];
    [_chatTableView registerClass:[LiveCommentCell class] forCellReuseIdentifier:@"LiveCommentCell"];
    [_chatTableView registerClass:[VideoIntroView class] forCellReuseIdentifier:@"VideoIntroView"];
    _chatTableView.dataSource = self;
    _chatTableView.delegate = self;
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

///////
//收到聊天消息
-(void)getNewChatMessage:(CommentModel*)message{

    [_chatDataArray addObject:message];
    
    [self chatTableViewRefreshToBottom];
}

-(void)chatTableViewRefreshToBottom{
    [_chatTableView reloadData];
    
    if (_chatDataArray.count>0) {
        [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatDataArray.count - 1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    }

}
//////////收起按钮点击事件
-(void)showViewClicked{
    [UIView animateWithDuration:0.2 animations:^{
        if (self.current_y<SCREEN_RWIDTH/2) {
//            [UIScreen mainScreen].bounds
            self.frame=CGRectMake(self.current_x, SCREEN_RWIDTH-showViewBtn.current_h, self.current_w, self.current_h);
//            [showViewBtn setImage:[UIImage imageNamed:@"UpwardUnfold"] forState:UIControlStateNormal];
//            self.frame.origin.y
        }
        else{
            self.frame=fullScreenVQaViewFrame;
//            [showViewBtn setImage:[UIImage imageNamed:@"DownwardPackUp"] forState:UIControlStateNormal];

        }
    }];
}
///点击简介栏收回
-(void)liveIntroClicked{
    if (introView.current_h>50) {
        introView.frame=CGRectMake(introView.current_x, introView.current_y, introView.current_w,30);
        _chatTableView.frame=CGRectMake(0, 0+introView.current_y_h, self.current_w, self.current_h - 44-introView.current_h);
    }
    else{
        introView.frame=CGRectMake(introView.current_x, introView.current_y, introView.current_w, 70+30);
        _chatTableView.frame=CGRectMake(0, 0+introView.current_y_h, self.current_w, self.current_h - 44-introView.current_h);
    }
    
}
/////////////进入横屏模式
-(void)changeToFullScreenMode:(BOOL)change{
//    self.frame=CGRectMake(0, 0, 102, 102);
    //主要变量
    //头像缩进的距离
    CGFloat viewLeftIndent=45;
    //背景透明度
    CGFloat viewAlpha=0;
    
    if (change) {
        
        self.frame=fullScreenVQaViewFrame;
        //
        introView.hidden=YES;
        showViewBtn.hidden=NO;
//        showViewBtn.alpha=viewAlpha;
        showViewBtn.backgroundColor=[UIColor colorWithWhite:0.3 alpha:viewAlpha];
        //
        _chatTableView.frame=CGRectMake(-viewLeftIndent, 0+showViewBtn.current_y_h, H_ChatViewWidth+viewLeftIndent, H_ChatViewHeight-44-showViewBtn.current_h);
//        _chatTableView.frame=self.frame;
        _chatTableView.backgroundColor=[UIColor colorWithWhite:0.3 alpha:viewAlpha];
//        _chatTableView.alpha=viewAlpha;
        _chatTableView.showsVerticalScrollIndicator=NO;
        
        chatCellStyle=FullScreenChat;
        
        [self changeChatCellTextViewWidth:_chatTableView.current_w];
//        [_chatTableView reloadData];
        [self chatTableViewRefreshToBottom];

        //改变输入框视图
        qaInputViewFrame=CGRectMake(0, self.current_h - 44, self.frame.size.width, 44);
//        _inputView.alpha=viewAlpha;
//        _inputView.frame=CGRectMake(0, H_ChatViewHeight-qaInputViewFrame.size.height, qaInputViewFrame.size.width, qaInputViewFrame.size.height);
        _inputView.frame=CGRectMake(0, H_ChatViewHeight-_inputView.current_h, qaInputViewFrame.size.width, _inputView.current_h);

        [_inputView layoutSubviews];
        
    }
    else{
        self.frame=qaViewFrame;
        //
        introView.hidden=NO;
        showViewBtn.hidden=YES;
//        showViewBtn.alpha=1;

        _chatTableView.backgroundColor=[UIColor whiteColor];
        _chatTableView.frame=CGRectMake(0, 0+introView.current_y_h, self.current_w, self.current_h - 44-introView.current_h);
        _chatTableView.alpha=1;
        
        _chatTableView.showsVerticalScrollIndicator=YES;

        ////
        chatCellStyle=VerticalChat;
        //////
        [self changeChatCellTextViewWidth:_chatTableView.current_w];
//        [_chatTableView reloadData];
        [self chatTableViewRefreshToBottom];
        //改变输入框视图
        qaInputViewFrame=CGRectMake(0, self.current_h - 44, SCREEN_RWIDTH, 44);
        _inputView.alpha=1.0;
//        _inputView.frame=qaInputViewFrame;
        _inputView.frame=CGRectMake(qaInputViewFrame.origin.x, self.current_h-_inputView.current_h, qaInputViewFrame.size.width, _inputView.current_h);
        [_inputView layoutSubviews];

    }
}
-(void)changeChatCellTextViewWidth:(CGFloat )viewWidth{

    for (CommentModel *model in _chatDataArray) {
        [model initPerformanceDataWithViewWidth:viewWidth];
    }
}

#pragma mark - UITableViewDelegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat statusHeight=0;
    if (((CommentModel *)_chatDataArray[indexPath.row]).messageStatus==2) {
        statusHeight=20;
    }
    if (chatCellStyle==FullScreenChat) {
        return ((CommentModel *)_chatDataArray[indexPath.row]).CommentHeight-10+statusHeight;
    }
    else{
        return ((CommentModel *)_chatDataArray[indexPath.row]).CommentHeight+statusHeight;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _chatDataArray.count;


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakObj(self, weakSelf);
    CommentModel *commentModel=_chatDataArray[indexPath.row];
    //
    LiveCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiveCommentCell"];
    //
    cell.backgroundColor=[UIColor  clearColor];
   
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell refreshData:_chatDataArray[indexPath.row]];
    [cell changeCellStyle:chatCellStyle];
    ///////
//    [cell setMsgSendStatusFailedClicked:^{
//        TIMTextElem *textElem = [[TIMTextElem alloc] init];
//        //    [textElem setText:content];
//        [textElem setText:commentModel.content];
//        
//        TIMMessage *timMsg = [[TIMMessage alloc] init];
//        [timMsg addElem:textElem];
//        //
//        [wRoomConversation sendMessage:timMsg succ:^{
//            ///////
//            commentModel.messageStatus=0;//发送成功
//            [wChatTableView reloadData];
//            /////
//            
//        } fail:^(int code, NSString *msg) {
//            NSLog(@"sendMessage failed, code:%d, errmsg:%@", code, msg);
//            ///////
//            commentModel.messageStatus=2;//发送失败
//            [wChatTableView reloadData];
//            //
//            [weakSelf checkAndFixIM];
//        }];
//    }];

    NSLog(@"------%ld---%@------",indexPath.row,_chatDataArray);
    return cell;
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.01;
//
//}

//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.01;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UILabel *headerView=[[UILabel alloc] init];
//    headerView.backgroundColor=[UIColor whiteColor];
//    headerView.text=@"发言区";
//    headerView.textAlignment=NSTextAlignmentCenter;
//    return headerView;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - YTIputViewDelegate
- (void)inputView:(CLInputView *)inputView text:(NSString *)text {
    //是否发送成功的标志
//    BOOL seccessFlag;
    
    if (!text || [[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        
        [MZTools showAlertHUD:@"提问的内容不能为空" atView:self withTime:2];
        return;
    }
    
    //发送消息
    [self sendTextMessage:[UserInforModel shareUserInforModel].userID nickName:[UserInforModel shareUserInforModel].name headPic:[UserInforModel shareUserInforModel].portrait msg:text];
    
    //点击了发送按钮，输入框回到原位
    [UIView animateWithDuration:0.25 animations:^{
//        _inputView.frame = qaInputViewFrame;
        [_inputView.textField resignFirstResponder];
    }];
    //
//    [_inputView bounceToolbar];

}
      
- (void)inputView:(CLInputView *)inputView willShowKeyboardHeight:(CGFloat)height time:(NSNumber *)time {
    
    if (height == 0){
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
//        inputView.frame = CGRectMake(0, qaInputViewFrame.origin.y-height, qaInputViewFrame.size.width, qaInputViewFrame.size.height);
        _messageNoticer.frame=CGRectMake((SCREEN_WIDTH-noticerWidth)/2, _inputView.frame.origin.y-noticerHeight, noticerWidth, noticerHeight);

    }];
    
    singleTapGestureRecognizer.enabled=YES;
}


- (void)willHideKeyboardWithInputView:(CLInputView *)inputView time:(NSNumber *)time {
    [UIView animateWithDuration:[time doubleValue] animations:^{
//        inputView.frame = qaInputViewFrame;
        _messageNoticer.frame=CGRectMake((SCREEN_WIDTH-noticerWidth)/2, _inputView.frame.origin.y-noticerHeight, noticerWidth, noticerHeight);
    }];
    singleTapGestureRecognizer.enabled=NO;

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self endEditing:YES];
}

//
-(void)fatherViewTapped{
    [UIView animateWithDuration:0.25 animations:^{
//        _inputView.frame = qaInputViewFrame;
//        [_inputView bounceToolbar];
        
        [_inputView.textField resignFirstResponder];
        
        _messageNoticer.frame=CGRectMake((SCREEN_WIDTH-noticerWidth)/2, _inputView.frame.origin.y-noticerHeight, noticerWidth, noticerHeight);
    }];
}

///退出聊天
-(void)quitLiveChat{
    [self quitLiveRoom:_groupId handler:^(int handle) {
        /////
        
    }];
}

#pragma maek --发送消息
- (void)sendTextMessage:(NSString *)userId nickName:(NSString *)nickName headPic:(NSString *)headPic msg:(NSString *)msg
{
    
    [self sendMessage:AVIMCMD_Custom_Text userId:userId nickName:nickName headPic:headPic msg:msg];
}

- (void)sendMessage:(AVIMCommand)cmd userId:(NSString *)userId nickName:(NSString *)nickName headPic:(NSString *)headPic msg:(NSString *)msgContent
{
    //////
    if ((AVIMCMD_Custom_Text == cmd || AVIMCMD_Custom_Danmaku == cmd) && msgContent.length == 0)
    {
        NSLog(@"sendMessage failed, msg length is 0");
        return;
    }

    ///////
    TIMTextElem *textElem = [[TIMTextElem alloc] init];
    //    [textElem setText:content];
    [textElem setText:msgContent];
    
    TIMMessage *timMsg = [[TIMMessage alloc] init];
    [timMsg addElem:textElem];
    
    /////
    [_inputView bounceToolbar];
    //添加聊天数据，刷新界面
    __strong CommentModel *commentModel=[[CommentModel alloc] init];
    commentModel.title=nickName;
    commentModel.content=msgContent;
    commentModel.portraitUrl=headPic;
    commentModel.messageStatus=1;//正在发送
    [commentModel initPerformanceDataWithViewWidth:_chatTableView.current_w];
    /////
    [self getNewChatMessage:commentModel];
    //
    if (!_chatRoomConversation) {
        commentModel.messageStatus=2;//发送失败
        [_chatTableView reloadData];

        [self checkAndFixIM];
    }
    [_chatRoomConversation sendMessage:timMsg succ:^{
        NSLog(@"sendMessage success, cmd:%ld", cmd);
        ///////
//        _inputView.textField.text=@"";
        commentModel.messageStatus=0;//发送成功
        [_chatTableView reloadData];

        /////
       
    } fail:^(int code, NSString *msg) {
        NSLog(@"sendMessage failed, cmd:%ld, code:%d, errmsg:%@", cmd, code, msg);
        ///////
        [MZTools showAlertHUD:msg atWindowWithTime:HudPresentTime];
        commentModel.messageStatus=2;//发送失败
        [self chatTableViewRefreshToBottom];
        //
        [self checkAndFixIM];
    }];
    /////
    if (XuanYanDebug&&_chatRoomConversation==nil) {
        [_inputView bounceToolbar];
        //添加聊天数据，刷新界面
        /////
        CommentModel *commentModel=[[CommentModel alloc] init];
        commentModel.title=nickName;
        commentModel.content=msgContent;
        commentModel.portraitUrl=headPic;
        [commentModel initPerformanceDataWithViewWidth:_chatTableView.current_w];
        /////
        [self getNewChatMessage:commentModel];
    }
    /////////
}
////
#pragma mark -- 聊天室人数
-(void)getLiveRoomNum{
    //
    NSString *urlStr=GetLiveRoomMemNum;
    
    NSMutableDictionary *paraDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys: _groupId,@"groupId", nil];
    
    [MZNetwork MZEMDPostRequest:urlStr Parameters:paraDic success:^(NSString *error, NSString *msg, id result) {
//        MZLogRequest;
        
        
        if (error.integerValue==200) {
            
            _currentCountLb.text=[NSString stringWithFormat:@"学员数：%@",[result objectForKey:@"online"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
////
#pragma mark - TIMMessageListener
- (void)onNewMessage:(NSArray *)msgs {
    // TODO 可以将onThread改为另外的线程
    [self performSelector:@selector(onHandleNewMessage:) onThread:[NSThread currentThread] withObject:msgs waitUntilDone:NO];
}
////
#pragma mark --接收到消息
//收到消息列表
- (void)onHandleNewMessage:(NSArray *)msgs {
    for(TIMMessage *msg in msgs) {
        TIMConversationType conType = msg.getConversation.getType;
        
        switch (conType) {
            case TIM_C2C: {
                //目前只有连麦模块使用了C2C消息
//                if (NO == [[TCLinkMicModel sharedInstance] handleC2CMessageReceived:msg]) {
//                    //返回YES表示C2C消息已经被处理，否则可以继续给其它模块处理
//                }
                break;
            }
            case TIM_GROUP: {
                if([[msg.getConversation getReceiver] isEqualToString:_groupId]) {
                    // 处理群聊天消息
                    // 只接受来自该聊天室的消息
                    [self onRecvGroup:msg];
                }
                break;
            }
            case TIM_SYSTEM: {
                // 这里获取的groupid为空，IMSDK的问题
                // 所以在onRecvGroupSystemMessage里面通过sysElem.group来判断
                //                if ([[msg.getConversation getReceiver] isEqualToString:_groupId]) {
                [self onRecvGroupSystemMessage:msg];
                //                }
                break;
            }
            default:
                break;
        }
    }
    [self getCurrentCount];
    
//    [self getLiveRoomNum];
}
//收到群组系统消息
- (void)onRecvGroupSystemMessage:(TIMMessage *)msg {
    for (int index = 0; index < [msg elemCount]; index++) {
        TIMElem *elem = [msg getElem:index];
        
        if ([elem isKindOfClass:[TIMGroupSystemElem class]]) {
            TIMGroupSystemElem *sysElem = (TIMGroupSystemElem *)elem;
            if ([sysElem.group isEqualToString:_groupId]) {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (_roomIMListener && [_roomIMListener respondsToSelector:@selector(onRecvGroupSystemMessage:)]) {
//                        [_roomIMListener onRecvGroupSystemMessage:sysElem];
//                    }
                    if (sysElem.type==TIM_GROUP_SYSTEM_CUSTOM_INFO) {
                        
                        NSString *dataStr=[[NSString alloc] initWithData:sysElem.userData encoding:NSUTF8StringEncoding];
//
                        if ([dataStr containsString:@"直播结束"]||[dataStr containsString:@"7001"]) {
                            [MZTools confirmAlertWithTitle:@"温馨提示" Message:@"主播离开" Yes:^{
                                
                            }];

                            if (self.playEnd) {
                                self.playEnd(AppSysMsg_PushEnd);
                            
                            }
                        }
                        if ([dataStr containsString:@"7003"]) {
//                            [MZTools confirmAlertWithTitle:@"温馨提示" Message:@"直播暂停" Yes:^{
//
//                            }];
                            
                            if (self.playEnd) {
                                self.playEnd(AppSysMsg_PushPause);
                            }
                        }
                        if ([dataStr containsString:@"7002"]) {
//                            [MZTools confirmAlertWithTitle:@"温馨提示" Message:@"直播恢复" Yes:^{
//                                
//                            }];
                            
                            if (self.playEnd) {
                                self.playEnd(AppSysMsg_PushRecover);
                            }
                        }
                        if ([dataStr containsString:@"7004"]) {//网络中断
                            
                            if (self.playEnd) {
                                self.playEnd(AppSysMsg_NetPause);
                            }
                        }
                    }
                    
                });
                
            }
        }
        else if ([elem isKindOfClass:[TIMGroupTipsElem class]]){
            TIMGroupTipsElem *sysElem = (TIMGroupTipsElem *)elem;
            if ([sysElem.group isEqualToString:_groupId]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (sysElem.type==TIM_GROUP_TIPS_TYPE_INVITE) {
                        _currentCountLb.text=[NSString stringWithFormat:@"学员数：%ld",sysElem.userList.count];
                    }
                });
                
            }
        }
        
    }
}

//收到群组消息
- (void)onRecvGroup:(TIMMessage *)msg {
    
//    IMUserAble *userAble = [[IMUserAble alloc] init];
    [msg getSenderProfile];
    
    for(int index = 0; index < [msg elemCount]; index++) {
        TIMElem *elem = [msg getElem:index];
        if([elem isKindOfClass:[TIMTextElem class]]) {
            // 消息总入口频率限制
//            static TCFrequeControl *freqControl = nil;
//            if (freqControl == nil) {
//                freqControl = [[TCFrequeControl alloc] initWithCounts:20 andSeconds:1];
//            }
//
//            if (![freqControl canTrigger]) {
//                return;
//            }
            
            // 文本消息
            TIMTextElem *textElem = (TIMTextElem *)elem;
//            NSString *msgText = textElem.text;
//            NSDictionary* dict = [MZNetwork dictionaryWithJsonString:msgText];
//
//            //
//            CommentModel *commentModel=[[CommentModel alloc] init];
//            commentModel.title=[dict objectForKey:@"nickName"];
//            commentModel.content=[dict objectForKey:@"msg"];
//            commentModel.portraitUrl=[dict objectForKey:@"headPic"];
//            [commentModel initPerformanceDataWithViewWidth:_chatTableView.current_w];
            CommentModel *commentModel=[[CommentModel alloc]  init];
            commentModel.title=[msg getSenderProfile].nickname;
            commentModel.portraitUrl=[msg getSenderProfile].faceURL;
//            commentModel.content=[NSString stringWithFormat:@"id:%@--%@",[msg getSenderProfile].identifier,textElem.text];
            commentModel.content=textElem.text;
            [commentModel initPerformanceDataWithViewWidth:_chatTableView.current_w];

            [self getNewChatMessage:commentModel];
//            if (dict)
//            {
//                if (dict[@"userAction"])
//                userAble.cmdType = [dict[@"userAction"] intValue];
//
//                userAble.imUserId = dict[@"userId"];
//                userAble.imUserName = dict[@"nickName"];
//                userAble.imUserIconUrl = dict[@"headPic"];
//                msgText = dict[@"msg"];
//            }
//            else
//            {
//                TIMUserProfile *userProfile = [msg GetSenderProfile];
//                if (userProfile) {
//                    userAble.imUserId = userProfile.identifier;
//                    userAble.imUserName = userProfile.nickname.length > 0 ? userProfile.nickname : userProfile.identifier;
//                    userAble.imUserIconUrl = userProfile.faceURL;
//                }
//                userAble.cmdType = AVIMCMD_Custom_Text;
//            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                if (_roomIMListener) {
//                    [_roomIMListener onRecvGroupSender:userAble textMsg:msgText];
//                }
            });
        }
        else if([elem isKindOfClass:[TIMCustomElem class]]) {
            // 自定义消息
//            TIMCustomElem* cele = (TIMCustomElem*)elem;
//            NSString *dataStr = [[NSString alloc] initWithData:cele.data encoding:NSUTF8StringEncoding];
//            DebugLog(@"datastr is:%@", dataStr);
        }
    }
}

#pragma mark -- 获取当前聊天室的人数

-(void)getCurrentCount{
    if (_groupId==nil) {
        return;
    }
    NSMutableArray * groupList = [[NSMutableArray alloc] init];
    [groupList addObject:_groupId];
    [[TIMGroupManager sharedInstance] getGroupInfo:groupList succ:^(NSArray * groups) {
        for (TIMGroupInfo * info in groups) {
            NSLog(@"get group succ, infos=%@", info);
            _currentCountLb.text=[NSString stringWithFormat:@"学员数：%d",info.memberNum];
        }
    } fail:^(int code, NSString* err) {
        NSLog(@"failed code: %d %@", code, err);
    }];
}


#pragma mark -- 切换聊天室
- (void)switchToLiveRoom:(NSString *)groupId
{
    _groupId = groupId;
    _chatRoomConversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:groupId];
    ////
    conversationFlag=YES;
}

#pragma mark -- 创建聊天室
- (void)createLiveRoom:(void (^)(int, NSString *))handler
{

    
//    __weak typeof(self) weakSelf = self;
    
    [[TIMGroupManager sharedInstance] createGroup:@"live" groupId:@"" groupName:@"" succ:^(NSString *groupId) {
//        DebugLog(@"createLiveRoom succ, groupId:%@", groupId);
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(0, groupId);
        });
    } fail:^(int code, NSString *msg) {
//        DebugLog(@"createLiveRoom failed, error:%d, msg:%@", code, msg);
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(code, nil);
        });
    }];
}

#pragma mark -- 删除聊天室
- (void)deleteLiveRoom:(NSString *)groupId handler:(void (^)(int))handler
{
    [[TIMGroupManager sharedInstance] deleteGroup:@"groupid" succ:^{
//        DebugLog(@"deleteLiveRoom succ, groupId:%@", groupId);
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(0);
        });
        
    } fail:^(int code, NSString *msg) {
//        DebugLog(@"deleteLiveRoom failed, error:%d, msg:%@", code, msg);
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(code);
        });
    }];
}
#pragma mark -- 加入聊天室
- (void)joinLiveRoom:(NSString *)groupId handler:(void (^)(int))handler
{
    __weak typeof(self) weakSelf = self;
    [[TIMGroupManager sharedInstance] joinGroup:groupId msg:@"mm" succ:^{
//        DebugLog(@"joinGroup success,group id:%@", groupId);
        //
        groupFlag=YES;
        //切换群会话的上下文环境
        [weakSelf switchToLiveRoom:groupId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(0);
        });
        
    } fail:^(int code, NSString *msg) {
        [MZTools showAlertHUD:msg atWindowWithTime:HudPresentTime];
        if (10013 == code)  //10013表示已经是群成员
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(0);
            });
        }
        else
        {
//            DebugLog(@"joinGroup failed,group id:%@, code:%d, msg:%@", groupId, code, msg);
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(code);
                });
            });
        }
    }];
}

#pragma mark -- 退出聊天室
- (void)quitLiveRoom:(NSString *)groupId handler:(void (^)(int))handler
{
    [[TIMGroupManager sharedInstance] quitGroup:groupId succ:^{
//        DebugLog(@"quitGroup success,group id:%@", groupId);
    } fail:^(int code, NSString *msg) {
//        DebugLog(@"quitGroup failed,group id:%@", groupId);
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(code);
        });
        
    }];
}

@end











