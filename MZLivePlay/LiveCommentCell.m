//
//  LiveCommentCell.m
//  XuanYan
//
//  Created by mz on 2017/11/8.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import "LiveCommentCell.h"
#import "MZQaView.h"
@implementation LiveCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self){
        return nil;
    }
    /////
    [self setUpData];
    ///
    [self setUpView];
    
    return self;
    
}
-(void)setUpData{
    //
    _portraitDiameter=34.0;
    //
}
//切换风格模式
-(void)changeCellStyle:(LiveChatCellStyle )cellStyle{
    if (cellStyle==VerticalChat) {
        _topLine.hidden=NO;
        
        _commentTitle.textColor=[UIColor darkGrayColor];
        _commentTitle.backgroundColor=[UIColor clearColor];
        
        //评论内容
        [_commentContent setWithfontSize:ChatFontSize fontColor:[UIColor darkTextColor] lineSpace:ChatLineSpace breakMode:NSLineBreakByCharWrapping textAlighment:NSTextAlignmentLeft];
        CGSize contentMaxSize = CGSizeMake(SCREEN_WIDTH - 24, MAXFLOAT);
        CGSize contentStringSize = [_commentContent.attributedText boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
//        _commentContent.frame = CGRectMake(15, 0, ceil(contentStringSize.width), ceil(contentStringSize.height));
        
        //
        _commentContent.backgroundColor=[UIColor clearColor];
        //
        [_commentContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.left.equalTo(_portraitIV.mas_right).offset(10);
            //        make.top.equalTo(_commentDate.mas_bottom).offset(5);
            make.top.equalTo(_commentTitle.mas_bottom).offset(5);
        }];
        //
    }
    else{
        _topLine.hidden=YES;
        
        _commentTitle.textColor=[UIColor lightGrayColor];
        _commentTitle.backgroundColor=[UIColor colorWithWhite:0.3 alpha:0.4];
        ////
        //评论内容
        [_commentContent setWithfontSize:ChatFontSize fontColor:[UIColor whiteColor] lineSpace:ChatLineSpace breakMode:NSLineBreakByCharWrapping textAlighment:NSTextAlignmentLeft];
        CGSize contentMaxSize = CGSizeMake(H_ChatViewWidth - 24, MAXFLOAT);
        CGSize contentStringSize = [_commentContent.attributedText boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//        _commentContent.frame = CGRectMake(15, 0, ceil(contentStringSize.width), ceil(contentStringSize.height));
        ////
        _commentContent.backgroundColor=[UIColor colorWithWhite:0.3 alpha:0.4];
        ////
        if (contentStringSize.width<contentMaxSize.width-10) {
            [_commentContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_left).offset(contentStringSize.width+60);
                make.left.equalTo(_portraitIV.mas_right).offset(10);
                //        make.top.equalTo(_commentDate.mas_bottom).offset(5);
                make.top.equalTo(_commentTitle.mas_bottom).offset(5);
            }];
        }
        else{
            //
            [_commentContent mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-10);
                make.left.equalTo(_portraitIV.mas_right).offset(10);
                //        make.top.equalTo(_commentDate.mas_bottom).offset(5);
                make.top.equalTo(_commentTitle.mas_bottom).offset(5);
            }];
            
        }
    }
}

-(void)setUpView{
    
    //评论人头像
    _portraitIV=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, _portraitDiameter, _portraitDiameter)];
    _portraitIV.backgroundColor=StyleColor;
    _portraitIV.layer.cornerRadius =_portraitDiameter/2;
    _portraitIV.layer.masksToBounds = YES;
    [self.contentView addSubview:_portraitIV];
    [_portraitIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(5);
        make.width.equalTo(_portraitDiameter);
        make.height.equalTo(_portraitDiameter);
    }];
    
    //评论人名称
    _commentTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    _commentTitle.font=[UIFont systemFontOfSize:14.0];
    _commentTitle.textColor=[UIColor darkGrayColor];
    [self.contentView addSubview:_commentTitle];
    [_commentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_portraitIV.mas_right).offset(10);
        make.top.equalTo(_portraitIV);
//        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    //评论日期
    _commentDate=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,150 , 20)];
    _commentDate.font=[UIFont systemFontOfSize:13.0];
    _commentDate.textColor=[UIColor grayColor];
    [self.contentView addSubview:_commentDate];
    [_commentDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_portraitIV.mas_right).offset(10);
        make.top.equalTo(_commentTitle.mas_bottom).offset(5);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    //评论文字内容
    _commentContent=[[MZContentLabel alloc] initWithFrame:CGRectMake(_portraitIV.current_x_w+10, _commentTitle.current_y_h+5, 0, 0)];
    [_commentContent setTextColor:[UIColor blackColor]];
