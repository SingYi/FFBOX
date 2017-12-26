//
//  FFOpenServerSelectView.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/31.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFOpenServerSelectView;

@protocol FFOpenServerSelectViewDelegate <NSObject>

- (void)FFOpenServerSelectView:(FFOpenServerSelectView *)selectView didSelectBtnAtIndexPath:(NSInteger)idx;

@end



@interface FFOpenServerSelectView : UIView

- (instancetype)initWithFrame:(CGRect)frame WithBtnArray:(NSArray *)btnNameArray;


@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;

@property (nonatomic, strong) UIView *seleView;

@property (nonatomic, strong) NSArray *btnNameArray;

@property (nonatomic, weak) id<FFOpenServerSelectViewDelegate> delegate;

/**是否在动画中*/
@property (nonatomic, assign) BOOL isAnimation;

/**移动主视图时下标的位置*/
@property (nonatomic, assign) NSInteger index;

/** 分割线颜色 */
@property (nonatomic, strong) UIColor *lineColor;

/** 移动标签 */
- (void)reomveLabelWithX:(CGFloat)x;




@end
