//
//  LiveCollectionViewCell.h
//  XuanYan
//
//  Created by mz on 16/11/29.
//  Copyright © 2016年 mizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveCollectionViewCell : UICollectionViewCell


@property(nonatomic,strong)LiveRoomDetailModel *liveModel;

@property(nonatomic,strong)VideoBriefView *videoBriefView;

-(void)setUpView;
-(void)updateData;
@end








