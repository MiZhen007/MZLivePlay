//
//  CommentModel.m
//  XuanYan
//
//  Created by mz on 2017/8/21.
//  Copyright © 2017年 mizhen. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

-(void)initPerformanceDataWithViewWidth:(CGFloat )viewWidth{
    _CommentHeight=[self sizeWithText:_content ViewWidth:viewWidth].height+70-25;//减去25是剔除，cell里的发布日期一行的高度
    //
}

- (CGSize)sizeWithText:(NSString *)text ViewWidth:(CGFloat )viewWidth{
    NSAttributedString *string=[self setWithString:text fontSize:ChatFontSize fontColor:[UIColor darkTextColor] lineSpace:ChatLineSpace breakMode:NSLineBreakByCharWrapping textAlighment:NSTextAlignmentLeft];

    CGSize contentMaxSize = CGSizeMake(viewWidth - 76, MAXFLOAT);
    CGSize contentStringSize = [string boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return contentStringSize;
    //    return [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, MAXFLOAT)
//                              options:NSStringDrawingUsesLineFragmentOrigin
//                           attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]}
//                              context:nil].size;
}
-(NSAttributedString *)setWithString:(NSString*)str fontSize:(NSInteger)size fontColor:(UIColor*)color lineSpace:(NSInteger) lineSpace breakMode:(NSLineBreakMode)linebreak textAlighment:(NSTextAlignment)textAlighment{
    if (str == nil){
        str = @"";
    }
    NSRange range = NSMakeRange(0, str.length);
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:str attributes:nil];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:textAlighment];
    [paragraphStyle setLineSpacing:lineSpace];
    paragraphStyle.lineBreakMode = linebreak;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributeString addAttribute:NSBaselineOffsetAttributeName value:@0 range:range];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, str.length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:color range:range];
    return attributeString;
}


//当字典
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    //
    if ([key isEqualToString:@"memimageurl"]) {
        _portraitUrl=value;
        //
    }
    //
    if ([key isEqualToString:@"memname"]) {
        _title=value;
        //
    }
    //
    if ([key isEqualToString:@"addtime"]) {
        _dateTime=value;
    }
    //
    if ([key isEqualToString:@"cecomment"]) {
        _content=value;
    }
    //
}
//通过未定义的key取值时，不重写此方法就会崩溃
-(id)valueForUndefinedKey:(NSString *)key{
    
    return nil;
}

@end

















