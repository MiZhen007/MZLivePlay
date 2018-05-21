//
//  LiveHeaderView.m
//  XuanYan
//
//  Created by mz on 17/1/6.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import "LiveHeaderView.h"

@interface LiveHeaderView(){
    
}
@end

@implementation LiveHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self setUpView];
    return self;
}

-(void)setUpView{
    //小图标
    UILabel *smallIcon=[[UILabel alloc] initWithFrame:CGRectMake(10, 2, 5, Adapt(LiveCellTitleLabel_Height)-4)];
    smallIcon.backgroundColor=StyleColor;
    [self addSubview:smallIcon];
    //
    _cellTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(25, 0, 120, Adapt(LiveCellTitleLabel_Height))];
    _cellTitleLabel.text=@"专家";
    _cellTitleLabel.textAlignment=NSTextAlignmentLeft;
    _cellTitleLabel.font=[UIFont systemFontOfSize:Adapt(LiveCellTitleLabel_Height/2)];
    [_cellTitleLabel setTextColor:[UIColor blackColor]];
    [self addSubview:_cellTitleLabel];
    //右侧查看更多
    NSInteger btnWidth=100;
    _seeMoreBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-btnWidth-10, 0, btnWidth, Adapt(LiveCellTitleLabel_Height))];
    [_seeMoreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    _seeMoreBtn.titleLabel.textAlignment=NSTextAlignmentRight;
    _seeMoreBtn.titleLabel.font=[UIFont systemFontOfSize:Adapt(LiveCellTitleLabel_Height/5*2)];
    [_seeMoreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_seeMoreBtn addTarget:self action:@selector(seeMoreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_seeMoreBtn];
    _seeMoreBtn.hidden=YES;
    //按钮右侧的指示箭头
    UIImageView *arrowView=[[UIImageView alloc] initWithFrame:CGRectMake(_seeMoreBtn.current_w-_seeMoreBtn.current_h/3, _seeMoreBtn.current_h/3, _seeMoreBtn.current_h/6, _seeMoreBtn.current_h/3)];
    arrowView.image=[UIImage imageNamed:@"ArrowRightGray"];
    [_seeMoreBtn addSubview:arrowView];
}
-(void)seeMoreBtnClicked:(UIButton *)btn{
    if (self.seeMoreBtnClicked) {
        self.seeMoreBtnClicked();
    }
}

@end
















