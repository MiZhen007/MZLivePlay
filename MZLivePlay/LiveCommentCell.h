//
//  LiveCommentCell.h
//  XuanYan
//
//  Created by mz on 2017/11/8.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    VerticalChat=0,
    FullScreenChat,
    
} LiveChatCellStyle;


@interface LiveCommentCell : UITableViewCell

@property(nonatomic,assign)CGFloat portraitDiameter;//评论人头像视图尺寸

@property(nonatomic,strong)UIImageView *portraitIV;//评论人头像
@property(nonatomic,strong)UILabel *commentTitle;//评论人名称
@property(nonatomic,strong)UILabel *commentDate;//评论日期
@property(nonatomic,strong)MZContentLabel *commentContent;//评论文字内容

@property(nonatomic,strong)UILabel *topLine;    //顶部分割线

@property(nonatomic,strong)UIButton *msgSendStatus;    //底部分割线

@property(nonatomic,strong)void (^msgSendStatusFailedClicked)();

//
-(void)refreshData:(CommentModel *)commentModel;
//改变cell风格
-(void)changeCellStyle:(LiveChatCellStyle )cellStyle;

//消息正在发送中模式
-(void)messageSending;
//消息发送成功
-(void)messageSended;
//消息发送失败
-(void)messageSendFailed;

@end












