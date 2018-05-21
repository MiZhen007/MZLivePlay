//
//  MZFullViewBtn.m
//  XuanYan
//
//  Created by mz on 16/10/8.
//  Copyright © 2016年 mizhen. All rights reserved.
//

#import "MZFullViewBtn.h"

@implementation MZFullViewBtn

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    btn.userInteractionEnabled=YES;
    [btn setBackgroundImage:[UIImage imageNamed:@"FullScreen.png"] forState:UIControlStateNormal];
    //    fullScreenBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,fullScreenBtnSize.width,fullScreenBtnSize.width);
    //_fullScreenBtn.backgroundColor=[UIColor yellowColor];
    [btn addTarget:self action:@selector(fullScreenClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return self;
}
-(void)fullScreenClicked:(UIButton *)button{
    if (self.fullViewBtnClicked) {
        self.fullViewBtnClicked();
    }
}
@end
