//
//  FFRaidersViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/26.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFRaidersViewController.h"
#import "FFRaidersTableCell.h"
#import "FFRaidersModel.h"
#import "UIImageView+WebCache.h"

#import "FFWebViewController.h"

#define CELL_IDE @"FFRaidersTableCell"

@interface FFRaidersViewController ()

@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, strong) FFWebViewController *webView;

@end

@implementation FFRaidersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)initDataSource {
//    [super initDataSource];
    BOX_REGISTER_CELL;
    [self tableViewBegainRefreshData];
}

- (void)tableViewBegainRefreshData {
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshNewData {
    _currentPage = 0;
    [FFRaidersModel getRaidersWithPage:[NSString stringWithFormat:@"%lu",_currentPage] Completion:^(NSDictionary *content, BOOL success) {
        syLog(@"content === %@",content);
        if (success) {
//            _dataArray = [content[@"data"][@"list"] mutableCopy];
            self.showArray = [content[@"data"][@"list"] mutableCopy];
        } else {

        }

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (void)loadMoreData {
    _currentPage++;
    [FFRaidersModel getRaidersWithPage:[NSString stringWithFormat:@"%lu",_currentPage] Completion:^(NSDictionary *content, BOOL success) {
        syLog(@"content === %@",content);
        if (success) {
            NSArray *array = content[@"data"][@"list"];
            if (array.count > 0) {
                [self.showArray addObjectsFromArray:array];
                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    }];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFRaidersTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.dict = self.showArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.webView.webURL = self.showArray[indexPath.row][@"info_url"];
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:self.webView animated:YES];
    SHOW_TABBAR;
    SHOW_PARNENT_TABBAR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (FFWebViewController *)webView {
    if (!_webView) {
        _webView = [[FFWebViewController alloc] init];
        _webView.title = @"攻略";
    }
    return _webView;
}


@end
