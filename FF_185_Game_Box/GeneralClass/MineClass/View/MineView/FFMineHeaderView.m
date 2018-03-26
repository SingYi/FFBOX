//
//  FFMineHeaderView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMineHeaderView.h"
#import "SYKeychain.h"

@interface FFMineHeaderView ()

/** vip button */
@property (nonatomic, strong) UIButton *vipButton;
@property (nonatomic, strong) UIImageView *vipImageView;

/** 登录按钮 */
@property (nonatomic, strong) UIButton *loginButton;

/** 设置按钮 */
@property (nonatomic, strong) UIButton *settingButton;

@end

@implementation FFMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.userInteractionEnabled = YES;
    self.image = [UIImage imageNamed:@"New_mine_header"];
    [self addSubview:self.avatar];
    [self addSubview:self.vipButton];
    [self addSubview:self.loginButton];
//    [self addSubview:self.settingButton];
}

#pragma mark - responds
 /** 点击 vip 按钮 */ 
- (void)respondsToVipButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFMineHeaderView:respondsToVipButton:)]) {
        [self.delegate FFMineHeaderView:self respondsToVipButton:nil];
    }
}

/** 点击登录 */
- (void)respondsToLoginButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFMineHeaderView:respondsToLoginButton:)]) {
        [self.delegate FFMineHeaderView:self respondsToLoginButton:nil];
    }
}

/** 点击头像 */
- (void)respondsToAvatar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFMineHeaderView:respondsToAvatarButton:)]) {
        [self.delegate FFMineHeaderView:self respondsToAvatarButton:nil];
    }
}

/** 点击设置 */
- (void)respondsToSettingButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFMineHeaderView:respondsToSettingButton:)]) {
        [self.delegate FFMineHeaderView:self respondsToSettingButton:nil];
    }
}

#pragma mark - setter
/** 设置头像 */
- (void)setAvatarImage:(UIImage *)avatarImage {
    if (avatarImage == nil) {
        self.avatar.image = [UIImage imageNamed:@"mine_loginBtn_no"];
    } else {
        self.avatar.image = avatarImage;
    }
    if (SSKEYCHAIN_UID) {
        self.avatar.center = CGPointMake(kSCREEN_WIDTH / 6, self.avatar.center.y);
    } else {
        self.avatar.center = CGPointMake(kSCREEN_WIDTH / 2, self.avatar.center.y);
    }
    [self setLoginBUttonAndVipButtonFrame:YES];
}

/** 设置登录按钮 */
- (void)setLoginTitle:(NSString *)loginTitle {
    if (loginTitle == nil) {
        [self.loginButton setTitle:@"  立即登录  " forState:(UIControlStateNormal)];
    } else {
        [self.loginButton setTitle:[NSString stringWithFormat:@"  %@  ",loginTitle] forState:(UIControlStateNormal)];
    }
    [self.loginButton sizeToFit];
    [self setLoginBUttonAndVipButtonFrame:YES];
}

/** 设置 VIP */
- (void)setIsVip:(BOOL)isVip {
    _isVip = isVip;
    if (_isVip) {
        [self.vipButton setImage:[UIImage imageNamed:@"New_mine_vip_light"] forState:(UIControlStateNormal)];
    } else {
        [self.vipButton setImage:[UIImage imageNamed:@"New_mine_vip_dark"] forState:(UIControlStateNormal)];
    }
    [_vipButton setUserInteractionEnabled:(!_isVip)];
    [self.vipButton sizeToFit];
        [self setLoginBUttonAndVipButtonFrame:YES];
}

- (void)setLoginBUttonAndVipButtonFrame:(BOOL)isLogin  {
    self.vipButton.center = CGPointMake(CGRectGetMaxX(self.avatar.frame) + 8 + self.vipButton.frame.size.width / 2, self.avatar.center.y + 20);
    self.loginButton.center = CGPointMake(CGRectGetMaxX(self.avatar.frame) + 8 + self.loginButton.frame.size.width / 2, CGRectGetMidY(self.avatar.frame) - 15);
}

- (void)setLoginFrame:(BOOL)isLogin {
    if (isLogin) {
        self.avatar.center = CGPointMake(kSCREEN_WIDTH / 6, self.avatar.center.y);
    } else {
        self.avatar.center = CGPointMake(kSCREEN_WIDTH / 2, self.avatar.center.y);
    }
    [self setLoginBUttonAndVipButtonFrame:YES];
}

- (void)hideNickNameAndVip {
    self.loginButton.hidden = YES;
    self.vipButton.hidden = YES;
}

- (void)showNickNameAndVip {
    self.loginButton.hidden = NO;
    self.vipButton.hidden = NO;
}

#pragma mark - getter
/** 头像 */
- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 4, kSCREEN_WIDTH / 4);
        _avatar.center = CGPointMake(kSCREEN_WIDTH / 6, kSCREEN_WIDTH * 0.2 + 10);
        _avatar.layer.cornerRadius = kSCREEN_WIDTH / 8;
        _avatar.layer.masksToBounds = YES;
        _avatar.image = [UIImage imageNamed:@"mine_loginBtn_no"];
        _avatar.userInteractionEnabled = YES;
        _avatar.layer.borderWidth = 2.0f;//边框宽度
        _avatar.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜色
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondsToAvatar)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        [_avatar addGestureRecognizer:tapRecognizer];
    }
    return _avatar;
}

- (UIButton *)vipButton {
    if (!_vipButton) {
        _vipButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _vipButton.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 5, 30);
        _vipButton.center = CGPointMake(CGRectGetMaxX(self.avatar.frame) + 8 + self.vipButton.frame.size.width / 2, self.avatar.center.y + 20);
        [_vipButton setUserInteractionEnabled:NO];
        [_vipButton addTarget:self action:@selector(respondsToVipButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _vipButton;
}

- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _settingButton.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.07, kSCREEN_WIDTH * 0.07);
        [_settingButton setBackgroundImage:[UIImage imageNamed:@"New_mine_setting_button"] forState:(UIControlStateNormal)];
        _settingButton.center = CGPointMake(kSCREEN_WIDTH * 0.9, kSCREEN_WIDTH * 0.15);
        [_settingButton addTarget:self action:@selector(respondsToSettingButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _settingButton;
}
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_loginButton setTitle:@"  立即登录  " forState:(UIControlStateNormal)];
        _loginButton.layer.cornerRadius = 15;
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.borderWidth = 2;
        _loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [_loginButton sizeToFit];
        _loginButton.center = CGPointMake(CGRectGetMaxX(self.avatar.frame) + 8 + self.loginButton.frame.size.width / 2, CGRectGetMidY(self.avatar.frame) - 15);
        [_loginButton addTarget:self action:@selector(respondsToLoginButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _loginButton;
}






@end



















