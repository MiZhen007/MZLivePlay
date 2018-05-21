//
//  LiveHeaderView.h
//  XuanYan
//
//  Created by mz on 17/1/6.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveHeaderView : UIView
//cell的标题label
@property(nonatomic,strong)UILabel *cellTitleLabel;
@property(nonatomic,strong)UIButton *seeMoreBtn;

@property(nonatomic,copy)void(^seeMoreBtnClicked)();

@end







