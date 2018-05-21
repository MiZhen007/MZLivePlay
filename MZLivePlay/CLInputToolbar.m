//
//  CLInputToolbar.m
//  CLInputToolbar
//
//  Created by JmoVxia on 2017/8/16.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLInputToolbar.h"
#import "UIView+CLSetRect.h"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface CLInputView ()<UITextViewDelegate>

@end

@implementation CLInputView

- (instancetype)initWithFrame:(CGRect)frame {
    //////
    if (self = [super initWithFrame:frame]) {
//        self.frame = CGRectMake(0,CLscreenHeight, CLscreenWidth, 50);
        self.viewFrame=frame;
        [self initView];
        [self addNotification];
    }
    return self;
}
-(void)initView {
    self.backgroundColor = [UIColor whiteColor];
//    //顶部线条
//    self.topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.CLwidth, 1)];
//    self.topLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
//    [self addSubview:self.topLine];
//    [self.topLine makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self).offset(0);
//        make.left.equalTo(10);
//        make.height.equalTo(self).offset(-10);
//    }];
    
//    //底部线条
//    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.CLheight - 1, self.CLwidth, 1)];
//    self.bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
//    [self addSubview:self.bottomLine];
//    [self.bottomLine makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self).offset(0);
//        make.left.equalTo(10);
//        make.height.equalTo(self).offset(-10);
//    }];
    
    //边框
    self.edgeLineView = [[UIView alloc]init];
    self.edgeLineView.CLwidth = self.CLwidth - 50 - 30;
    self.edgeLineView.CLleft = 10;
    self.edgeLineView.backgroundColor=[UIColor whiteColor];
    self.edgeLineView.layer.cornerRadius = 5;
//    self.edgeLineView.layer.borderColor = RGBACOLOR(0, 0, 0, 0.5).CGColor;
//    self.edgeLineView.layer.borderWidth = 1;
//    self.edgeLineView.layer.masksToBounds = YES;
    [self addSubview:self.edgeLineView];
    [self.edgeLineView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-50-30);
        make.left.equalTo(10);
        make.height.equalTo(self).offset(-10);
    }];
    //输入框
    self.textField = [[UITextView alloc] init];;
    self.textField.CLwidth = self.CLwidth - 50 - 46;
    self.textField.CLleft = 18;
    self.textField.returnKeyType = UIReturnKeySend;
    self.textField.enablesReturnKeyAutomatically = YES;
    self.textField.delegate = self;
    self.textField.layoutManager.allowsNonContiguousLayout = NO;
    self.textField.scrollsToTop = NO;
    self.textField.textContainerInset = UIEdgeInsetsZero;
    self.textField.textContainer.lineFragmentPadding = 0;
    [self addSubview:self.textField];
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-50-46);
        make.left.equalTo(18);
        make.height.equalTo(self).offset(-20);
    }];
    //占位文字
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.CLwidth = self.textField.CLwidth - 10;
    self.placeholderLabel.textColor = RGBACOLOR(0, 0, 0, 0.5);
    self.placeholderLabel.CLleft = 23;
    [self addSubview:self.placeholderLabel];
    [self.placeholderLabel makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.textField).offset(-10);
        make.left.equalTo(23);
//        make.height.equalTo(self).offset(-10);
    }];
    //发送按钮
    self.sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.CLwidth - 50 - 10, self.CLheight - 30 - 10, 50, 30)];
//    [self.sendBtn.layer setBorderWidth:1.0];
    [self.sendBtn.layer setCornerRadius:5.0];
//    self.sendBtn.layer.borderColor = RGBACOLOR(0, 0, 0, 0.5).CGColor;
    self.sendBtn.enabled = NO;
    self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendBtn];
    [self.sendBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.right).offset(-50-10);
        make.centerY.equalTo(self);
        make.width.equalTo(50);
    }];
    self.fontSize = 20;
    self.textViewMaxLine = 3;
}
//发送按钮点击相应
-(void)sendBtnClicked{
    self.textField.CLheight=self.textField.contentSize.height;
    self.CLheight = ceil(self.textField.CLheight) + 10 + 10;

    if ([_delegate respondsToSelector:@selector(inputView:text:)]) {
        [_delegate inputView:self text:_textField.text];
    }
}
// 添加通知
-(void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    if (!fontSize || _fontSize < 20) {
        _fontSize = 20;
    }
    self.textField.font = [UIFont systemFontOfSize:_fontSize];
    self.placeholderLabel.font = self.textField.font;
    CGFloat lineH = self.textField.font.lineHeight;
    self.CLheight = ceil(lineH) + 10 + 10;
    self.textField.CLheight = lineH;
}
- (void)setTextViewMaxLine:(NSInteger)textViewMaxLine {
    _textViewMaxLine = textViewMaxLine;
    if (!_textViewMaxLine || _textViewMaxLine <= 0) {
        _textViewMaxLine = 3;
    }
}

