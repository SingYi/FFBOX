//
//  FFInviteFriendViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFInviteFriendViewController.h"
#import "FFSharedController.h"
#import "FFUserModel.h"
#import "FFViewFactory.h"

@interface FFInviteFriendViewController ()

@property (nonatomic, strong) UIImageView *imageBackGround;
@property (nonatomic, strong) UIImageView *upBackGround;
@property (nonatomic, strong) UIImageView *downBackGround;
@property (nonatomic, strong) UIButton *inviteButton;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *numberOfCoin;
@property (nonatomic, strong) UILabel *numberOfFriend;

@end

@implementation FFInviteFriendViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self initDataSource];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = NAVGATION_BAR_COLOR;
    self.navigationItem.title = @"邀请好友";
    [self.view addSubview:self.imageBackGround];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.imageBackGround.frame = CGRectMake(0, kNAVIGATION_HEIGHT - 2, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT + 2);
}

- (BOOL)initDataSource {
    if ([FFUserModel getUID] == nil || [FFUserModel getUID].length == 0) {
//        BOX_MESSAGE(@"尚未登录");
        return NO;
    }
    START_NET_WORK;
    [FFUserModel inviteFriendWithCompletion:^(NSDictionary *content, BOOL success) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        syLog(@"invite friend === %@",content);
        STOP_NET_WORK;
        if (success) {
            self.detailLabel.text = [NSString stringWithFormat:@"邀请好友一起玩游戏,好友在游戏中每充值1RMB,您可获得%@金币!!!\n单个好友封顶奖励%@金币,邀请人数不限!",content[@"data"][@"one_get_coin"],content[@"data"][@"recom_top"]];

            if (content[@"recom_bonus"]) {
                self.numberOfCoin.text = [NSString stringWithFormat:@"%@",content[@"recom_bonus"]];
            } else {
                self.numberOfCoin.text = @"0";
            }
            if (content[@"recom_counts"]) {
                self.numberOfFriend.text = [NSString stringWithFormat:@"%@",content[@"recom_counts"]];
            } else {
                self.numberOfFriend.text = @"0";
            }
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
    return YES;
}

#pragma mark - responds
- (void)respondsToInviteButton {
    syLog(@"邀请好友");
    [FFSharedController inviteFriend];
}



#pragma mark - getter
- (UIImageView *)imageBackGround {
    if (!_imageBackGround) {
        _imageBackGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame) - 2, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame) + 2)];

        _imageBackGround.image = [UIImage imageNamed:@"New_invite_friend_background"];
        _imageBackGround.userInteractionEnabled = YES;
        [_imageBackGround addSubview:self.upBackGround];
        [_imageBackGround addSubview:self.downBackGround];
        [_imageBackGround addSubview:self.inviteButton];
    }
    return _imageBackGround;
}

- (UIImageView *)upBackGround {
    if (!_upBackGround) {
        _upBackGround  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH * 0.88, kSCREEN_WIDTH * 0.52)];
        _upBackGround.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_WIDTH * 0.925);

        _upBackGround.image = [UIImage imageNamed:@"New_invite_friend_up_background"];

        UIImageView *titleImage = [[UIImageView alloc] init];
        titleImage.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.39, kSCREEN_WIDTH * 0.09);
        titleImage.center = CGPointMake(kSCREEN_WIDTH * 0.44, kSCREEN_WIDTH * 0.12);
        titleImage.image = [UIImage imageNamed:@"New_invite_up_title_image"];
        [_upBackGround addSubview:titleImage];

        [_upBackGround addSubview:self.detailLabel];

    }
    return _upBackGround;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.764, kSCREEN_WIDTH * 0.2);
        _detailLabel.numberOfLines = 0;
        _detailLabel.text = @"邀请好友一起玩游戏,好友在游戏中每充值1RMB,您可获得10金币!!!\n单个好友封顶奖励2000金币,邀请人数不限!";
        _detailLabel.font = [UIFont systemFontOfSize:15];
        [_detailLabel sizeToFit];
        _detailLabel.center = CGPointMake(kSCREEN_WIDTH * 0.44, kSCREEN_WIDTH * 0.33);
    }
    return _detailLabel;
}

