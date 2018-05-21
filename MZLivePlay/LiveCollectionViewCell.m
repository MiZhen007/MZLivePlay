//
//  LiveCollectionViewCell.m
//  XuanYan
//
//  Created by mz on 16/11/29.
//  Copyright © 2016年 mizhen. All rights reserved.
//

#import "LiveCollectionViewCell.h"


@interface LiveCollectionViewCell(){
    //视频框的大小
    CGSize videoFrameSize;
}
@end

@implementation LiveCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    videoFrameSize=frame.size;
    [self setUpView];
    return self;
}

-(void)setUpView{
//    if (self.contentView.subviews.count>0) {
//        return;
//    }
    self.backgroundColor=[UIColor whiteColor];
    _videoBriefView=[[VideoBriefView alloc] initWithFrame:CGRectMake( 0, 0, videoFrameSize.width, videoFrameSize.height)];
//    if (_liveModel.roomStatus!=2) {
//        [_videoBriefView addAdvanceView];
//    }
//    else{
//    }
    [self.contentView addSubview:_videoBriefView];
    
    _videoBriefView.userInteractionEnabled=NO;
    
//    [_videoBriefView addAdvanceView];

//    _videoBriefView.videoTitleLabel.text=_liveModel.subject;
//    [_videoBriefView.videoThumbImageView sd_setImageWithURL:[NSURL URLWithString:_liveModel.thumbUrl] placeholderImage:[UIImage imageNamed:@"//Text02.jpg"]];
}

-(void)setLiveModel:(LiveRoomDetailModel *)liveModel{
    _liveModel=liveModel; 
//    if (_liveModel.liveStatus.integerValue==1) {
//        _videoBriefView.advanceLabel.hidden=YES;
//    }
//    else{
//        _videoBriefView.advanceLabel.hidden=NO;  
//    }
    [_videoBriefView.videoThumbImageView sd_setImageWithURL:[NSURL URLWithString:_liveModel.thumbUrl] placeholderImage:[UIImage imageNamed:@"//Text02.jpg"]];
    
    _videoBriefView.videoTitleLabel.text=_liveModel.lessonSubject;

}
//刷新数据
-(void)updateData{

}

-(void)cellButtonClicked{
    
}

@end

















