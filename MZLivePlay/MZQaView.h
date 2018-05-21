
//
//  MZQaView.h
//  XuanYan
//
//  Created by mz on 16/9/29.
//  Copyright © 2016年 mizhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLiveHeader.h"
#import "YTInputView.h"
#import "CLInputToolbar.h"
#import "ChatCell.h"
#import "ChatMessageCell.h"
#import "ChatModel.h"
#import "ChatFrameModel.h"
#import "LiveCommentCell.h"
#import "LivePlayIntroView.h"
/////
#define H_ChatViewWidth (SCREEN_WIDTH>SCREEN_HEIGHT ? SCREEN_WIDTH : SCREEN_HEIGHT )/5*2
#define H_ChatViewHeight ((SCREEN_WIDTH<SCREEN_HEIGHT ? SCREEN_WIDTH : SCREEN_HEIGHT )-70)

///聊天字体大小，间隔
#define ChatFontSize 16.f
#define ChatLineSpace 7.0
//聊天框宽度
#define ChatViewWidthSpace 76.0
/////////
#define TC_PROTECT_STR(x) (x == nil ? @"" : x)

    ///
typedef NS_ENUM(NSInteger, AVIMCommand) {
    AVIMCMD_None                 = 0, // 无事件
    ///////
    AVIMCMD_Custom_Text          = 1, //文本消息
    AVIMCMD_Custom_EnterLive     = 2, //用户加入直播
    AVIMCMD_Custom_ExitLive      = 3, //用户推出直播
    AVIMCMD_Custom_Like          = 4, //点赞消息
    AVIMCMD_Custom_Danmaku       = 5, //弹幕消息
    //
};

typedef NS_ENUM(NSInteger, ReceiveAppSysMsg) {
    AppSysMsg                = 0, // 无事件
    
    AppSysMsg_PushEnd          = 1, //直播推流结束

    AppSysMsg_PushPause          = 2, //主播暂时离开

    AppSysMsg_PushRecover          = 3, //主播暂时离开
    
    AppSysMsg_NetPause          = 4 //网络连接异常
    //
};

//  //
@interface MZQaView : UIView <TIMMessageListener,TIMConnListener,TIMUserStatusListener>

//@property(nonatomic,weak)LiveVideoVC  *liveVC;
@property(nonatomic,strong)TIMManager *IMManager;
@property(nonatomic,copy)NSString *groupId;
@property(nonatomic,strong)TIMConversation *chatRoomConversation;   // 群会话上下文
////////////////////////////////////////////////////
//@property(nonatomic,strong)MZShiftView *shiftView;
//主tableView
@property(nonatomic,strong)UITableView *chatTableView;

//直播ID
@property(nonatomic,copy)NSString *liveID;

@property(nonatomic,copy)NSString *expertName;
@property(nonatomic,copy)NSString *workUnit;
@property(nonatomic,copy)NSString *expertRank;

//聊天数据数组
@property(nonatomic,strong)NSMutableArray *chatDataArray;
//至底框
@property(nonatomic,strong)UIButton *setBottomBtn;
//新消息提醒框
@property(nonatomic,strong)UIButton *messageNoticer;
//显示IM的当前人数
@property(nonatomic,strong)UILabel *currentCountLb;
//输入框
@property(nonatomic,strong)CLInputView *inputView;

@property(nonatomic,strong)BOOL (^sendMessage)(NSString *messageID,NSString *content);
@property(nonatomic,strong)void(^inforViewClicked)();
@property(nonatomic,strong)void(^playEnd)(ReceiveAppSysMsg msg);

-(void)initMessageHandlerWithGroupID:(NSString *)groupId UserSign:(NSString *)userSign Identifier:(NSString *)identifier;

-(void)getNewChatMessage:(CommentModel*)message;

-(void)getNewQaMessage:(NSArray *)msgArray;//接收到消息，调用此方法

-(void)fatherViewTapped;//父视图点击，调用此方法会让输入框回到原位

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
/////////////进入横屏模式
-(void)changeToFullScreenMode:(BOOL)change;
///退出聊天
-(void)quitLiveChat;

#pragma mark --请求主讲人信息
-(void)getLivePlayDetail:(NSString *)liveId;
#pragma mark -- 切换聊天室
- (void)switchToLiveRoom:(NSString *)groupId;
#pragma mark -- 创建聊天室
- (void)createLiveRoom:(void (^)(int, NSString *))handler;
#pragma mark -- 加入聊天室
- (void)joinLiveRoom:(NSString *)groupId handler:(void (^)(int))handler;
#pragma mark -- 退出聊天室
- (void)quitLiveRoom:(NSString *)groupId handler:(void (^)(int))handler;

@end







