//
//  FFGameHeaderView.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFHomeViewSelectView.h"

@class FFGameHeaderView;


@protocol FFGameHeaderViewDelegate <NSObject>

- (void)FFGameHeaderView:(FFGameHeaderView *)view didselectBtnAtIndex:(NSInteger)index;

@end


@interface FFGameHeaderView : UIView

/**delegate*/
@property (nonatomic, weak) id<FFGameHeaderViewDelegate> delegate;

/**选择标签*/
@property (nonatomic, strong) FFHomeViewSelectView *selectView;

- (void)setUserInterface;



@end