-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    ///
}

#pragma mark keyboardnotification
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([_delegate respondsToSelector:@selector(inputView:willShowKeyboardHeight:time:)]) {
        [_delegate inputView:self willShowKeyboardHeight:keyboardFrame.size.height time:[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]];
    }
    //////
    _keyboardHeight = keyboardFrame.size.height;
    //
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.CLy = _bottomVCView.current_h-_keyboardHeight - self.CLheight;
    }];
    ////////
}
- (void)keyboardWillHidden:(NSNotification *)notification {
    if ([_delegate respondsToSelector:@selector(willHideKeyboardWithInputView:time:)]) {
        [_delegate willHideKeyboardWithInputView:self time:[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]];
    }
    
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.CLy = _bottomVCView.current_h-self.CLheight;
    }];
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        if ([_delegate respondsToSelector:@selector(inputView:text:)]) {
            [_delegate inputView:self text:_textField.text];
        }
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    //
    self.placeholderLabel.hidden = textView.text.length;
    if (textView.text.length == 0) {
        self.sendBtn.enabled = NO;
        
//        [self.sendBtn setTitleColor:RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateNormal];
//        [self.sendBtn setBackgroundColor:LightBackgroundColor];
        [self.sendBtn setBackgroundColor:[UIColor clearColor]];
        
    }else{
        //////
        self.sendBtn.enabled = YES;
//        [self.sendBtn setTitleColor:RGBACOLOR(0, 0, 0, 1.0) forState:UIControlStateNormal];
        [self.sendBtn setBackgroundColor:StyleColor];
        
    }
    
    CGFloat contentSizeH = textView.contentSize.height;
    CGFloat lineH = textView.font.lineHeight;
    CGFloat maxTextViewHeight = ceil(lineH * self.textViewMaxLine + textView.textContainerInset.top + textView.textContainerInset.bottom);
    if (contentSizeH <= maxTextViewHeight) {
        textView.CLheight = contentSizeH;
        
    }else{
        textView.CLheight = maxTextViewHeight;
        
    }
    
    self.CLheight = ceil(textView.CLheight) + 10 + 10;
    
    if ([textView isFirstResponder]) {
        self.CLbottom = _bottomVCView.current_h - _keyboardHeight;
        
    }
    else{
        self.CLbottom = _bottomVCView.current_h;
        
    }
//    self.frame=CGRectMake(self.current_x, SCREEN_HEIGHT-_keyboardHeight-self.CLheight, self.current_w, self.current_h);
//    [self makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_bottomVCView.mas_bottom).offset(-_keyboardHeight);
//    }];
//
    
    [textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
}


- (void)popToolbar{
    self.fontSize = _fontSize;
    [self.textField becomeFirstResponder];
}
// 发送成功 清空文字 更新输入框大小
-(void)bounceToolbar {
    self.textField.text = nil;
    [self.textField.delegate textViewDidChange:self.textField];
    [self endEditing:YES];
//    self.frame=_viewFrame;
//    [self layoutSubviews];
}

-(void)layoutSubviews{
    //
    [super layoutSubviews];
    //
    self.edgeLineView.CLheight = self.textField.CLheight + 10;
    self.textField.CLcenterY = self.CLheight * 0.5;
    
    self.placeholderLabel.CLheight = self.textField.CLheight;
    self.placeholderLabel.CLcenterY = self.CLheight * 0.5;
    self.sendBtn.CLcenterY = self.CLheight * 0.5;
    self.edgeLineView.CLcenterY = self.CLheight * 0.5;
//    self.bottomLine.CLy = self.CLheight - 1;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
















