

//
//  LivePopView.m
//  XuanYan
//
//  Created by mz on 2017/11/15.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import "LivePopView.h"


// AlertW 宽
#define AlertW SCREEN_WIDTH/2
// AlertW 高
#define AlertH SCREEN_HEIGHT/5*3
// 各个栏目之间的距离
#define MKPSpace 10.0

@interface LivePopView (){
    
}

/** 弹窗 */
@property(nonatomic,retain) UIView *alertView;
/** title */
@property(nonatomic,retain) UILabel *titleLbl;
/** 内容 */
@property(nonatomic,retain) UILabel *msgLbl;
/** 图片 */
@property(nonatomic,retain) UIImageView *backImageView;
/** 确认按钮 */
@property(nonatomic,retain) UIButton *sureBtn;
/** 离开按钮 */
@property(nonatomic,retain) UIButton *quitBtn;
/** 取消按钮 */
@property(nonatomic,retain) UIButton *cancleBtn;
/** 横线 */
@property(nonatomic,retain) UIView *lineView;
/** 竖线 */
@property(nonatomic,retain) UIView *verLineView;

@end

@implementation LivePopView

-(instancetype)init{
    if(self == [super init]){
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 5.0;
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, AlertH);
        self.alertView.layer.position = self.center;
        //        self.alertView.layer.position=CGPointMake(self.center.x, SCREEN_HEIGHT-AlertH/2);
        
        [self addSubview:self.alertView];
        
        //
        _backImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
        _backImageView.backgroundColor=[UIColor whiteColor];
        [_backImageView setImage:[UIImage imageNamed:@"HornNotice"]];
        [self.alertView addSubview:_backImageView];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertView.mas_top).offset(20);
            make.centerX.equalTo(self.alertView);
            make.height.equalTo(self.alertView.mas_height).dividedBy(3);
            make.width.equalTo(self.alertView.mas_width).dividedBy(3);
        }];
        //
        _cancleBtn=[[UIButton alloc] initWithFrame:CGRectZero];
        [_cancleBtn addTarget:self action:@selector(closeCommentView) forControlEvents:UIControlEventTouchUpInside];
        [_cancleBtn setImage:[UIImage imageNamed:@"cancleBtn"] forState:UIControlStateNormal];
        //        _cancleBtn.backgroundColor=[UIColor redColor];
        [self.alertView addSubview:_cancleBtn];
        [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alertView.mas_top).offset(0);
            make.left.equalTo(self.alertView.mas_right).offset(-30);
            make.width.equalTo(30);
            make.height.equalTo(30);
        }];
        //
        UILabel *starLable=[[UILabel alloc] initWithFrame:CGRectZero];
        starLable.textAlignment = NSTextAlignmentCenter;
        starLable.text=@"请注意您的直播结束时间，超过将无法继续直播！";
        starLable.numberOfLines=0;
        starLable.font=XKFont(18.f);
        starLable.textColor=[MZTools colorWithHexString:@"#212121"];
        starLable.backgroundColor=[UIColor whiteColor];
        [self.alertView addSubview:starLable];
        [starLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backImageView.mas_bottom).offset(10);
            make.centerX.equalTo(self.alertView);
            make.width.equalTo(self.alertView).offset(-20);
            make.height.equalTo(60);
        }];
        //
        _quitBtn=[[UIButton alloc] initWithFrame:CGRectZero];
        [_quitBtn addTarget:self action:@selector(quitClicked) forControlEvents:UIControlEventTouchUpInside];
        [_quitBtn setTitle:@"确定离开" forState:UIControlStateNormal];
        //        [_cancleBtn setImage:[UIImage imageNamed:@"cancleBtn"] forState:UIControlStateNormal];
        //
        [_quitBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        _quitBtn.backgroundColor=[UIColor lightGrayColor];
        [self.alertView addSubview:_quitBtn];
        [_quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.alertView);
            make.right.equalTo(self.alertView.centerX);
            make.width.equalTo(self.alertView).dividedBy(2);
            make.height.equalTo(40);
        }];
        _sureBtn=[[UIButton alloc] initWithFrame:CGRectZero];
        [_sureBtn addTarget:self action:@selector(closeCommentView) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitle:@"继续直播" forState:UIControlStateNormal];
        //        [_cancleBtn setImage:[UIImage imageNamed:@"cancleBtn"] forState:UIControlStateNormal];
        //
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.backgroundColor=StyleColor;
        [self.alertView addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.alertView);
            make.left.equalTo(self.alertView.centerX);
            make.width.equalTo(self.alertView).dividedBy(2);
            make.height.equalTo(40);
        }];
    }
    return self;
}

#pragma mark - 弹出
-(void)showAlertView
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

-(void)creatShowAnimation
{
    //    self.alertView.layer.position=CGPointMake(self.center.x, SCREEN_HEIGHT-AlertH/2);
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 回调 只设置2 -- > 确定才回调
- (void)closeCommentView
{
    if (self.viewCancle) {
        self.viewCancle();
    }
    [self removeFromSuperview];
}
-(void)quitClicked{
    if (self.viewQuit) {
        self.viewQuit();
    }
    [self removeFromSuperview];
}

@end

















