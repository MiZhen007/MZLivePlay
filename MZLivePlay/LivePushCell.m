//
//  LivePushCell.m
//  XuanYan
//
//  Created by mz on 2017/11/8.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import "LivePushCell.h"

@implementation LivePushCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (!self) {
        return nil;
    }
    
    [self setUpView];
    return self;
}

- (void) setUpView{
    self.userInteractionEnabled=YES;
    //
    UIView *seperatorLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    seperatorLine.backgroundColor=BackColorDark;
    [self.contentView addSubview:seperatorLine];
    //
    self.liveImage=[[UIImageView alloc] initWithFrame:CGRectMake(10,20,SCREEN_WIDTH/3-10,(SCREEN_WIDTH/3)*0.67-15)];
    self.liveImage.contentMode=UIViewContentModeScaleAspectFill;
    self.liveImage.layer.masksToBounds=YES;
    self.liveImage.layer.cornerRadius=4;
    [self.contentView addSubview:self.liveImage];
    [self.liveImage mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.mas_top).offset(20);
        //        make.left.equalTo(self).offset(10);
        //        make.width.equalTo(SCREEN_WIDTH/3-10);
        //        make.height.equalTo((SCREEN_WIDTH/3)*0.67-15);
    }];
    //标直播标签
    self.liveLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.liveLabel.text = @"直播";
    self.liveLabel.font=XKFont(14.0f);
    self.liveLabel.textColor=[UIColor whiteColor];
    self.liveLabel.backgroundColor=OldStyleColor;
    self.liveLabel.lineBreakMode=NSLineBreakByCharWrapping;
    self.liveLabel.numberOfLines=0;
    self.liveLabel.textAlignment = NSTextAlignmentCenter;
    [_liveImage addSubview:self.liveLabel];
    [self.liveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(0);
        make.width.equalTo(40);
        make.height.equalTo(20);
    }];
    
    //视频标题
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _titleLabel.text = @"";
    _titleLabel.font=XKFont(14.0f);
    _titleLabel.textColor=[MZTools colorWithHexString:@"#333435"];
    _titleLabel.backgroundColor=[UIColor clearColor];
    _titleLabel.lineBreakMode=NSLineBreakByCharWrapping;
    _titleLabel.numberOfLines=0;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    //创建一个返回富文本的方法
    
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(_liveImage.mas_right).offset(20);
        make.right.equalTo(self).offset(-5);
        make.height.equalTo(40);
    }];
    
    //
    self.subTitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _subTitleLabel.backgroundColor=[UIColor clearColor];
    _subTitleLabel.lineBreakMode=NSLineBreakByCharWrapping;
    _subTitleLabel.textAlignment = NSTextAlignmentLeft;
    _subTitleLabel.numberOfLines=0;
    //获取要调整颜色的文字位置,调整颜色
    
    [self.contentView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.bottom).offset(5);
        make.left.equalTo(_liveImage.mas_right).offset(20);
        make.right.equalTo(self).offset(-5);
        make.height.equalTo(40);
    }];
    
    UIView *timeBgView=[[UIView alloc] init];
    timeBgView.backgroundColor=[UIColor darkGrayColor];
    timeBgView.alpha=0.35f;
    timeBgView.layer.masksToBounds=YES;
    timeBgView.layer.cornerRadius=4;
    [_liveImage addSubview:timeBgView];
    [timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_liveImage.mas_bottom).offset(-20);
        make.right.equalTo(_liveImage.mas_right).offset(10);
        make.bottom.equalTo(_liveImage.mas_bottom).offset(10);
        make.width.equalTo(90);
    }];
    self.classNumLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _classNumLabel.backgroundColor=[UIColor clearColor];
    _classNumLabel.textAlignment = NSTextAlignmentCenter;
    _classNumLabel.font=XKFont(13.0f);
    //获取要调整颜色的文字位置,调整颜色
    [_liveImage addSubview:_classNumLabel];
    [_classNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_liveImage.mas_bottom).offset(-20);
        make.right.equalTo(_liveImage.mas_right).offset(10);
        make.bottom.equalTo(_liveImage.mas_bottom).offset(0);
        make.width.equalTo(90);
    }];
    ///
    self.consumedNumLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _consumedNumLabel.backgroundColor=[UIColor clearColor];
    _consumedNumLabel.textAlignment = NSTextAlignmentLeft;
    _consumedNumLabel.font=XKFont(13.0f);
    _consumedNumLabel.textColor=[UIColor darkGrayColor];
    //获取要调整颜色的文字位置,调整颜色
    [self.contentView addSubview:_consumedNumLabel];
    [_consumedNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subTitleLabel.mas_bottom).offset(0);
        make.left.equalTo(_subTitleLabel);
        make.height.equalTo(30);
        make.width.equalTo(80);
    }];
    _consumedNumLabel.hidden=YES;
    //
    
    self.learnButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _learnButton.layer.masksToBounds=YES;
    _learnButton.layer.cornerRadius=4;
    [_learnButton setTitle:@"现在学习" forState:UIControlStateNormal];
    _learnButton.titleLabel.font=XKFont(14.f);
    _learnButton.backgroundColor=[MZTools colorWithHexString:@"F75E63"];
    [_learnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_learnButton];
    [_learnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subTitleLabel.bottom).offset(0);
        make.width.equalTo(80);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(30);
    }];
    
    self.detailButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _detailButton.backgroundColor=[UIColor whiteColor];
    _detailButton.layer.masksToBounds=YES;
    _detailButton.layer.cornerRadius=4;
    _detailButton.titleLabel.font=XKFont(14.f);
    _detailButton.layer.borderColor=[MZTools colorWithHexString:@"F75E63"].CGColor;
    _detailButton.layer.borderWidth=1;
    [_detailButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [_detailButton setTitleColor:[MZTools colorWithHexString:@"F75E63"] forState:UIControlStateNormal];
    [self.contentView addSubview:_detailButton];
    [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subTitleLabel.bottom).offset(0);
        make.width.equalTo(80);
        make.right.equalTo(_learnButton.mas_left).offset(-15);
        make.height.equalTo(30);
    }];
    
    [_learnButton bk_addEventHandler:^(id  _Nonnull sender) {
        //如果是审核状态，则进入详情页
        if ([MZConfigure appChecking]) {
            if (self.didSelectdDetail) {
                self.didSelectdDetail(self.tag);
            }
        }
        else{
            if (self.didSelectdLearn) {
                self.didSelectdLearn(self.tag);
            }
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_detailButton bk_addEventHandler:^(id  _Nonnull sender) {
        if (self.didSelectdDetail) {
            self.didSelectdDetail(self.tag);
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
}

-(NSMutableAttributedString*) changeLabelWithText:(NSString*)needText
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    UIFont *font = [UIFont systemFontOfSize:14];
    UIFont *toFont = [UIFont systemFontOfSize:15];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,4)];
    [attrString addAttribute:NSFontAttributeName value:toFont range:NSMakeRange(4,needText.length-4)];
    
    return attrString;
}

- (void) setModel:(XKMainSeriesModel *)model{
    if (_cellType==1) {
        [_learnButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_subTitleLabel.bottom).offset(0);
            make.width.equalTo(0);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.equalTo(30);
        }];
    }
    if (model.seriesType.integerValue==1) {
        _liveLabel.hidden=NO;
    }
    else{
        self.liveLabel.hidden=YES;
    }
    //
    if (model.seriesImage.length>0) {
        [self.liveImage sd_setImageWithURL:[NSURL URLWithString:model.seriesImage] placeholderImage:nil];
    }
    else{
        self.liveImage.image=nil;
    }
    
    if (model.seriesName.length>0) {
        self.titleLabel.text=model.seriesName;
    }
    else{
        self.titleLabel.text=@"";
    }
    
    if (model.expertName.length>0) {
        NSMutableAttributedString *subString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"主讲人：%@",model.expertName]];
        NSRange subRange1=[[subString string]rangeOfString:@"主讲人："];
        [subString addAttribute:NSForegroundColorAttributeName value:[MZTools colorWithHexString:@"#666666"] range:subRange1];
        [subString addAttribute:NSFontAttributeName value:XKFont(13.f) range:subRange1];
        //
        NSRange subRange2=[[subString string]rangeOfString:[NSString stringWithFormat:@"%@",model.expertName]];
        [subString addAttribute:NSForegroundColorAttributeName value:[MZTools colorWithHexString:@"#212121"] range:subRange2];
        [subString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13.0f] range:subRange2];
        self.subTitleLabel.attributedText=subString;
        //
    }
    else{
        _subTitleLabel.font=XKFont(13.f);
        _subTitleLabel.textColor=[MZTools colorWithHexString:@"#666666"];
        self.subTitleLabel.text=@"暂无信息";
    }
    //
    NSMutableAttributedString *hintString1=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"课时数:%@",model.classNumber]];
    NSRange range11=[[hintString1 string]rangeOfString:@"课时数:"];
    [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range11];
    [hintString1 addAttribute:NSFontAttributeName value:XKFont(14.f) range:range11];
    
    NSRange range12=[[hintString1 string]rangeOfString:[NSString stringWithFormat:@"%@",model.classNumber]];
    [hintString1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range12];
    [hintString1 addAttribute:NSFontAttributeName value:XKFont(15.f) range:range12];
    _classNumLabel.attributedText=hintString1;
    //
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已购买:%@/%@",model.boughtNum,model.classNumber]];
    NSRange range1=[[hintString string]rangeOfString:@"已购买:"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range1];
    [hintString addAttribute:NSFontAttributeName value:XKFont(14.f) range:range1];
    
    NSRange range2=[[hintString string]rangeOfString:[NSString stringWithFormat:@"%@/%@",model.boughtNum,model.classNumber]];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range2];
    [hintString addAttribute:NSFontAttributeName value:XKFont(15.f) range:range2];
    _consumedNumLabel.attributedText=hintString;
    //
    
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    if (editing) {
        [self customMultipleChioce];
    }else{
        [self customMultiple];
    }
}

-(void)customMultipleChioce{
    self.moveNum = 50;
    [self updateMasonry];
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}

-(void)customMultiple{
    self.moveNum = 0;
    [self updateMasonry];
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)updateMasonry{
    [self.liveImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(self.contentView).offset(10+_moveNum);
        make.width.equalTo(SCREEN_WIDTH/3-10);
        make.height.equalTo((SCREEN_WIDTH/3)*0.67-15);
    }];
    [_learnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subTitleLabel.bottom).offset(0);
        make.width.equalTo(80);
        make.right.equalTo(self.contentView.mas_right).offset(-10+_moveNum);
        make.height.equalTo(30);
    }];
}
@end
