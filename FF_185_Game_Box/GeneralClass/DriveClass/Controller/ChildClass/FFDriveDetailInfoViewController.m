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
#import "UIAlertController+FFAlertController.h"

#define CELL_IDE @"FFDriveCommentCell"

@interface FFDriveDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource,FFDetailFooterViewDelegate,FFDriveCommentCellDelegate,FFDetailHeaderViewDelegate>

@property (nonatomic, strong) FFDetailHeaderView *headerView;
@property (nonatomic, strong) FFDetailFooterView *footerView;
@property (nonatomic, strong) UILabel *commentNumberLabel;
@property (nonatomic, strong) UILabel *hotLabel;
@property (nonatomic, strong) NSMutableArray *hotListArray;



@end

@implementation FFDriveDetailInfoViewController {
    CommentType commentType;
    NSUInteger currentPage;
    NSString *attentionString;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessageCallBackNotification:) name:SendCommentNotificationName object:nil];
    }
    return self;
}

- (void)sendMessageCallBackNotification:(NSNotification *)notification {
    syLog(@"发送评论 : %@",notification.userInfo);
    NSDictionary *dict = notification.userInfo;
    NSString *status = dict[@"status"];
    if (status.integerValue == 1) {
        [self refreshNewData];
        NSString *data = [NSString stringWithFormat:@"%@",dict[@"data"]];
        if (data.integerValue > 0) {
            NSString *msg = [NSString stringWithFormat:@"评论成功\n 奖励%@金币",data];
            BOX_MESSAGE(msg);
        } else {
            BOX_MESSAGE(@"发送评论成功");
        }
    } else {
        BOX_MESSAGE(dict[@"msg"]);
    }
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
    syLog(@"刷新动态详情页面");
    currentPage = 1;
    hud_add;
    [FFDriveModel userComeentListWithDynamicsID:self.dynamic_id type:hotType page:[NSString stringWithFormat:@"%lu",currentPage] Complete:^(NSDictionary *content, BOOL success) {
        syLog(@"comment list === %@",content);
        hud_remove;
        if (success) {
            NSArray *array = content[@"data"][@"list"];
            self.showArray = [array mutableCopy];
            NSArray *hotArray = content[@"data"][@"hot_list"];
            self.hotListArray = [hotArray mutableCopy];
            if (_detailModel == nil) {
                _detailModel = [FFDynamicModel modelWithDict:nil];
            }
            [self.detailModel setPropertyWithDetailCommentLishVeiwDictionary:content[@"data"][@"dynamics_info"]];
            [self setOtherModel:self.detailModel];
            [self.headerView setAttentionWith:self.detailModel.attention];
            [self.tableView reloadData];
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
        
        if (self.showArray.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }

//        [self cheackShowArrayIsempty];

        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    syLog(@"加载更多详情");
    currentPage++;
    [FFDriveModel userComeentListWithDynamicsID:self.detailModel.dynamic_id type:hotType page:[NSString stringWithFormat:@"%lu",currentPage] Complete:^(NSDictionary *content, BOOL success) {
        NSArray *array = content[@"data"][@"list"];
        if (success) {
            [self.showArray addObjectsFromArray:array];
            [self.tableView reloadData];
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
        if (array.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
//        [self cheackShowArrayIsempty];
    }];
}


#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.hotListArray.count;
    } else {
        return self.showArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFDriveCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.delegate = self;
    if (indexPath.section == 0) {
        cell.dict = self.hotListArray[indexPath.row];
    } else {
        cell.dict = self.showArray[indexPath.row];
    }
    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return (section == 0) ? [self creatViewWithLabel:self.hotLabel] : [self creatViewWithLabel:self.commentNumberLabel];
}

- (UIView *)creatViewWithLabel:(UILabel *)label {
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:label];

    CALayer *layer1 = [[CALayer alloc] init];
    layer1.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 1);
    layer1.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    [view.layer addSublayer:layer1];

    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 43, kSCREEN_WIDTH, 1);
    layer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    [view.layer addSublayer:layer];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self didSelectRowShowAlertWith:indexPath];
}

- (void)didSelectRowShowAlertWith:(NSIndexPath *)indexPath {
    FF_is_login;
    NSDictionary *dict = (indexPath.section == 0) ? self.hotListArray[indexPath.row] : self.showArray[indexPath.row];
    NSString *uid = dict[@"uid"];
    if ([uid isEqualToString:SSKEYCHAIN_UID]) {
        [UIAlertController showAlertControllerWithViewController:self alertControllerStyle:(UIAlertControllerStyleActionSheet) title:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" CallBackBlock:^(NSInteger btnIndex) {
            [self didSelectCellWithButtonIndex:btnIndex WithIndexPaht:indexPath isSelfComment:YES];
        } otherButtonTitles:@"点赞", nil];
    } else {
        [UIAlertController showAlertControllerWithViewController:self alertControllerStyle:(UIAlertControllerStyleActionSheet) title:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil CallBackBlock:^(NSInteger btnIndex) {
            [self didSelectCellWithButtonIndex:btnIndex WithIndexPaht:indexPath isSelfComment:NO];
        } otherButtonTitles:@"评论",@"点赞", nil];
    }
}

#pragma mark - cell click
- (void)didSelectCellWithButtonIndex:(NSUInteger)index WithIndexPaht:(NSIndexPath *)indexPath isSelfComment:(BOOL)isSelfComment {
    syLog(@"select button index : %lu",index);
    switch (index) {
        case 0:
            break;
        case 1: {
            isSelfComment ? [self deleteCommentWith:indexPath] : [self replyCommentWint:indexPath];
        }
            break;
        case 2: {
            [self commentLikeWith:indexPath];
        }
            break;
        default:
            break;
    }
}


