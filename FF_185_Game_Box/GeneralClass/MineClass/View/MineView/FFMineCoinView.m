//
//  FFCoinView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMineCoinView.h"

@interface FFMineCoinView ()

@property (nonatomic, strong) UILabel *goldNumber;
@property (nonatomic, strong) UILabel *goldTitle;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UILabel *platformCoin;
@property (nonatomic, strong) UILabel *platformTitle;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UILabel *inviteIncome;
@property (nonatomic, strong) UILabel *inviteTitle;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, strong) UIButton *openVipButton;


@property (nonatomic, strong) UIButton *goldButton;
@property (nonatomic, strong) UIButton *platformButton;
@property (nonatomic, strong) UIButton *inviteButton;

@end



@implementation FFMineCoinView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.goldNumber];
    [self addSubview:self.goldTitle];
    [self addSubview:self.line1];
    [self addSubview:self.platformCoin];
    [self addSubview:self.platformTitle];
    [self addSubview:self.line2];
    [self addSubview:self.inviteIncome];
    [self addSubview:self.inviteTitle];
    [self addSubview:self.line3];
    [self addSubview:self.openVipButton];
    [self addSubview:self.goldButton];
    [self addSubview:self.platformButton];
}

#pragma mark - rsponds
- (void)respondsToGoldButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFMineCoinView:clickGoldButton:)]) {
        [self.delegate FFMineCoinView:self clickGoldButton:nil];
    }
}

- (void)respondsToplatformButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFMineCoinView:clickPlatformButton:)]) {
        [self.delegate FFMineCoinView:self clickPlatformButton:nil];
    }
}

- (void)respondsToInviteButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFMineCoinView:clickInviteButton:)]) {
        [self.delegate FFMineCoinView:self clickInviteButton:nil];
    }
}

- (void)respondsToOpenVipButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFMineCoinView:clickOpenVipButton:)]) {
        [self.delegate FFMineCoinView:self clickOpenVipButton:nil];
    }
}

#pragma mark - setter
- (void)setGoldCoinNumber:(NSString *)goldCoinNumber {
    self.goldNumber.text = [NSString stringWithFormat:@"%@",goldCoinNumber];;
}

- (void)setPlatformCoinNumber:(NSString *)platformCoinNumber {
    self.platformCoin.text = [NSString stringWithFormat:@"%@",platformCoinNumber];
}

- (void)setInviteIncomeNumber:(NSString *)inviteIncomeNumber {
    self.inviteIncome.text = [NSString stringWithFormat:@"%@",inviteIncomeNumber];
}

