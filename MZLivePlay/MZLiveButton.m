//
//  MZLiveButton.m
//  XuanYan
//
//  Created by mz on 17/4/20.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import "MZLiveButton.h"

@interface MZQaView(){
    CGRect viewFrame;
}
@end

@implementation MZLiveButton

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    _badgeEnableFlag=NO;
    [self setUpView];
    return self;
}
-(void)setUpView{
    self.backgroundColor = [UIColor clearColor];
    _badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.current_w/3*2, 5, 7, 7)];
//    _badgeLabel.text = @"0";
    _badgeLabel.textColor = [UIColor whiteColor];
    _badgeLabel.backgroundColor=[UIColor redColor];
    _badgeLabel.textAlignment = NSTextAlignmentCenter;
    _badgeLabel.layer.cornerRadius=3.5;
    _badgeLabel.layer.masksToBounds =YES;
    _badgeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_badgeLabel];
    //
    _badgeLabel.hidden=YES;
    
}
//角标显示数字
-(void)setBadgeNumber:(NSInteger )badgeNum{
    _badgeLabel.text=[NSString stringWithFormat:@"%ld",badgeNum];
}
//右上角红色角标开关控制
-(void)showBadge{
    if (_badgeEnableFlag) {
        _badgeLabel.hidden=NO;

    }
}
-(void)closeBadge{
    _badgeLabel.hidden=YES;

}
-(void)unenableBadge{
    _badgeEnableFlag=NO;
    _badgeLabel.hidden=YES;
//    _badgeLabel.text=@"0";
}
-(void)enableBadge{
    _badgeEnableFlag=YES;

}

@end
