//
//  FFYesterdayOpenServerViewController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/31.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicViewController.h"
#import "FFOpenServerModel.h"
#import "FFOpenServerCell.h"
#import "UIImageView+WebCache.h"

#define CELL_IDE @"FFOpenServerCell"


@interface FFYesterdayOpenServerViewController : FFBasicViewController


@property (nonatomic, strong) FFOpenServerModel *model;


- (void)tableViewBegainRefreshing;



@end
