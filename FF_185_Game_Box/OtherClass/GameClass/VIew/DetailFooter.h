//
//  DetailFooter.h
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailFooter;

@protocol DetailFooterDelegate <NSObject>

/** 点击收藏按钮 */
- (void)DetailFooter:(DetailFooter *)detailFooter clickCollecBtn:(UIButton *)sender;

/** 点击分享按钮 */
- (void)DetailFooter:(DetailFooter *)detailFooter clickShareBtn:(UIButton *)sender;

/** 点击现在按钮 */
- (void)DetailFooter:(DetailFooter *)detailFooter clickDownLoadBtn:(UIButton *)sender;

@end

@interface DetailFooter : UIView



/** 是否收藏 */
@property (nonatomic, assign) BOOL isCollection;

/** 代理 */
@property (nonatomic, weak) id<DetailFooterDelegate> delegate;

/** 设置按钮打开还是下载 */
@property (nonatomic, assign) BOOL isOpen;



@end
