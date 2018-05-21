//
//  MZFullViewBtn.h
//  XuanYan
//
//  Created by mz on 16/10/8.
//  Copyright © 2016年 mizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZFullViewBtn : UIView

@property(nonatomic,strong)UIButton *fullViewButton;

@property(nonatomic,copy)void (^fullViewBtnClicked)(void);

@end


















