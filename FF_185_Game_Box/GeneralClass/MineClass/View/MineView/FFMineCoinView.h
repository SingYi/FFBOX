//
//  FFCoinView.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFMineCoinView;

@protocol FFMineCoinViewDelegate <NSObject>

/** 点击金币 */
- (void)FFMineCoinView:(FFMineCoinView *)view clickGoldButton:(id)info;
/** 点击平台币 */
- (void)FFMineCoinView:(FFMineCoinView *)view clickPlatformButton:(id)info;
/** 点击邀请好友奖励 */
- (void)FFMineCoinView:(FFMineCoinView *)view clickInviteButton:(id)info;
/** 点击开通 VIP */
- (void)FFMineCoinView:(FFMineCoinView *)view clickOpenVipButton:(id)info;

@end

@interface FFMineCoinView : UIView

@property (nonatomic, weak) id<FFMineCoinViewDelegate> delegate;

@property (nonatomic, strong) NSString *goldCoinNumber;
@property (nonatomic, strong) NSString *inviteIncomeNumber;
@property (nonatomic, strong) NSString *platformCoinNumber;

@property (nonatomic, assign) BOOL isVip;








@end
