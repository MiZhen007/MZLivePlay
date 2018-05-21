//
//  XKClassMenuCell.m
//  XuanYan
//
//  Created by qiaoxuekui on 2017/6/15.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import "XKClassMenuCell.h"

@implementation XKClassMenuCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setUpView];
        
    }
    
    return self;
    
}

-(void)setUpView{
    self.backgroundColor=[UIColor whiteColor];
    
    self.classImage=[[UIImageView alloc] initWithFrame:CGRectZero];
    self.classImage.layer.masksToBounds=YES;
    self.classImage.contentMode=UIViewContentModeScaleAspectFill;
    self.classImage.layer.cornerRadius=(SCREEN_WIDTH*0.18)/2;
    [self addSubview:self.classImage];
    [self.classImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(27);
        make.centerX.equalTo(self);
        make.width.equalTo(SCREEN_WIDTH*0.18);
        make.height.equalTo(SCREEN_WIDTH*0.18);
    }];

    //视频标题
    self.classNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.classNameLabel.font=XKFont(15.0f);
    self.classNameLabel.textColor=[MZTools colorWithHexString:@"#333435"];
    self.classNameLabel.backgroundColor=[UIColor clearColor];
    //self.classNameLabel.lineBreakMode=NSLineBreakByCharWrapping;
    self.classNameLabel.textAlignment = NSTextAlignmentCenter;
    //创建一个返回富文本的方法
    
    [self addSubview:self.classNameLabel];
    [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classImage.mas_bottom).offset(5);
        make.centerX.equalTo(self);
        make.height.equalTo(30);
        make.width.equalTo(SCREEN_WIDTH*0.18);
    }];
}

-(void)setModel:(XKMainSeriesModel *)model{
    [self.classImage sd_setImageWithURL:[NSURL URLWithString:model.seriesImage] placeholderImage:nil];
    self.classNameLabel.text = model.seriesName;
    if (model.isSelect.integerValue==1) {
        self.classNameLabel.textColor=NavBarColor;
    }
    else{
        self.classNameLabel.textColor=[MZTools colorWithHexString:@"#333435"];
    }
}


@end
