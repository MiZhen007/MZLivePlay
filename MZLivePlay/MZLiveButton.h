//
//  MZLiveButton.h
//  XuanYan
//
//  Created by mz on 17/4/20.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZLiveButton : UIButton

@property(nonatomic,strong)UILabel *badgeLabel;
@property(nonatomic,assign)BOOL badgeEnableFlag;
//角标显示数字
-(void)setBadgeNumber:(NSInteger )badgeNum;
//右上角红色角标开关控制
-(void)showBadge;
-(void)closeBadge;
-(void)unenableBadge;
-(void)enableBadge;
@end
