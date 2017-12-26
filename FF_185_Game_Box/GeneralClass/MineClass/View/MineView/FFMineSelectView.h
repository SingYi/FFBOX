//
//  FFMineSelectView.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/7.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFMineSelectView;

@protocol FFMineSelectViewDelegate <NSObject>

- (void)FFmineSelectView:(FFMineSelectView *)view didSelectButtonWithIndex:(NSInteger)idx;


@end


@interface FFMineSelectView : UIView

@property (nonatomic, strong) NSArray *selectArray;

@property (nonatomic, weak) id<FFMineSelectViewDelegate> delegate;

@property (nonatomic, assign) BOOL is185;


@end
