//
//  FFDriveAllInfoViewController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/11.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFDriveModel.h"
#import "FFViewFactory.h"
#import "MBProgressHUD.h"


@interface FFDriveAllInfoViewController : UIViewController

/** table View */
@property (nonatomic, strong) UITableView *tableView;

/** table view data source */
@property (nonatomic, strong) NSMutableArray *showArray;


@property (nonatomic, assign) DynamicType dynamicType;


- (void)initUserInterface;

- (void)initDataSource;

- (void)refreshNewData;

- (void)loadMoreData;

@end





