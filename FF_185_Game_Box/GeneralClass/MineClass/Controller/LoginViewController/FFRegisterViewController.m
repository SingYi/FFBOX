//
//  FFRegisterViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFRegisterViewController.h"
#import "FFViewFactory.h"
#import "FFUserModel.h"

@interface FFRegisterViewController ()<UITextFieldDelegate>


//用户名
@property (nonatomic, strong) UITextField *userName;

//密码
@property (nonatomic, strong) UITextField *passWord;

//手机号
@property (nonatomic, strong) UITextField *phoneNumber;

//验证码
@property (nonatomic, strong) UITextField *securityCode;

//邮箱
@property (nonatomic, strong) UITextField *email;

//注册按钮
@property (nonatomic, strong) UIButton *registerBtn;

/**< 发送验证码按钮 */
@property (nonatomic, strong) UIButton *sendMessageBtn;
/** 计时器 */
@property (nonatomic, strong) NSTimer *timer;

//当前的时间;
@property (nonatomic, assign) NSInteger currnetTime;


@property (nonatomic, assign) BOOL isUserRegister;
@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, strong) UIBarButtonItem *rightChangeButton;

@end

@implementation FFRegisterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.userName.text = @"";
    self.passWord.text = @"";
    self.phoneNumber.text = @"";
    self.securityCode.text = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self allTextFieldResignFistResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self allTextFieldResignFistResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isUserRegister = NO;
    [self initUserInterFace];
}

- (void)initUserInterFace {
//    self.view.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:217 / 255.0 blue:217/255.0 alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.userName];
    [self.view addSubview:self.securityCode];
    [self.view addSubview:self.passWord];
    [self.view addSubview:self.registerBtn];
//    [self.view addSubview:self.changeButton];
    self.navigationItem.rightBarButtonItem = self.rightChangeButton;
    [self phoneView];
}

- (void)setPhoneView {
    [UIView animateWithDuration:0.3 animations:^{
        [self phoneView];
    } completion:^(BOOL finished) {

    }];
}

- (void)phoneView {
    self.navigationItem.title = @"快速注册";
    self.userName.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.2);
    self.securityCode.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.userName.frame) + 55);
    self.passWord.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.securityCode.frame) + 55);
    self.registerBtn.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.passWord.frame) + 60);
    self.changeButton.frame = CGRectMake(CGRectGetMinX(self.passWord.frame), CGRectGetMaxY(self.registerBtn.frame), kSCREEN_WIDTH * 0.8, 30);
    self.rightChangeButton.title = @"用户名注册";
    self.userName.placeholder = @"请输入手机号";
}

- (void)setUserView {
    self.navigationItem.title = @"用户名注册";
    [UIView animateWithDuration:0.3 animations:^{
        self.userName.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.2);
        self.securityCode.center = CGPointMake(kSCREEN_WIDTH * 2, CGRectGetMaxY(self.userName.frame) + 55);
        self.passWord.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.userName.frame) + 55);
        self.registerBtn.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.passWord.frame) + 60);
        self.changeButton.frame = CGRectMake(CGRectGetMinX(self.passWord.frame), CGRectGetMaxY(self.registerBtn.frame), kSCREEN_WIDTH * 0.8, 30);
        self.rightChangeButton.title = @"快速注册";
        self.userName.placeholder = @"请输入用户名";
    } completion:^(BOOL finished) {

    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self allTextFieldResignFistResponder];
}

- (void)allTextFieldResignFistResponder {
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.securityCode resignFirstResponder];
//    [self.email resignFirstResponder];
}

