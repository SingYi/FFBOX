//
//  FFBasicViewController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/3.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFViewFactory.h"
#import "FFBasicSelectView.h"

#define BOX_START_ANIMATION  [FFViewFactory startWaitAnimation]
#define BOX_STOP_ANIMATION [FFViewFactory stopWaitAnimation]

#define BOX_REGISTER_CELL [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE]


@interface FFBasicViewController : UIViewController

/** table View */
@property (nonatomic, strong) UITableView *tableView;

/** table view data source */
@property (nonatomic, strong) NSMutableArray *showArray;


/** 初始化用户界面 */
- (void)initUserInterface;

/** 初始化数据源 */
- (void)initDataSource;

/** tableview 刷新数据 */
- (void)refreshNewData;

/** tableview 加载更多数据 */
- (void)loadMoreData;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;









@end











