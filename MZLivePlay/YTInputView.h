//
//  YTInputView.h
//  chat
//
//  Created by T_Yang on 15/9/2.
//  Copyright © 2015年 杨 天. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTInputView;


@protocol YTInputViewDelegate <NSObject>
/**
 *  即将显示键盘时调用
 *
 *  @param inputView 当前输入框view
 *  @param height    键盘高度
 *  @param time      弹出时间
 */
- (void)inputView:(YTInputView *)inputView willShowKeyboardHeight:(CGFloat)height time:(NSNumber *)time;
/**
 *  即将隐藏键盘时调用
 *
 *  @param inputView 当前输入框view
 *  @param time      弹出时间
 */
- (void)willHideKeyboardWithInputView:(YTInputView *)inputView time:(NSNumber *)time;
/**
 *  点击return键时调用
 *
 *  @param inputView 当前输入框view
 *  @param text      输入的聊天内容(非空)
 */
- (void)inputView:(YTInputView *)inputView text:(NSString *)text;

@end

@interface YTInputView : UIImageView <UITextFieldDelegate>


@property (nonatomic, strong) UITextField *textField;

@property(nonatomic,strong) UIButton *sendBtn;

@property (nonatomic, weak) id<YTInputViewDelegate> delegate;
//发送按钮点击相应
/**
 *  是否在输入状态
 */
- (BOOL)isEditing;
/**
 *  进入输入状态
 */
- (BOOL)becomeFirstResponder;
@end
