//
//  FFCommentListController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/17.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFCommentListController.h"
#import "FFGameCommentCell.h"
#import "ChangyanSDK.h"
#import "FFReplyToCommentController.h"
#import "SYKeychain.h"

#define CELL_IDE @"FFGameCommentCell"

@interface FFCommentListController ()

/** 当前评论数 */
@property (nonatomic, assign) NSInteger currentComments;

/** 当前评论数 */
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSString *topic_id;

/** 加载全部 */
@property (nonatomic, assign) BOOL isAll;

@end

@implementation FFCommentListController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"更多评论";
}


- (void)initDataSource {
//    [super initDataSource];
    BOX_REGISTER_CELL;
    [self.tableView.mj_header beginRefreshing];
}

/**刷新数据*/
- (void)refreshNewData {
        [ChangyanSDK loadTopic:@"" topicTitle:nil topicSourceID:[NSString stringWithFormat:@"game_%@",_gameID] pageSize:[NSString stringWithFormat:@"%ld",_currentPage * 30] hotSize:nil orderBy:nil style:nil depth:nil subSize:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {

            if (statusCode == 0) {

                NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                self.showArray = dic[@"comments"];
                self.topic_id = dic[@"topic_id"];
                _currentComments = self.showArray.count;
                if (_currentComments < _currentPage * 30) {
                    _isAll = YES;
                } else {
                    _isAll = NO;
                }

                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];

        } else {
            _isAll = YES;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

/** 加载更多数据 */
- (void)loadMoreData {
    if (_isAll) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        _currentPage++;
                [ChangyanSDK loadTopic:@"" topicTitle:nil topicSourceID:[NSString stringWithFormat:@"game_%@",_gameID] pageSize:[NSString stringWithFormat:@"%ld",_currentPage * 30] hotSize:nil orderBy:nil style:nil depth:nil subSize:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {

                    if (statusCode == 0) {

                        NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
                        NSError *err;
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                        self.showArray = dic[@"comments"];
                        _currentComments = self.showArray.count;


                        if (_currentComments < _currentPage * 30) {
                            _isAll = YES;
                        } else {
                            _isAll = NO;
                        }

                        [self.tableView reloadData];
                        [self.tableView.mj_footer endRefreshing];

                    } else {
                        _isAll = YES;
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FFGameCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];

    cell.userNick = self.showArray[indexPath.row][@"passport"][@"nickname"];

    cell.contentStr = self.showArray[indexPath.row][@"content"];

    NSMutableString *time = [NSMutableString stringWithFormat:@"%@",self.showArray[indexPath.row][@"create_time"]];

    time = [[time substringToIndex:time.length - 3] mutableCopy];

    NSDate *creatDate = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    cell.time = [formatter stringFromDate:creatDate];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    if (SSKEYCHAIN_UID == nil) {
        BOX_MESSAGE(@"尚未登录");
        return;
    }


    FFReplyToCommentController *replyController = [[FFReplyToCommentController alloc] init];
    NSMutableDictionary *dict = [self.showArray[indexPath.row] mutableCopy];
    [dict setObject:self.topic_id forKey:@"topic_id"];
    replyController.commentDict = dict;
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:replyController animated:YES];
}


#pragma mark - setter
- (void)setGameID:(NSString *)gameID {
    _gameID = gameID;
    _currentPage = 1;
    [self.tableView.mj_header beginRefreshing];
}













@end
















