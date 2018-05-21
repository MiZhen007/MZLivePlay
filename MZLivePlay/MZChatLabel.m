//
//  MZChatLabel.m
//  XuanYan
//
//  Created by mz on 16/9/29.
//  Copyright © 2016年 mizhen. All rights reserved.
//

#import "MZChatLabel.h"

@implementation MZChatLabel

-(void)setWithString:(NSString*)str fontSize:(NSInteger)size fontColor:(UIColor*)color lineSpace:(NSInteger) lineSpace breakMode:(NSLineBreakMode)linebreak{
    if (str == nil)
        str = @"";
    NSRange range = NSMakeRange(0, str.length);
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:str attributes:nil];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    paragraphStyle.lineBreakMode = linebreak;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributeString addAttribute:NSBaselineOffsetAttributeName value:@0 range:range];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, str.length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = attributeString;
}

-(void)calculateFrameWithMaxSize:(CGSize)rect{
    self.size = [self.attributedText boundingRectWithSize:rect options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
}

@end
