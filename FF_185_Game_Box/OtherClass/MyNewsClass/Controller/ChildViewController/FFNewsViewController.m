//
//  FFNewsViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/23.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFNewsViewController.h"
#import "FFMyNewsModel.h"
#import "FFMyNewsCell.h"
#import "FFReplyToCommentController.h"


#define CELL_IDE @"FFMyNewsCell"

#define MODEL FFMyNewsModel

@interface FFNewsViewController ()

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation FFNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.view.bounds.size.height);
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.layer.masksToBounds = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.view.bounds.size.height);
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - method
- (void)refreshNewData {
    START_NET_WORK;
    _currentPage = 1;

    [MODEL getUserNewsWithPage:[NSString stringWithFormat:@"%ld",_currentPage] CompleteBlock:^(NSDictionary *content, BOOL success) {
        STOP_NET_WORK;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        if (success) {
            self.showArray = [content[@"replies"] mutableCopy];
        } else {
            self.showArray = nil;
            BOX_MESSAGE(@"暂无数据");
        }
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    START_NET_WORK;
    _currentPage++;
    [MODEL getUserNewsWithPage:[NSString stringWithFormat:@"%ld",_currentPage] CompleteBlock:^(NSDictionary *content, BOOL success) {
        STOP_NET_WORK;
        if (success) {
            //            syLog(@"contetn $ %@",content);
            NSArray *array = content[@"replies"];
            if (array == nil ||array.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.showArray addObjectsFromArray:array];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFMyNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];

    cell.dict = self.showArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.showArray[indexPath.row];
    FFReplyToCommentController *replyController = [[FFReplyToCommentController alloc] init];
    replyController.commentDict = dict;
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:replyController animated:YES];

}






@end






