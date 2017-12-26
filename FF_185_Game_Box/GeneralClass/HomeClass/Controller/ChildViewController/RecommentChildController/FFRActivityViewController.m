//
//  FFRActivityViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/2.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFRActivityViewController.h"
#import "FFActivityModel.h"
#import "FFActivityCell.h"
#import "FFWebViewController.h"

#define CELL_IDE @"FFActivityCell"

@interface FFRActivityViewController ()<UITableViewDelegate>

@property (nonatomic, strong) FFActivityModel *model;

@property (nonatomic, strong) FFWebViewController *webViewController;

@end

@implementation FFRActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame));
}


- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"活动";
    self.view.backgroundColor = [UIColor whiteColor];
    BOX_REGISTER_CELL;
}

- (void)initDataSource {
    [super initDataSource];
    [self.tableView.mj_header beginRefreshing];
}


- (void)refreshNewData {
    WeakSelf;
    [self.model loadNewActivityWithCompletion:^(NSDictionary *content, BOOL success) {

        if (success) {
            weakSelf.showArray = [content[@"data"][@"list"] mutableCopy];
        } else {

        }

        if (weakSelf.showArray && weakSelf.showArray.count > 0) {
            weakSelf.tableView.backgroundView = nil;
        } else {
            weakSelf.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }

        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
    }];
}


- (void)loadMoreData {
    WeakSelf;
    [self.model loadMoreActivityWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSArray *dataArray = content[@"data"][@"list"];
            if (dataArray.count > 0) {
                [weakSelf.showArray addObjectsFromArray:dataArray];
                [weakSelf.tableView.mj_footer endRefreshing];
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {

            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FFActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];

    cell.dict = self.showArray[indexPath.row];

    [cell.activityLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,self.showArray[indexPath.row][@"logo"]]] placeholderImage:[UIImage imageNamed:@"image_downloading"]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.webViewController.webURL = self.showArray[indexPath.row][@"info_url"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.webViewController animated:YES];
}

#pragma mark - model
- (FFActivityModel *)model {
    if (!_model) {
        _model = [[FFActivityModel alloc] init];
    }
    return _model;
}

- (FFWebViewController *)webViewController {
    if (!_webViewController) {
        _webViewController = [[FFWebViewController alloc] init];
    }
    return _webViewController;
}

@end
