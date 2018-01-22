//
//  FFDriveDetailInfoViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/19.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveDetailInfoViewController.h"
#import "FFDetailHeaderView.h"
#import "FFDetailFooterView.h"
#import "DriveInfoCell.h"
#import "FFDriveReplyView.h"
#import "FFDriveCommentCell.h"

#define CELL_IDE @"FFDriveCommentCell"

@interface FFDriveDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource,FFDetailFooterViewDelegate>


@property (nonatomic, strong) FFDetailHeaderView *headerView;
@property (nonatomic, strong) FFDetailFooterView *footerView;
@property (nonatomic, strong) UILabel *commentNumberLabel;

@end

@implementation FFDriveDetailInfoViewController {
    NSString *dynamicsID;
    CommentType commentType;
    NSUInteger currentPage;

}



- (void)viewDidLoad {
    [super viewDidLoad];
}



- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"动态详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.footerView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initDataSource {

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT - 44);
}


- (void)refreshNewData {
    syLog(@"刷新");
    currentPage = 1;
    [FFDriveModel userComeentListWithDynamicsID:dynamicsID type:commentType page:[NSString stringWithFormat:@"%lu",currentPage] Complete:^(NSDictionary *content, BOOL success) {
        syLog(@"comment list === %@",content);
        if (success) {
            NSArray *array = content[@"data"][@"list"];
            self.showArray = [array mutableCopy];
            [self.tableView reloadData];
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }

        if (self.showArray.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }

        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFDriveCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];

    cell.dict = self.showArray[indexPath.row];

    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];

    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.commentNumberLabel];

    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 43, kSCREEN_WIDTH, 1);
    layer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    [view.layer addSublayer:layer];

    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - responds
- (void)respondsToLikeOrDislikeButtonWithDynamicsID:(NSString *)dynamicsID Type:(LikeOrDislike)type {
    [FFDriveModel userLikeOrDislikeWithDynamicsID:dynamicsID type:type Complete:^(NSDictionary *content, BOOL success) {
        if (success) {
            [self replaceDictWithtype:type];
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

- (void)replaceDictWithtype:(LikeOrDislike)type {
    NSMutableDictionary *dict = [self.dict mutableCopy];
    NSMutableDictionary *dynamics = [dict[@"dynamics"] mutableCopy];
    NSMutableDictionary *user = [dict[@"user"] mutableCopy];
    if (type == like) {
        NSString *like = dynamics[@"likes"];
        [dynamics setObject:[NSString stringWithFormat:@"%ld",(like.integerValue + 1)] forKey:@"likes"];
        [user setObject:@"1" forKey:@"operate"];
    } else {
        NSString *like = dynamics[@"dislike"];
        [dynamics setObject:[NSString stringWithFormat:@"%ld",(like.integerValue + 1)] forKey:@"dislike"];
        [user setObject:@"0" forKey:@"operate"];
    }

    [dict setObject:dynamics forKey:@"dynamics"];
    [dict setObject:user forKey:@"user"];

    if (self.delegate && [self.delegate respondsToSelector:@selector(FFDriveDetailController:replaceDict:indexPath:)]) {
        [self.delegate FFDriveDetailController:self replaceDict:dict indexPath:self.indexPath];
        syLog(@"点赞");
    }

    [self setDataDict:dict];
    [self refreshNewData];
}

#pragma mark - footer view delegate
- (void)FFDetailFooterView:(FFDetailFooterView *)view didClickButton:(NSUInteger)idx {
    syLog(@"click button %ld",idx);
    switch (idx) {
        case 0: {
            [self respondsToLikeOrDislikeButtonWithDynamicsID:dynamicsID Type:like];
        }
            break;
        case 1: {
            [self respondsToLikeOrDislikeButtonWithDynamicsID:dynamicsID Type:dislike];
        }
            break;
        case 2: {

        }
            break;
        case 3: {
            [self showWirteReview];
        }
            break;

        default:
            break;
    }
}

- (void)showWirteReview {
    syLog(@"评论");
    [FFDriveReplyView showReplyViewWithDynamicID:dynamicsID ToUid:nil];
}

#pragma mark - setter
- (void)setIsComment:(BOOL)isComment {
    _isComment = isComment;
}

- (void)setDict:(NSDictionary *)dict {

    if (dict == nil) {
        return;
    }

    syLog(@"dict == %@", dict);
    _dict = dict;
    [self setDataDict:dict];

    self.showArray = [NSMutableArray array];
    [self.tableView reloadData];

    self.tableView.tableHeaderView = self.headerView;
    [self refreshNewData];

}

- (void)setDataDict:(NSDictionary *)dict {
    [self setFooterDict:dict];
    dynamicsID = [NSString stringWithFormat:@"%@",dict[@"dynamics"][@"id"]];
    commentType = timeType;

}

- (void)setFooterDict:(NSDictionary *)dict {
    self.footerView.dict = dict;
    self.headerView.dict = dict;
    [self setCommentNUmber:dict[@"dynamics"][@"comment"]];
}

- (void)setCommentNUmber:(NSString *)str {
    self.commentNumberLabel.text = [NSString stringWithFormat:@" 评论 : %@",str];
}




#pragma mark - getter
- (FFDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFDetailHeaderView alloc] init];
    }
    return _headerView;
}

- (FFDetailFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[FFDetailFooterView alloc] init];
        _footerView.frame = CGRectMake(0, kSCREEN_HEIGHT - 44, kSCREEN_WIDTH, 44);
        _footerView.delegate = self;
    }
    return _footerView;
}

- (UILabel *)commentNumberLabel {
    if (!_commentNumberLabel) {
        _commentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH / 2 - 10, 44)];
        _commentNumberLabel.textAlignment = NSTextAlignmentLeft;
        _commentNumberLabel.font = [UIFont systemFontOfSize:16];
        _commentNumberLabel.textColor = [UIColor darkGrayColor];
    }
    return _commentNumberLabel;
}



@end





