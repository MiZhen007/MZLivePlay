//
//  LivePlayIntroView.m
//  XuanYan
//
//  Created by mz on 2017/11/13.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import "LivePlayIntroView.h"

@implementation LivePlayIntroView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self setUpView];
    return self;
}

-(void)setUpView{
    //
    self.backgroundColor=[UIColor whiteColor];
    //
    _videoTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.current_w-50, 0)];
    //    _videoTitle.backgroundColor=LightBackgroundColor;
    _videoTitle.text=@"";
    _videoTitle.numberOfLines=1;
    _videoTitle.lineBreakMode=NSLineBreakByTruncatingTail;
    _videoTitle.textAlignment=NSTextAlignmentCenter;
    _videoTitle.font=[UIFont systemFontOfSize:18];
    [self addSubview:_videoTitle];
    //
    _videoSubject=[[UILabel alloc] initWithFrame:CGRectMake(10, _videoTitle.current_y_h,SCREEN_WIDTH-30, 40)];
    //    _videoSubject.backgroundColor=LightBackgroundColor;
    _videoSubject.text=@"";
    _videoSubject.numberOfLines=0;
    //    _videoSubject.lineBreakMode=NSLineBreakByTruncatingMiddle;
    _videoSubject.lineBreakMode=NSLineBreakByTruncatingTail;
    _videoSubject.textAlignment=NSTextAlignmentLeft;
    _videoSubject.font=[UIFont systemFontOfSize:16];
    [self addSubview:_videoSubject];
    //
//    _expertInfor=[[UILabel alloc] initWithFrame:CGRectMake(10, _videoSubject.current_y_h, self.current_w-50, 10)];
//    //    _expertInfor.backgroundColor=LightBackgroundColor;
//    _expertInfor.numberOfLines=1;
//    _expertInfor.lineBreakMode=NSLineBreakByTruncatingTail;
//    _expertInfor.textAlignment=NSTextAlignmentLeft;
//    _expertInfor.font=[UIFont systemFontOfSize:16];
//    [self addSubview:_expertInfor];
    //
    _videoDuration=[[UILabel alloc] initWithFrame:CGRectMake(10, _videoSubject.current_y_h, self.current_w-50, 25)];
    //    _expertInfor.backgroundColor=LightBackgroundColor;
    _videoDuration.numberOfLines=1;
    _videoDuration.lineBreakMode=NSLineBreakByTruncatingTail;
    _videoDuration.textAlignment=NSTextAlignmentLeft;
    _videoDuration.font=[UIFont systemFontOfSize:16];
    [self addSubview:_videoDuration];
    ////
    /////
    UILabel *headerViewLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, _videoDuration.current_y_h, self.current_w, 30)];
    headerViewLabel.backgroundColor=[UIColor whiteColor];
    headerViewLabel.text=@"发言区";
    headerViewLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:headerViewLabel];
    //
    //
    UIImageView *commitImageView=[[UIImageView alloc] initWithFrame:CGRectMake(headerViewLabel.current_x, headerViewLabel.current_y-5, 40, 40)];
    [commitImageView setImage:[UIImage imageNamed:@"CommitIcon"]];
    [self addSubview:commitImageView];
    [commitImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerViewLabel.centerX).offset(-40);
        make.centerY.equalTo(headerViewLabel.centerY);
    }];
    //    //指示箭头
    //    UIImageView *arrowImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 18, 25)];
    //    arrowImageView.image=[UIImage imageNamed:@"ArrowRightGray"];
    //    [self.contentView addSubview:arrowImageView];
    //    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.contentView).offset(-20);
    //        make.bottom.equalTo(self.contentView.mas_bottom).offset(5);
    ////        make.centerY.equalTo(self.contentView);
    //        make.width.equalTo(12);
    //        make.height.equalTo(20);
    //    }];
    //右侧查看更多
    NSInteger btnWidth=90;
    
    //
    UITapGestureRecognizer *viewTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked)];
    viewTap.numberOfTapsRequired=1;
    [self addGestureRecognizer:viewTap];
//    _seeMoreBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-btnWidth-20, Adapt(LiveVideoIntroCell_Height)-Adapt(LiveCellTitleLabel_Height), btnWidth, Adapt(LiveCellTitleLabel_Height))];
//    [_seeMoreBtn setBackgroundColor:[UIColor redColor]];
//    [_seeMoreBtn.layer setCornerRadius:5];
//    [_seeMoreBtn.layer setMasksToBounds:YES];
//    [_seeMoreBtn setTitle:@"现在评价" forState:UIControlStateNormal];
//    _seeMoreBtn.userInteractionEnabled=NO;
//    _seeMoreBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
//    //    seeMoreBtn.titleLabel.font=[UIFont systemFontOfSize:Adapt(LiveCellTitleLabel_Height/5*2)];
//    _seeMoreBtn.titleLabel.font=[UIFont systemFontOfSize:16];
//    [_seeMoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_seeMoreBtn addTarget:self action:@selector(seeMoreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_seeMoreBtn];
//    [_seeMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(-20);
//        make.bottom.equalTo(self.mas_bottom).offset(-5);
//        //        make.centerY.equalTo(self.contentView);
//        make.width.equalTo(@90);
//        //        make.height.equalTo(20);
//    }];
    //    //按钮右侧的指示箭头
    //    UIImageView *arrowView=[[UIImageView alloc] initWithFrame:CGRectMake(seeMoreBtn.current_w-seeMoreBtn.current_h/3, seeMoreBtn.current_h/3, seeMoreBtn.current_h/6, seeMoreBtn.current_h/3)];
    //    arrowView.image=[UIImage imageNamed:@"ArrowRightGray"];
    //    [seeMoreBtn addSubview:arrowView];
    
}
-(void)viewClicked{
    if (self.seeMoreClicked) {
        self.seeMoreClicked();
    }
}

@end














