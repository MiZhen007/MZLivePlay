//
//  ChatFrameModel.m
//  chat
//
//  Created by T_Yang on 15/9/2.
//  Copyright © 2015年 杨 天. All rights reserved.
//

#import "ChatFrameModel.h"

@implementation ChatFrameModel

- (void)setChatModel:(ChatModel *)chatModel {
    _chatModel = chatModel;
    
    //设置标题label的高度 如果相同 高度为0 即不显示
    CGFloat titleLabelHeight = chatModel.hiddenTime ? 0 : 30;
    

#define kContentBtnWidth (contentBtnSize.width + 20)
#define kContentBtnHeight (contentBtnSize.height + 10)
    
    //间距
    CGFloat margin = 5;
    //头像大小
    CGFloat iconWH = Adapt(ChatProfileViewWidth);
    //文字大小
    CGSize contentBtnSize = [self sizeWithText:_chatModel.content];
    //头像大小 50 * 50
    if ([_chatModel.type isEqualToNumber:@0]) {
        _iconImageViewFrame = CGRectMake(SCREEN_WIDTH - iconWH - margin, CGRectGetMaxY(_titleLabelFrame), iconWH, iconWH);
        _titleLabelFrame = CGRectMake(0, 0, SCREEN_WIDTH, titleLabelHeight);

        _contentBtnFrame = CGRectMake(SCREEN_WIDTH - kContentBtnWidth - iconWH - margin - margin,
                                      CGRectGetMaxY(_titleLabelFrame),
                                      kContentBtnWidth,
                                      kContentBtnHeight);
    }else {
        _iconImageViewFrame = CGRectMake(margin, 5, iconWH, iconWH);
        _titleLabelFrame = CGRectMake(_iconImageViewFrame.size.width+5+margin, 0, SCREEN_WIDTH, titleLabelHeight);

        _contentBtnFrame = CGRectMake(margin + iconWH + margin, CGRectGetMaxY(_iconImageViewFrame),kContentBtnWidth, kContentBtnHeight);
    }
    _cellHeight = MAX(CGRectGetMaxY(_contentBtnFrame), CGRectGetMaxY(_titleLabelFrame)) + margin;
}
- (void)setMessageModel:(MZChatModel *)chatModel {
    _chatMessageModel = chatModel;
    
    //设置标题label的高度 如果相同 高度为0 即不显示
    CGFloat titleLabelHeight = 30;
    
    
#define kContentBtnWidth (contentBtnSize.width + 20)
#define kContentBtnHeight (contentBtnSize.height + 10)
    
    //间距
    CGFloat margin = 5;
    //头像大小
    CGFloat iconWH = Adapt(ChatProfileViewWidth);
    //文字大小
    CGSize contentBtnSize = [self sizeWithText:_chatMessageModel.text];
    //头像大小 50 * 50
    if (_chatMessageModel.role!=50) {
        _iconImageViewFrame = CGRectMake(margin, 5, iconWH, iconWH);
        _titleLabelFrame = CGRectMake(_iconImageViewFrame.size.width+5+margin, 0, SCREEN_WIDTH, titleLabelHeight);
        
        _contentBtnFrame = CGRectMake(margin + iconWH + margin, CGRectGetMaxY(_iconImageViewFrame),kContentBtnWidth, kContentBtnHeight);
    }
    else{
        _iconImageViewFrame = CGRectMake(SCREEN_WIDTH - iconWH - margin, CGRectGetMaxY(_titleLabelFrame), iconWH, iconWH);
        _titleLabelFrame = CGRectMake(0, 0, SCREEN_WIDTH-iconWH-margin-10, titleLabelHeight);
        
        _contentBtnFrame = CGRectMake(SCREEN_WIDTH - kContentBtnWidth - iconWH - margin - margin,
                                      CGRectGetMaxY(_titleLabelFrame),
                                      kContentBtnWidth,
                                      kContentBtnHeight);

    }


//    if (_chatMessageModel.role==0) {
//        _iconImageViewFrame = CGRectMake(SCREEN_WIDTH - iconWH - margin, CGRectGetMaxY(_titleLabelFrame), iconWH, iconWH);
//        _titleLabelFrame = CGRectMake(0, 0, SCREEN_WIDTH, titleLabelHeight);
//        
//        _contentBtnFrame = CGRectMake(SCREEN_WIDTH - kContentBtnWidth - iconWH - margin - margin,
//                                      CGRectGetMaxY(_titleLabelFrame),
//                                      kContentBtnWidth,
//                                      kContentBtnHeight);
//    }else {
//        _iconImageViewFrame = CGRectMake(margin, 5, iconWH, iconWH);
//        _titleLabelFrame = CGRectMake(_iconImageViewFrame.size.width+5+margin, 0, SCREEN_WIDTH, titleLabelHeight);
//        
//        _contentBtnFrame = CGRectMake(margin + iconWH + margin, CGRectGetMaxY(_iconImageViewFrame),kContentBtnWidth, kContentBtnHeight);
//    }
    _cellHeight = MAX(CGRectGetMaxY(_contentBtnFrame), CGRectGetMaxY(_titleLabelFrame)) + margin;
}

- (CGSize)sizeWithText:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 150, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:ChatFontSize]}
                              context:nil].size;
}


@end




