#pragma mark - responds
/** 切换注册 */
- (void)respondsToChangeButton {
    syLog(@"???");
    if (_isUserRegister) {
        _isUserRegister = NO;
        [self setPhoneView];
    } else {
        _isUserRegister = YES;
        [self setUserView];
    }
    [_changeButton sizeToFit];
}
/** 注册 */
- (void)respondsToRegisterBtn {
    syLog(@"用户名注册 %u",_isUserRegister);
    //用户名太短,返回
    if (self.userName.text.length < 6) {
        BOX_MESSAGE(@"用户名长度太短");
        return;
    }
    //密码太短
    if (self.passWord.text.length < 6) {
        BOX_MESSAGE(@"密码长度太短");
        return;
    }

    NSString *userName = nil;
    NSString *code = nil;
    NSString *phoneNumber = nil;
    NSString *passWord = nil;
    NSString *type = nil;

    if (_isUserRegister) {
        userName = self.userName.text;
        code = @"";
        phoneNumber = @"";
        passWord = self.passWord.text;
        type = @"1";
    } else {
        NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        //手机号有误
        if (![regextestmobile evaluateWithObject:self.userName.text]) {
            BOX_MESSAGE(@"手机号码有误");
            return;
        }
        //验证码长度不正确
        if (self.securityCode.text.length < 4) {
            BOX_MESSAGE(@"验证码长度有误");
            return;
        }
        userName = @"";
        code = self.securityCode.text;
        phoneNumber = self.userName.text;
        passWord = self.passWord.text;
        type = @"2";
    }


    BOX_START_ANIMATION;
    [FFUserModel userRegisterWithUserName:userName Code:code PhoneNumber:phoneNumber PassWord:passWord Type:type Completion:^(NSDictionary *content, BOOL success)
    {
        BOX_STOP_ANIMATION;
        if (success) {
            NSString *loginName = nil;
            if ([userName isEqualToString:@""] || userName.length == 0) {
                loginName = phoneNumber;
            } else {
                loginName = userName;
            }

            [FFViewFactory showAlertMessage:@"注册成功" dismissTime:0.7 dismiss:^{

                BOX_MESSAGE(@"正在登陆");
                BOX_START_ANIMATION;
                [FFUserModel userLoginWithUserName:loginName PassWord:passWord Completion:^(NSDictionary *content, BOOL success) {
                    BOX_STOP_ANIMATION;
                    if (success) {
                        NSDictionary *dict = CONTENT_DATA;
                        //设置用户模型
                        [[FFUserModel currentUser] setAllPropertyWithDict:dict];
                        //登录
                        [FFUserModel login:dict];
                        //保存 UID
                        [FFUserModel setUID:[FFUserModel currentUser].uid];
                        [FFUserModel setUserName:[FFUserModel currentUser].username];
                        [FFUserModel currentUser].isLogin = @"1";

                        BOX_MESSAGE(@"登陆成功");

                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserReigsterThanLogin" object:nil userInfo:nil];

                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        BOX_MESSAGE(@"登陆失败");
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }];



        } else {
            BOX_MESSAGE(content[@"msg"]);
        }

    }];
}

/** 响应发送验证码按钮 */
- (void)respondsToSendMessageBtn {

    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];

    if (![regextestmobile evaluateWithObject:self.userName.text]) {
        BOX_MESSAGE(@"手机号码有误");
        return;
    }

    [FFUserModel userSendMessageWithPhoneNumber:self.userName.text Type:@"1" Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            _currnetTime = 59;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
            BOX_MESSAGE(@"验证码已发送");
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

- (void)refreshTime {
    [self.sendMessageBtn setTitle:[NSString stringWithFormat:@"%lds",_currnetTime] forState:(UIControlStateNormal)];
    [self.sendMessageBtn setUserInteractionEnabled:NO];
    if (_currnetTime <= 0) {
        [self stopTimer];
        [self.sendMessageBtn setUserInteractionEnabled:YES];
        [self.sendMessageBtn setTitle:@"发送验证码" forState:(UIControlStateNormal)];
    }
    _currnetTime--;
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.email) {
        [self respondsToRegisterBtn];
    } else if (textField == self.userName) {
        [self.userName resignFirstResponder];
        [self.passWord becomeFirstResponder];
    } else if (textField == self.passWord) {
        [self.passWord resignFirstResponder];
        [self.phoneNumber becomeFirstResponder];
    } else if (textField == self.phoneNumber) {
        [self.phoneNumber resignFirstResponder];
        [self.securityCode becomeFirstResponder];
    } else if (textField == self.securityCode) {
        [self.securityCode resignFirstResponder];
        [self.email becomeFirstResponder];
        [self respondsToRegisterBtn];
    }

    return YES;
}

//限制用户名和密码长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.userName) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.userName.text.length >= 15) {
            self.userName.text = [textField.text substringToIndex:15];
            return NO;
        }
    } else if (textField == self.passWord) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.passWord.text.length >= 16) {
            self.passWord.text = [textField.text substringToIndex:16];
            return NO;
        }
    } else if (textField == self.phoneNumber) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.phoneNumber.text.length >= 11) {
            self.phoneNumber.text = [textField.text substringToIndex:11];
            return NO;
        }
    } else if (textField == self.securityCode) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.securityCode.text.length >= 6) {
            self.securityCode.text = [textField.text substringToIndex:6];
            return NO;
        }
    } else if (textField == self.email) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.email.text.length >= 30) {
            self.email.text = [textField.text substringToIndex:30];
            return NO;
        }
    }
    return YES;
}

#pragma mark - getter
- (UITextField *)creatTextFieldWithLeftView:(UIImageView *)lefitView WithRightView:(UIImageView *)rigthView WithPlaceholder:(NSString *)placeholder WithBounds:(CGRect)Bounds WithsecureTextEntry:(BOOL)secureTextEntry  {
    UITextField *textfield = [[UITextField alloc] init];
    textfield.bounds = Bounds;

    textfield.leftView = lefitView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    textfield.placeholder = placeholder;
    textfield.secureTextEntry = secureTextEntry;
    textfield.delegate = self;
    [textfield setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textfield setAutocapitalizationType:UITextAutocapitalizationTypeNone];

    return textfield;
}

