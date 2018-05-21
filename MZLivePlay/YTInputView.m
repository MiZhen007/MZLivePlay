//
//  YTInputView.m
//  chat
//
//  Created by T_Yang on 15/9/2.
//  Copyright © 2015年 杨 天. All rights reserved.
//

#import "YTInputView.h"

@interface YTInputView ()
@end

@implementation YTInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"chat_bottom_bg"];
        
//        UIImageView *textFieldBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.current_w-50, 30)];
//        [self addSubview:textFieldBackImageView];
//        textFieldBackImageView.userInteractionEnabled = YES;
//        textFieldBackImageView.center = CGPointMake(textFieldBackImageView.center.x, self.frame.size.height / 2);
//        textFieldBackImageView.image = [UIImage imageNamed:@"chat_bottom_textfield"];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, self.current_w-80, self.current_h-10)];
        [self addSubview:_textField];
        [_textField makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.top.equalTo(5);
            make.width.equalTo(self).offset(-80);
            make.height.equalTo(self).offset(-10);
        }];
//        textField.center = CGPointMake(textFieldBackImageView.frame.size.width / 2,
//                                       textFieldBackImageView.frame.size.height / 2);
        _textField.returnKeyType = UIReturnKeySend;
        _textField.placeholder=@" 提问：";
        //当输入框没有内容的时候 return键自动设置位不能点击的状态
        _textField.enablesReturnKeyAutomatically = YES;
        _textField.delegate = self;
        
        _sendBtn=[[UIButton alloc] initWithFrame:CGRectMake(_textField.current_x_w+5, 5, 60, self.current_h-10)];
//        sendBtn.backgroundColor=MZColor(255, 200, 50, 1);
        _sendBtn.backgroundColor=StyleColor;
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendBtn];
        [_sendBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_textField.mas_right).offset(5);
            make.top.equalTo(5);
            make.width.equalTo(60);
            make.height.equalTo(self).offset(-10);
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}
//发送按钮点击相应
-(void)sendBtnClicked{
    if ([_delegate respondsToSelector:@selector(inputView:text:)]) {
        [_delegate inputView:self text:_textField.text];
    }
}
/**
 *  是否在输入状态
 */
- (BOOL)isEditing {
    return [self.textField isFirstResponder];
}

- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}
//#pragma mark UITextViewDelegate
//- (void)textViewDidChange:(UITextView *)textView {
////    self.placeholderLabel.hidden = textView.text.length;
//
//    if (textView.text.length == 0) {
//        _sendBtn.enabled = NO;
//
//        [_sendBtn setTitleColor:RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateNormal];
//    }else{
//        _sendBtn.enabled = YES;
//        [_sendBtn setTitleColor:RGBACOLOR(0, 0, 0, 1.0) forState:UIControlStateNormal];
//    }
//    CGFloat contentSizeH = textView.contentSize.height;
//    CGFloat lineH = textView.font.lineHeight;
//    CGFloat maxTextViewHeight = ceil(lineH * self.textViewMaxLine + textView.textContainerInset.top + textView.textContainerInset.bottom);
//    if (contentSizeH <= maxTextViewHeight) {
//        textView.CLheight = contentSizeH;
//    }else{
//        textView.CLheight = maxTextViewHeight;
//    }
//    self.CLheight = ceil(textView.CLheight) + 10 + 10;
//    self.CLbottom = CLscreenHeight - _keyboardHeight;
//    [textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
//}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([_delegate respondsToSelector:@selector(inputView:willShowKeyboardHeight:time:)]) {
        [_delegate inputView:self willShowKeyboardHeight:keyboardRect.size.height time:[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if ([_delegate respondsToSelector:@selector(willHideKeyboardWithInputView:time:)]) {
        [_delegate willHideKeyboardWithInputView:self time:[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(inputView:text:)]) {
        [_delegate inputView:self text:textField.text];
    }
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