- (void)setIsVip:(BOOL)isVip {
    _isVip = isVip;
    if (isVip) {
        self.goldNumber.frame = CGRectMake(0, self.frame.size.height / 6, kSCREEN_WIDTH / 3, self.frame.size.height / 3);
        self.goldTitle.frame = CGRectMake(0, CGRectGetMaxY(self.goldNumber.frame), kSCREEN_WIDTH / 3, self.frame.size.height / 3);
        self.line1.center = CGPointMake(kSCREEN_WIDTH / 3, self.frame.size.height / 2);
        self.platformCoin.frame = CGRectMake(kSCREEN_WIDTH / 3, self.frame.size.height / 6, kSCREEN_WIDTH / 3, self.frame.size.height / 3);
        self.platformTitle.frame = CGRectMake(kSCREEN_WIDTH / 3, CGRectGetMaxY(self.platformCoin.frame), kSCREEN_WIDTH / 3, self.frame.size.height / 3);
        self.line2.center = CGPointMake(kSCREEN_WIDTH / 3 * 2, self.frame.size.height / 2);
        self.inviteIncome.frame = CGRectMake(kSCREEN_WIDTH / 3 * 2, self.frame.size.height / 6, kSCREEN_WIDTH / 3, self.frame.size.height / 3);
        self.inviteTitle.frame = CGRectMake(kSCREEN_WIDTH / 3 * 2, CGRectGetMaxY(self.inviteIncome.frame), kSCREEN_WIDTH / 3, self.frame.size.height / 3);
        self.goldButton.center = CGPointMake(self.goldNumber.center.x, self.bounds.size.height / 2);
        self.platformButton.center = CGPointMake(self.platformCoin.center.x, self.bounds.size.height / 2);
        self.line3.center = CGPointMake(kSCREEN_WIDTH + 20, self.frame.size.height / 2);
        self.openVipButton.frame = CGRectZero;
    } else {
        self.goldNumber.frame = CGRectMake(0, self.frame.size.height / 6, kSCREEN_WIDTH / 4, self.frame.size.height / 3);
        self.goldTitle.frame = CGRectMake(0, CGRectGetMaxY(self.goldNumber.frame), kSCREEN_WIDTH / 4, self.frame.size.height / 3);
        self.line1.center = CGPointMake(kSCREEN_WIDTH / 4, self.frame.size.height / 2);
        self.platformCoin.frame = CGRectMake(kSCREEN_WIDTH / 4, self.frame.size.height / 6, kSCREEN_WIDTH / 4, self.frame.size.height / 3);
        self.platformTitle.frame = CGRectMake(kSCREEN_WIDTH / 4, CGRectGetMaxY(self.platformCoin.frame), kSCREEN_WIDTH / 4, self.frame.size.height / 3);
        self.line2.center = CGPointMake(kSCREEN_WIDTH / 4 * 2, self.frame.size.height / 2);
        self.inviteIncome.frame = CGRectMake(kSCREEN_WIDTH / 4 * 2, self.frame.size.height / 6, kSCREEN_WIDTH / 4, self.frame.size.height / 3);
        self.inviteTitle.frame = CGRectMake(kSCREEN_WIDTH / 4 * 2, CGRectGetMaxY(self.inviteIncome.frame), kSCREEN_WIDTH / 4, self.frame.size.height / 3);
        self.goldButton.center = CGPointMake(self.goldNumber.center.x, self.bounds.size.height / 2);
        self.platformButton.center = CGPointMake(self.platformCoin.center.x, self.bounds.size.height / 2);

        self.line3.center = CGPointMake(kSCREEN_WIDTH / 4 * 3, self.frame.size.height / 2);
        self.openVipButton.frame = CGRectMake(kSCREEN_WIDTH / 4 * 3 + 4, self.frame.size.height / 6, kSCREEN_WIDTH / 4 - 8, self.frame.size.height / 3 * 2);
    }
}

#pragma mark - getter
- (UILabel *)goldNumber {
    if (!_goldNumber) {
        _goldNumber = [[UILabel alloc] init];
        _goldNumber.frame = CGRectMake(0, self.frame.size.height / 6, kSCREEN_WIDTH / 3, self.frame.size.height / 3);
        _goldNumber.textAlignment = NSTextAlignmentCenter;
        _goldNumber.text = @"0";
        _goldNumber.font = [UIFont systemFontOfSize:14];
    }
    return _goldNumber;
}

- (UILabel *)goldTitle {
    if (!_goldTitle) {
        _goldTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goldNumber.frame), kSCREEN_WIDTH / 3, self.frame.size.height / 3)];
        _goldTitle.textAlignment = NSTextAlignmentCenter;
        _goldTitle.text = @"金币";
        _goldTitle.textColor = [UIColor lightGrayColor];
        _goldTitle.font = [UIFont systemFontOfSize:13];
    }
    return _goldTitle;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.bounds = CGRectMake(0, 0, 1, self.frame.size.height / 3);
        _line1.center = CGPointMake(kSCREEN_WIDTH / 3, self.frame.size.height / 2);
        _line1.backgroundColor = [UIColor lightGrayColor];
    }
    return _line1;
}

- (UILabel *)platformCoin {
    if (!_platformCoin) {
        _platformCoin = [[UILabel alloc] init];
        _platformCoin.frame = CGRectMake(kSCREEN_WIDTH / 3, self.frame.size.height / 6, kSCREEN_WIDTH / 3, self.frame.size.height / 3);
        _platformCoin.textAlignment = NSTextAlignmentCenter;
        _platformCoin.text = @"0";
        _platformCoin.font = [UIFont systemFontOfSize:14];
    }
    return _platformCoin;
}