- (UIImageView *)downBackGround {
    if (!_downBackGround) {
        _downBackGround  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH * 0.88, kSCREEN_WIDTH * 0.213)];
        _downBackGround.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_WIDTH * 1.30);
        _downBackGround.image = [UIImage imageNamed:@"New_invite_friend_down_background"];

        UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH * 0.167, kSCREEN_WIDTH * 0.055)];
        left.image = [UIImage imageNamed:@"New_invite_left"];
        left.center = CGPointMake(kSCREEN_WIDTH * 0.88 / 4, kSCREEN_WIDTH * 0.056);
        [_downBackGround addSubview:left];

        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.text = @"(金币)";
        leftLabel.font = [UIFont systemFontOfSize:14];
        [leftLabel sizeToFit];
        leftLabel.center = CGPointMake(left.center.x, kSCREEN_WIDTH * 0.18);
        [_downBackGround addSubview:leftLabel];

        self.numberOfCoin.center = CGPointMake(left.center.x, ( (CGRectGetMinY(leftLabel.frame)) + (CGRectGetMaxY(left.frame)) ) / 2);
        [_downBackGround addSubview:self.numberOfCoin];

        UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH * 0.167, kSCREEN_WIDTH * 0.055)];
        right.image = [UIImage imageNamed:@"New_invite_right"];
        right.center = CGPointMake(kSCREEN_WIDTH * 0.88 / 4 * 3, kSCREEN_WIDTH * 0.056);
        [_downBackGround addSubview:right];

        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.text = @"(人数)";
        rightLabel.font = [UIFont systemFontOfSize:14];
        [rightLabel sizeToFit];
        rightLabel.center = CGPointMake(right.center.x, kSCREEN_WIDTH * 0.18);
        [_downBackGround addSubview:rightLabel];

        self.numberOfFriend.center = CGPointMake(right.center.x, ((CGRectGetMinY(rightLabel.frame)) + (CGRectGetMaxY(right.frame))) / 2);
        [_downBackGround addSubview:self.numberOfFriend];
    }
    return _downBackGround;
}

- (UIButton *)inviteButton {
    if (!_inviteButton) {
        _inviteButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _inviteButton.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.88, kSCREEN_WIDTH * 0.12);
        _inviteButton.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_WIDTH * 1.49);
//        [_inviteButton setTitle:@"立即邀请好友" forState:(UIControlStateNormal)];
        [_inviteButton setBackgroundImage:[UIImage imageNamed:@"New_invite_friend_invite_button"] forState:(UIControlStateNormal)];
        [_inviteButton addTarget:self action:@selector(respondsToInviteButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _inviteButton;
}

- (UILabel *)numberOfCoin {
    if (!_numberOfCoin) {
        _numberOfCoin = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH * 0.3, kSCREEN_WIDTH * 0.075)];
        _numberOfCoin.textAlignment = NSTextAlignmentCenter;
        _numberOfCoin.textColor = [UIColor orangeColor];
        _numberOfCoin.text = @"0";
        _numberOfCoin.font = [UIFont systemFontOfSize:16];
    }
    return _numberOfCoin;
}

- (UILabel *)numberOfFriend {
    if (!_numberOfFriend) {
        _numberOfFriend = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH * 0.3, kSCREEN_WIDTH * 0.075)];
        _numberOfFriend.textAlignment = NSTextAlignmentCenter;
        _numberOfFriend.textColor = [UIColor orangeColor];
        _numberOfFriend.text = @"0";
        _numberOfFriend.font = [UIFont systemFontOfSize:16];
    }
    return _numberOfFriend;
}

@end