#pragma mark - cell delegate
- (void)FFDriveCommentCell:(FFDriveCommentCell *)cell didClickLikeButtonWith:(NSDictionary *)dict {
    syLog(@"like button ");
    FF_is_login;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self commentLikeWith:indexPath];
}

- (void)commentLikeWith:(NSIndexPath *)indexPath {
    FFDriveCommentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *mdict = cell.dict.mutableCopy;
    NSString *likeType = [NSString stringWithFormat:@"%@",mdict[@"like_type"]];
    if ([likeType isEqualToString:@"2"]) {
        [FFDriveModel userLikeOrDislikeComment:mdict[@"id"] Type:like Complete:^(NSDictionary *content, BOOL success) {
            if (success) {
                [mdict setObject:@"1" forKey:@"like_type"];
                NSString *likes = mdict[@"likes"];
                [mdict setObject:[NSString stringWithFormat:@"%lu",(likes.integerValue + 1)] forKey:@"likes"];
                [self.showArray replaceObjectAtIndex:indexPath.row withObject:mdict];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            } else {
                BOX_MESSAGE(content[@"msg"]);
            }
        }];
    } else {
        BOX_MESSAGE(@"已经赞过该评论.");
    }
}

#pragma mark - delete comment
- (void)deleteCommentWith:(NSIndexPath *)indexPath {
    syLog(@"删除评论");
    NSDictionary *dict = (indexPath.section == 0) ? self.hotListArray[indexPath.row] : self.showArray[indexPath.row];
    NSString *commentID = dict[@"id"];
    [FFDriveModel userDeleteCommentWith:commentID Complete:^(NSDictionary *content, BOOL success) {
        if (success) {
            [self refreshNewData];
            BOX_MESSAGE(@"删除成功");
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

#pragma mark - reply comment
- (void)replyCommentWint:(NSIndexPath *)indexPath  {
    syLog(@"回复评论");
    NSDictionary *dict = (indexPath.section == 0) ? self.hotListArray[indexPath.row] : self.showArray[indexPath.row];
    NSString *toUid = dict[@"uid"];
    [FFDriveReplyView showReplyViewWithDynamicID:self.detailModel.dynamic_id ToUid:toUid];
}

#pragma mark - responds
- (void)respondsToLikeOrDislikeButtonWithDynamicsID:(NSString *)dynamicsID Type:(LikeOrDislike)type {
    FF_is_login;
    [FFDriveModel userLikeOrDislikeWithDynamicsID:self.detailModel.dynamic_id type:type Complete:^(NSDictionary *content, BOOL success) {
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

    _dict = dict;
    [self refreshNewData];
}

#pragma mark - header view delegate
- (void)FFDetailHeaderView:(FFDetailHeaderView *)view clickAttentionButton:(id)info {
    FF_is_login;
    syLog(@"关注 %@",self.model.present_user_uid);
    [FFDriveModel userAttentionWith:self.detailModel.present_user_uid Type:(self.detailModel.attention.integerValue == 0) ? attention : cancel  Complete:^(NSDictionary *content, BOOL success) {
        syLog(@"attention === %@",content);
        if (success) {
            [self refreshNewData];
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

#pragma mark - footer view delegate
- (void)FFDetailFooterView:(FFDetailFooterView *)view didClickButton:(NSUInteger)idx {
    syLog(@"click button %ld",idx);
    switch (idx) {
        case 0: [self respondsToLikeOrDislikeButtonWithDynamicsID:self.detailModel.dynamic_id Type:like]; break;
        case 1: [self respondsToLikeOrDislikeButtonWithDynamicsID:self.detailModel.dynamic_id Type:dislike]; break;
        case 2: [self respondsSharedButtonClick]; break;
        case 3: [self showWirteReview]; break;
        default: break;
    }
}

- (void)respondsSharedButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFDriveDetailController:SharedWith:)]) {
        [self.delegate FFDriveDetailController:self SharedWith:self.indexPath];
    }
}


- (void)showWirteReview {
    syLog(@"评论");
    FF_is_login;
    [FFDriveReplyView showReplyViewWithDynamicID:self.detailModel.dynamic_id ToUid:nil];
}

#pragma mark - setter
- (void)setModel:(FFDynamicModel *)model {
    self.detailModel = model;
}

- (void)setDetailModel:(FFDynamicModel *)detailModel {
    _detailModel = detailModel;
    self.commentNumberLabel.text = [NSString stringWithFormat:@" 评论 : %@",detailModel.comments_number];
    [self setOtherModel:detailModel];
    self.dynamic_id = detailModel.dynamic_id;
}

- (void)setOtherModel:(FFDynamicModel *)model {
    self.headerView.model = model;
    self.footerView.model = model;
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setDynamic_id:(NSString *)dynamic_id {
    _dynamic_id = dynamic_id;
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - getter
- (FFDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFDetailHeaderView alloc] init];
        _headerView.delegate = self;
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

- (UILabel *)hotLabel {
    if (!_hotLabel) {
        _hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH / 2 - 10, 44)];
        _hotLabel.textAlignment = NSTextAlignmentLeft;
        _hotLabel.font = [UIFont systemFontOfSize:16];
        _hotLabel.textColor = [UIColor darkGrayColor];
        _hotLabel.text = @" 热门评论 :";
    }
    return _hotLabel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SendCommentNotificationName object:nil];
}



@end