- (UILabel *)platformTitle {
    if (!_platformTitle) {
        _platformTitle = [[UILabel alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH / 3, CGRectGetMaxY(self.platformCoin.frame), kSCREEN_WIDTH / 3, self.frame.size.height / 3)];
        _platformTitle.textAlignment = NSTextAlignmentCenter;
        _platformTitle.text = @"平台币";
        _platformTitle.textColor = [UIColor lightGrayColor];
        _platformTitle.font = [UIFont systemFontOfSize:13];
    }
    return _platformTitle;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.bounds = CGRectMake(0, 0, 1, self.frame.size.height / 3);
        _line2.center = CGPointMake(kSCREEN_WIDTH / 3 * 2, self.frame.size.height / 2);
        _line2.backgroundColor = [UIColor lightGrayColor];
    }
    return _line2;
}

- (UILabel *)inviteIncome {
    if (!_inviteIncome) {
        _inviteIncome = [[UILabel alloc] init];
        _inviteIncome.frame = CGRectMake(kSCREEN_WIDTH / 3 * 2, self.frame.size.height / 6, kSCREEN_WIDTH / 3, self.frame.size.height / 3);
        _inviteIncome.textAlignment = NSTextAlignmentCenter;
        _inviteIncome.text = @"0";
        _inviteIncome.font = [UIFont systemFontOfSize:14];
    }
    return _inviteIncome;
}

- (UILabel *)inviteTitle {
    if (!_inviteTitle) {
        _inviteTitle = [[UILabel alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH / 3 * 2, CGRectGetMaxY(self.inviteIncome.frame), kSCREEN_WIDTH / 3, self.frame.size.height / 3)];
        _inviteTitle.textAlignment = NSTextAlignmentCenter;
        _inviteTitle.text = @"邀请奖励";
        _inviteTitle.textColor = [UIColor lightGrayColor];
        _inviteTitle.font = [UIFont systemFontOfSize:13];
    }
    return _inviteTitle;
}

- (UIView *)line3 {
    if (!_line3) {
        _line3 = [[UIView alloc] init];
        _line3.bounds = CGRectMake(0, 0, 1, self.frame.size.height / 3);
        _line3.center = CGPointMake(kSCREEN_WIDTH / 4 * 3, self.frame.size.height / 2);
        _line3.backgroundColor = [UIColor lightGrayColor];
    }
    return _line3;
}

- (UIButton *)openVipButton {
    if (!_openVipButton) {
        _openVipButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _openVipButton.frame = CGRectMake(kSCREEN_WIDTH / 4 * 3 + 4, self.frame.size.height / 6, kSCREEN_WIDTH / 4 - 8, self.frame.size.height / 3 * 2);
        [_openVipButton setTitle:@"开通会员" forState:(UIControlStateNormal)];
        [_openVipButton addTarget:self action:@selector(respondsToOpenVipButton) forControlEvents:(UIControlEventTouchUpInside)];
        _openVipButton.backgroundColor = RGBCOLOR(218, 103, 68);
        _openVipButton.layer.cornerRadius = 3;
        _openVipButton.layer.masksToBounds = YES;
    }
    return _openVipButton;
}

- (UIButton *)goldButton {
    if (!_goldButton) {
        _goldButton = [self creatButton];
        _goldButton.center = CGPointMake(self.goldNumber.center.x, self.bounds.size.height / 2);
        [_goldButton addTarget:self action:@selector(respondsToGoldButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _goldButton;
}

- (UIButton *)platformButton {
    if (!_platformButton) {
        _platformButton = [self creatButton];
        _platformButton.center = CGPointMake(self.platformCoin.center.x, self.bounds.size.height / 2);
        [_platformButton addTarget:self action:@selector(respondsToplatformButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _platformButton;
}

- (UIButton *)inviteButton {
    if (!_inviteButton) {
        _inviteButton = [self creatButton];
        _inviteButton.center = CGPointMake(self.inviteIncome.center.x, self.bounds.size.height / 2);
//        [_inviteButton addTarget:self action:@selector(respondsToGoldButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _inviteButton;
}

- (UIButton *)creatButton {
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 4, self.bounds.size.height);
    return button;
}





@end













