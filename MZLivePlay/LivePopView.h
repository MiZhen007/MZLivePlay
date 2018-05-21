//
//  LivePopView.h
//  XuanYan
//
//  Created by mz on 2017/11/15.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivePopView : UIView

@property(nonatomic,strong)NSString * courseId;
//弹框取消
@property(nonatomic,strong)void(^viewCancle)();
//确认退出直播
@property(nonatomic,strong)void(^viewQuit)();

-(void)showAlertView;

@end
