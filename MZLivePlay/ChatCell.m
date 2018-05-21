//
//  ChatCell.m
//  chat
//
//  Created by T_Yang on 15/9/2.
//  Copyright © 2015年 杨 天. All rights reserved.
//

#import "ChatCell.h"

@interface ChatCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) MZContentLabel *contentLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation ChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = LightBackgroundColor;
        
        _frameModel=[[ChatFrameModel alloc] init];
        _frameModel.chatModel=[[ChatModel alloc] init];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.clipsToBounds = YES;
        titleLabel.textColor=[UIColor grayColor];
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        iconImageView.layer.cornerRadius = 7;
        iconImageView.layer.masksToBounds = YES;
        iconImageView.layer.borderWidth = 1.0f;
        
//        UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.contentView addSubview:contentBtn];
//        self.contentBtn = contentBtn;
//        UIImage *btnBackImage = [UIImage imageNamed:@"chat_send_nor"];
//        [contentBtn setBackgroundImage:[btnBackImage stretchableImageWithLeftCapWidth:btnBackImage.size.width / 2
//                                                                         topCapHeight:btnBackImage.size.height / 2]
//                              forState:UIControlStateNormal];
//        [contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        contentBtn.titleLabel.numberOfLines = 0;
//        contentBtn.backgroundColor=[UIColor whiteColor];
//        contentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        contentBtn.titleEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        //
        _contentLabel=[[MZContentLabel alloc] init];
        [_contentLabel setTextColor:[UIColor blackColor]];
        _contentLabel.backgroundColor=[UIColor whiteColor];
        _contentLabel.font=[UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines=0;
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}

- (void)setFrameModel:(ChatFrameModel *)frameModel {
    _frameModel = frameModel;
    _frameModel.chatModel=frameModel.chatModel;
    
    [self setSubviewsData];
    
    [self setSubviewsFrame];
    //
}

- (void)setSubviewsData {
    [self.contentLabel setWithString:self.frameModel.chatModel.content fontSize:15.f fontColor:[UIColor darkTextColor] lineSpace:7 breakMode:NSLineBreakByCharWrapping  textAlighment:NSTextAlignmentLeft];

//    [self.contentLabel setTitle:self.frameModel.chatModel.content forState:UIControlStateNormal];
    
    if (self.frameModel.chatModel.isQuestion==YES) {
        self.titleLabel.text = [NSString stringWithFormat:@"问：%@",self.frameModel.chatModel.ownerName];

        self.iconImageView.image = [UIImage imageNamed:@"LiveStudent"];
//       [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ResourceAddress, [MZUserKit obtainUserInforModelFromDocument].portrait]] placeholderImage:[UIImage imageNamed:@"LiveStudent"]];
    }
    else{
        self.titleLabel.text = [NSString stringWithFormat:@"答：%@",self.frameModel.chatModel.ownerName];

        self.iconImageView.image = [UIImage imageNamed:@"LiveTeacher"];
        
    }
}

- (void)setSubviewsFrame {
//    [self.frameModel setChatModel:_frameModel.chatModel];
    
    self.titleLabel.frame = self.frameModel.titleLabelFrame;
    CGSize contentMaxSize = CGSizeMake(SCREEN_WIDTH - 24, MAXFLOAT);
    CGSize contentStringSize = [self.contentLabel.attributedText boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    self.contentLabel.frame = CGRectMake(12, _titleLabel.current_y_h+20, ceil(contentStringSize.width), ceil(contentStringSize.height));
    self.contentLabel.frame = self.frameModel.contentBtnFrame;
    self.iconImageView.frame = self.frameModel.iconImageViewFrame;
    self.iconImageView.layer.cornerRadius=self.iconImageView.frame.size.width/2;
    
}

@end
