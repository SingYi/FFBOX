//
//  FFMineViewCell.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/26.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFMineViewCell : UITableViewCell

+ (void)registCellWithTableView:(UITableView *)tableView;

+ (instancetype)dequeueReusableCellWithIdentifierWithTableView:(UITableView *)tableView;


//子控制器是否可以滑动  YES可以滑动
@property (nonatomic, assign) BOOL canScroll;
//外部segment点击更改selectIndex,切换页面
@property (assign, nonatomic) NSInteger selectIndex;
//创建pageViewController
- (void)setPageView;



@end
