//
//  LiveModuleCVCell.m
//  XuanYan
//
//  Created by mz on 16/11/4.
//  Copyright © 2016年 mizhen. All rights reserved.
//

#import "LiveModuleCVCell.h"

@implementation LiveModuleCVCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    if (self.contentView.subviews.count>0) {
        return;
    }
    
    _cellButton=[[UIButton alloc] initWithFrame:self.frame];
//    _cellButton.backgroundColor=[UIColor yellowColor];
    
    _cellButton.contentMode=UIViewContentModeScaleToFill;
    [_cellButton addTarget:self action:@selector(cellButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //[self.contentView addSubview:_cellButton];
    //
    _backgroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.current_w, self.current_h)];
    [self.contentView addSubview:_backgroundImageView];
    
//    NSInteger labelHeight=30;
//    _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, (self.current_h-labelHeight)/2, self.current_w, labelHeight)];
    _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.current_w, self.current_h)];
    _titleLabel.backgroundColor=[UIColor blackColor];
    _titleLabel.alpha=0.6;
    _titleLabel.textColor=[UIColor whiteColor];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.font=[UIFont fontWithName:@"STHeitiSC-Light" size:22];
    [self.contentView addSubview:_titleLabel];
}
-(void)cellButtonClicked{
    
}
@end






















