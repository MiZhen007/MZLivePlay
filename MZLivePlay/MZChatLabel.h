//
//  MZChatLabel.h
//  XuanYan
//
//  Created by mz on 16/9/29.
//  Copyright © 2016年 mizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZChatLabel : UILabel
@property (assign, nonatomic) CGSize size;

-(void)setWithString:(NSString*)str fontSize:(NSInteger)size fontColor:(UIColor*)color lineSpace:(NSInteger) lineSpace breakMode:(NSLineBreakMode)linebreak;
-(void)calculateFrameWithMaxSize:(CGSize) rect;

@end