//    _commentContent.backgroundColor=[UIColor whiteColor];
    _commentContent.font=[UIFont systemFontOfSize:15];
    _commentContent.numberOfLines=0;
    [self.contentView addSubview:_commentContent];
    
    [_commentContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_portraitIV.mas_right).offset(10);
//        make.top.equalTo(_commentDate.mas_bottom).offset(5);
        make.top.equalTo(_commentTitle.mas_bottom).offset(5);
        make.right.equalTo(self.contentView).offset(-10);
        //        make.width.equalTo(200);
        //        make.height.equalTo(20);
    }];
    //消息状态指示栏
    _msgSendStatus=[[UIButton alloc] initWithFrame:CGRectZero];
    //
    _msgSendStatus.titleLabel.font=[UIFont systemFontOfSize:13.0];
    WeakObj(self, wSelf);
    [_msgSendStatus bk_addEventHandler:^(id  _Nonnull sender) {
        if (wSelf.msgSendStatusFailedClicked) {
            wSelf.msgSendStatusFailedClicked();
        }
    } forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_msgSendStatus];
    [_msgSendStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(_commentContent.mas_bottom).offset(0);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(0);
    }];
    //顶部分割线
    _topLine=[[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH-60, 1)];
    _topLine.backgroundColor=LoginBackColor;
    [self.contentView addSubview:_topLine];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_commentContent);
        make.top.equalTo(0);
        make.right.equalTo(_commentContent);
        make.height.equalTo(1);
    }];
}

-(void)refreshData:(CommentModel *)commentModel{
    ///////////
    //
    [_portraitIV sd_setImageWithURL:[NSURL URLWithString:commentModel.portraitUrl] placeholderImage:[UIImage imageNamed:@"LogoutPortraitImage"]];
    _commentTitle.text=commentModel.title;
    _commentTitle.textColor=[UIColor darkTextColor];
    [_commentTitle sizeToFit];
    _commentTitle.layer.masksToBounds=YES;
    [_commentTitle.layer setCornerRadius:5];
//    [_commentTitle setSize:CGSizeMake(_commentTitle.size.width+40, _commentTitle.size.height)];
    ////////
    _commentDate.text=commentModel.dateTime;
    //评论内容
    [_commentContent setWithString:commentModel.content fontSize:ChatFontSize fontColor:[UIColor darkTextColor] lineSpace:ChatLineSpace breakMode:NSLineBreakByCharWrapping textAlighment:NSTextAlignmentLeft];
    CGSize contentMaxSize = CGSizeMake(self.contentView.frame.size.width-24, MAXFLOAT);
    CGSize contentStringSize = [_commentContent.attributedText boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//    _commentContent.frame = CGRectMake(15, 0, ceil(contentStringSize.width), ceil(contentStringSize.height));
    //
    //
//    if (_commentContent.attributedText.length>0&&contentStringSize.width<250) {
//        [_commentContent mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView.mas_left).offset(contentStringSize.width+80);
//
////            make.width.equalTo(ceil(contentStringSize.width));
//        }];
//    }
    
//    [_commentContent sizeToFit];
//    [_commentContent setSize:CGSizeMake(_commentContent.size.width+40, _commentContent.size.height)];
    _commentContent.layer.masksToBounds=YES;
    [_commentContent.layer setCornerRadius:5];
    ///////
    if (commentModel.messageStatus==1) {
        [self messageSending];
    }
    else if (commentModel.messageStatus==0){
        [self messageSended];

    }
    else if (commentModel.messageStatus==2){
        [self messageSendFailed];

    }
}
//消息正在发送中模式
-(void)messageSending{
    _msgSendStatus.enabled=NO;
    [_msgSendStatus mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_portraitIV.mas_right).offset(10);
        make.top.equalTo(_commentContent.mas_bottom).offset(0);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(15);
    }];
    [_msgSendStatus setTitleColor:StyleColor forState:UIControlStateNormal];
    [_msgSendStatus setTitle:@"正在发送中..." forState:UIControlStateNormal];
}

//消息发送成功
-(void)messageSended{
    [_msgSendStatus mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_portraitIV.mas_right).offset(10);
        make.top.equalTo(_commentContent.mas_bottom).offset(0);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(0);
    }];
    [_msgSendStatus setTitle:@"" forState:UIControlStateNormal];
}
//消息发送失败
-(void)messageSendFailed{
    ///
    _msgSendStatus.enabled=YES;

    [_msgSendStatus mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_portraitIV.mas_right).offset(10);
        make.top.equalTo(_commentContent.mas_bottom).offset(0);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(20);
    }];
    /////
    [_msgSendStatus setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_msgSendStatus setTitle:@"发送失败" forState:UIControlStateNormal];
    ///////
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end














