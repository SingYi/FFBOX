//
//  FFResetNickNameView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFResetNickNameView.h"

@interface FFResetNickNameView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nickNameText;

@property (nonatomic, strong) UIButton *resetNickNameBtn;

@end

@implementation FFResetNickNameView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeUserInterface];
        [self initializeDataSource];
    }
    return self;
}

- (void)initializeUserInterface {
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    [self addSubview:self.nickNameText];
    [self addSubview:self.resetNickNameBtn];
}

- (void)initializeDataSource {

}

- (void)clickResetNickNameBtn {
    [self removeFromSuperview];

    if (self.nickNameText.text.length == 0) {
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(FFResetNickNameView:clickRestButtonWithNickName:)]) {
        [self.delegate FFResetNickNameView:self clickRestButtonWithNickName:self.nickNameText.text];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.nickNameText isFirstResponder]) {
        [self.nickNameText resignFirstResponder];
    }
    [self removeFromSuperview];
}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self clickResetNickNameBtn];
    return YES;
}


#pragma mark - getter
- (UITextField *)nickNameText {
    if (!_nickNameText) {
        _nickNameText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44)];
        _nickNameText.placeholder = @"输入昵称";
        _nickNameText.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 3.3);
        _nickNameText.borderStyle = UITextBorderStyleRoundedRect;
        _nickNameText.delegate = self;
        _nickNameText.returnKeyType = UIReturnKeyDone;
    }
    return _nickNameText;
}

- (UIButton *)resetNickNameBtn {
    if (!_resetNickNameBtn) {
        _resetNickNameBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44)];
        [_resetNickNameBtn setTitle:@"修改昵称" forState:(UIControlStateNormal)];
        _resetNickNameBtn.backgroundColor = [UIColor orangeColor];
        _resetNickNameBtn.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 3.3 + 60);
        [_resetNickNameBtn addTarget:self action:@selector(clickResetNickNameBtn) forControlEvents:(UIControlEventTouchUpInside)];

        _resetNickNameBtn.layer.cornerRadius = 4;
        _resetNickNameBtn.layer.masksToBounds = YES;
    }
    return _resetNickNameBtn;
}







@end