- (UITextField *)userName {
    if (!_userName) {
        _userName = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输用户名" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44) WithsecureTextEntry:NO];
        _userName.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.2);
        _userName.returnKeyType = UIReturnKeyNext;
        _userName.keyboardType = UIKeyboardTypeDefault;
    }
    return _userName;
}

- (UITextField *)securityCode {
    if (!_securityCode) {
        _securityCode = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入验证码" WithBounds:CGRectMake(CGRectGetMidX(self.userName.frame), CGRectGetMaxY(self.userName.frame) + 20, kSCREEN_WIDTH * 0.8, 44) WithsecureTextEntry:NO];

        _securityCode.rightView = self.sendMessageBtn;
        _securityCode.rightViewMode = UITextFieldViewModeAlways;

        _securityCode.returnKeyType = UIReturnKeyNext;
        _securityCode.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _securityCode.layer.masksToBounds = YES;
    }
    return _securityCode;
}

- (UITextField *)passWord {
    if (!_passWord) {
        _passWord = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入密码" WithBounds:CGRectMake(CGRectGetMaxX(self.userName.frame), CGRectGetMaxY(self.securityCode.frame) + 20, kSCREEN_WIDTH * 0.8, 44) WithsecureTextEntry:YES];
        _passWord.returnKeyType = UIReturnKeyNext;
    }
    return _passWord;
}



- (UITextField *)phoneNumber {
    if (!_phoneNumber) {
        _phoneNumber = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入手机号" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44) WithsecureTextEntry:NO];
        _phoneNumber.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.2);
        _phoneNumber.returnKeyType = UIReturnKeyNext;
        _phoneNumber.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return _phoneNumber;
}


- (UITextField *)email {
    if(!_email) {
        _email = [self creatTextFieldWithLeftView:nil WithRightView:nil WithPlaceholder:@"请输入邮箱" WithBounds:CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44) WithsecureTextEntry:NO];
        _email.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT * 0.6);
        _email.returnKeyType = UIReturnKeyDone;
        _email.keyboardType = UIKeyboardTypeEmailAddress;
    }
    return _email;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _registerBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _registerBtn.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.passWord.frame) + 60);
        [_registerBtn setTitle:@"注册" forState:(UIControlStateNormal)];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_registerBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateHighlighted)];
        [_registerBtn setBackgroundColor:[UIColor orangeColor]];
        _registerBtn.layer.cornerRadius = 4;
        _registerBtn.layer.masksToBounds = YES;
        [_registerBtn addTarget:self action:@selector(respondsToRegisterBtn) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _registerBtn;
}

- (UIButton *)sendMessageBtn {
    if (!_sendMessageBtn) {
        _sendMessageBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sendMessageBtn.backgroundColor = [UIColor orangeColor];
        [_sendMessageBtn setTitle:@"发送验证码" forState:(UIControlStateNormal)];
        [_sendMessageBtn addTarget:self action:@selector(respondsToSendMessageBtn) forControlEvents:(UIControlEventTouchUpInside)];
        _sendMessageBtn.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.3, 44);
        _sendMessageBtn.layer.cornerRadius = 2;
        _sendMessageBtn.layer.masksToBounds = YES;
    }

    return _sendMessageBtn;
}

- (UIButton *)changeButton {
    if (!_changeButton) {
        _changeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _changeButton.frame = CGRectMake(CGRectGetMinX(self.registerBtn.frame), CGRectGetMaxY(self.registerBtn.frame) + 10, kSCREEN_WIDTH, 20);
        if (_isUserRegister) {
            [_changeButton setTitle:@"快速注册" forState:(UIControlStateNormal)];
        } else {
            [_changeButton setTitle:@"用户名注册" forState:(UIControlStateNormal)];
        }
        [_changeButton sizeToFit];
        [_changeButton addTarget:self action:@selector(respondsToChangeButton) forControlEvents:(UIControlEventTouchUpInside)];
        _changeButton.layer.cornerRadius = 2;
        _changeButton.layer.masksToBounds = YES;
        _changeButton.layer.borderWidth = 1;
        _changeButton.layer.borderColor = NAVGATION_BAR_COLOR.CGColor;
        [_changeButton setTitleColor:NAVGATION_BAR_COLOR forState:(UIControlStateNormal)];
    }
    return _changeButton;
}

- (UIBarButtonItem *)rightChangeButton {
    if (!_rightChangeButton) {
        _rightChangeButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToChangeButton)];
    }
    return _rightChangeButton;
}




@end






