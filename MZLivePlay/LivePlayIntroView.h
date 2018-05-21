//
//  LivePlayIntroView.h
//  XuanYan
//
//  Created by mz on 2017/11/13.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivePlayIntroView : UIView
@property(nonatomic,strong)UILabel *videoTitle;
@property(nonatomic,strong)UILabel *videoSubject;
@property(nonatomic,strong)UILabel *expertInfor;
@property(nonatomic,strong)UILabel *videoDuration;
@property(nonatomic,strong)UIButton *seeMoreBtn;
@property(nonatomic,copy)void(^inforClicked)();

@property(nonatomic,copy)void(^seeMoreClicked)();

-(void)setUpView;
@end
