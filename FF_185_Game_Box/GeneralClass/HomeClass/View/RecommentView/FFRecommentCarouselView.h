//
//  FFRecommentCarouselView.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/2.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFRecommentCarouselView;

@protocol  FFRecommentCarouselViewDelegate <NSObject>

- (void)FFRecommentCarouselView:(FFRecommentCarouselView *)view didSelectImageWithInfo:(NSDictionary *)info;

@end

@interface FFRecommentCarouselView : UIView

/**轮播视图数组*/
@property (nonatomic, strong) NSMutableArray * rollingArray;

/** delegate */
@property (nonatomic, weak) id<FFRecommentCarouselViewDelegate> delegate;

- (instancetype)init;

- (instancetype)initWithFrame:(CGRect)frame;

/**停止定时器*/
- (void)stopTimer;

/**启动定时器*/
- (void)startTimer;




@end
