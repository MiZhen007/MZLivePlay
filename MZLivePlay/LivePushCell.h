//
//  LivePushCell.h
//  XuanYan
//
//  Created by mz on 2017/11/8.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

//直播推流model
@interface LivePushModel : NSObject <NSCoding>
@property (nonatomic, copy) NSString *expertName;
@property (nonatomic, copy) NSString *seriesId;
@property (nonatomic, copy) NSString *seriesName;
@property (nonatomic, copy) NSString *seriesImage;
@property (nonatomic, copy) NSString *seriesType;

@property (nonatomic, copy) NSString *seriesMarkPrice;
@property (nonatomic, copy) NSString *seriesPayPrice;

@property (nonatomic, copy) NSString *classNumber;
@property (nonatomic, copy) NSString *isBuy;
///
@property (nonatomic, copy) NSString *startTime;//已消费的金额
@property (nonatomic, copy) NSString *endTime;//已购买数量


@property (nonatomic, copy) NSString *isSelect;

YXWithDictH(LivePushModel)

@end





@interface LivePushCell : UITableViewCell

- (void) setModel:(LivePushModel *)model;
//类型
@property(nonatomic,assign)NSInteger cellType;


@property(nonatomic,assign)CGFloat moveNum;
//
@property(nonatomic,strong)UIImageView * liveImage;
@property(nonatomic,strong)UILabel * liveLabel;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * subTitleLabel;
@property(nonatomic,strong)UILabel * classNumLabel;
//
@property(nonatomic,strong)UILabel * consumedNumLabel;//购买课程情况

@property(nonatomic,strong)UIButton * detailButton;
@property(nonatomic,strong)UIButton * learnButton;

@property(nonatomic,copy)void(^didSelectdDetail)(NSInteger liveIndex);
@property(nonatomic,copy)void(^didSelectdLearn)(NSInteger liveIndex);
@end
