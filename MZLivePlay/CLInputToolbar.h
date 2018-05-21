//
//  CLInputToolbar.h
//  CLInputToolbar
//
//  Created by JmoVxia on 2017/8/16.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Basic.h"
#import "UIView+CLSetRect.h"
@class CLInputView;


@protocol CLInputViewDelegate <NSObject>
/**
 *  即将显示键盘时调用
 *
 *  @param inputView 当前输入框view
 *  @param height    键盘高度
 *  @param time      弹出时间
 */
- (void)inputView:(CLInputView *)inputView willShowKeyboardHeight:(CGFloat)height time:(NSNumber *)time;
/**
 *  即将隐藏键盘时调用
 *
 *  @param inputView 当前输入框view
 *  @param time      弹出时间
 */
- (void)willHideKeyboardWithInputView:(CLInputView *)inputView time:(NSNumber *)time;
/**
 *  点击return键时调用
 *
 *  @param inputView 当前输入框view
 *  @param text      输入的聊天内容(非空)
 */
- (void)inputView:(CLInputView *)inputView text:(NSString *)text;

@end


@interface CLInputView : UIView

@property (nonatomic, weak) id<CLInputViewDelegate> delegate;


/**设置输入框最大行数*/
@property (nonatomic, assign) NSInteger textViewMaxLine;
/**输入框文字大小*/
@property (nonatomic, assign) CGFloat fontSize;
/**占位文字*/
@property (nonatomic, copy) NSString *placeholder;
/////////////////////////////
/**文本输入框*/
@property (nonatomic, strong) UITextView *textField;
/**边框*/
@property (nonatomic, strong) UIView *edgeLineView;
/**顶部线条*/
@property (nonatomic, strong) UIView *topLine;
/**底部线条*/
@property (nonatomic, strong) UIView *bottomLine;
/**textView占位符*/
@property (nonatomic, strong) UILabel *placeholderLabel;
/**发送按钮*/
@property (nonatomic, strong) UIButton *sendBtn;
/**键盘高度*/
@property (nonatomic, assign) CGFloat keyboardHeight;

@property(nonatomic,weak) UIView *bottomVCView;

@property(nonatomic,assign) CGRect viewFrame;

/**收回键盘*/
-(void)bounceToolbar;


/**弹出键盘*/
- (void)popToolbar;

@end
