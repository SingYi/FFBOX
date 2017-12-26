//
//  FFResetNickNameView.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/20.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFResetNickNameView;

@protocol FFRestNickNameDelegate <NSObject>

- (void)FFResetNickNameView:(FFResetNickNameView *)view clickRestButtonWithNickName:(NSString *)nickName;

@end

@interface FFResetNickNameView : UIView

@property (nonatomic, weak) id<FFRestNickNameDelegate> delegate;

@end
