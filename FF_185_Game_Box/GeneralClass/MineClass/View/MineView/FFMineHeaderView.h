//
//  FFMineHeaderView.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFMineHeaderView;

@protocol FFmineHeaderViewDelegate <NSObject>

/** 点击 vip button */
- (void)FFMineHeaderView:(FFMineHeaderView *)view respondsToVipButton:(id)info;
/** 点击登录 button */
- (void)FFMineHeaderView:(FFMineHeaderView *)view respondsToLoginButton:(id)info;
/** 点击头像 */
- (void)FFMineHeaderView:(FFMineHeaderView *)view respondsToAvatarButton:(id)info;
/** 点击设置 */
- (void)FFMineHeaderView:(FFMineHeaderView *)view respondsToSettingButton:(id)info;

@end


@interface FFMineHeaderView : UIImageView

/** 代理  */
@property (nonatomic, weak) id<FFmineHeaderViewDelegate> delegate;

/** 头像 */
@property (nonatomic, strong) UIImageView *avatar;
/** 设置头像 */
@property (nonatomic, strong) UIImage *avatarImage;
/** 设置昵称 */
@property (nonatomic, strong) NSString *loginTitle;
/** vip */
@property (nonatomic, assign) BOOL isVip;

/** 隐藏昵称和 Vip */
- (void)hideNickNameAndVip;
/** 显示昵称和 vip */
- (void)showNickNameAndVip;

- (void)setLoginFrame:(BOOL)isLogin;



@end





