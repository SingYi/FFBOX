//
//  FFGameFooterView.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFGameFooterView;

@protocol FFGameFooterViewDelegate <NSObject>

/** 点击收藏按钮 */
- (void)FFGameFooterView:(FFGameFooterView *)detailFooter clickCollecBtn:(UIButton *)sender;

/** 点击分享按钮 */
- (void)FFGameFooterView:(FFGameFooterView *)detailFooter clickShareBtn:(UIButton *)sender;

/** 点击现在按钮 */
- (void)FFGameFooterView:(FFGameFooterView *)detailFooter clickDownLoadBtn:(UIButton *)sender;

@end

@interface FFGameFooterView : UIView

/** 是否收藏 */
@property (nonatomic, assign) BOOL isCollection;

/** 代理 */
@property (nonatomic, weak) id<FFGameFooterViewDelegate> delegate;



@end
