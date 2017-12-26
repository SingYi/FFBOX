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

/** 游戏信息 */
@property (nonatomic, strong) NSDictionary *gameInfo;

/**游戏图标*/
@property (nonatomic, strong) UIImageView *gameLogo;
/**游戏名称标签*/
@property (nonatomic, strong) UILabel *gameNameLabel;
/**下载次数标签*/
@property (nonatomic, strong) UILabel *downLoadNumber;
/**delegate*/
@property (nonatomic, weak) id<FFGameHeaderViewDelegate> delegate;
/**按钮数组*/
@property (nonatomic, strong) NSArray *btnArray;
/** 选择的下标 */
@property (nonatomic, assign) NSInteger index;
/** 游戏评分 */
@property (nonatomic, assign) CGFloat source;
/** 游戏标签 */
@property (nonatomic, strong) NSMutableArray<UILabel *> *typeLabels;
/** 游戏大小 */
@property (nonatomic, strong) UILabel *sizeLabel;
/**选择标签*/
@property (nonatomic, strong) FFHomeViewSelectView *selectView;
/** QQ群 */
@property (nonatomic, strong) NSString *qqGroup;



@end
