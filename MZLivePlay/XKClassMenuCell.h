//
//  XKClassMenuCell.h
//  XuanYan
//
//  Created by qiaoxuekui on 2017/6/15.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKClassMenuCell : UICollectionViewCell

@property (nonatomic,strong)UILabel * classNameLabel;
@property (nonatomic,strong)UIImageView * classImage;

-(void)setModel:(XKMainSeriesModel *)model;

@end
