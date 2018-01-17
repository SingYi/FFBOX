//
//  FFGameDetailViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFGameDetailViewController.h"

#import "FFGameDetailTableHeader.h"

#import "UIImageView+WebCache.h"

#import "FFGameDetailTableViewCell.h"
#import "FFGameGifTableViewCell.h"
#import "FFClassifyTableCell.h"
#import "FFGameCommentCell.h"

#import "FFCommentListController.h"
#import "FFReplyToCommentController.h"

#import "Reachability.h"

#define CELL_IDE_GAMEDETAIL @"FFGameDetailTableViewCell"
#define CELL_IDE_GAMEGIF @"FFGameGifTableViewCell"
#define CELL_IDE_CLASSIFY @"FFClassifyTableCell"
#define CELL_IDE_COMMENT @"FFGameCommentCell"

//typedef enum : NSInteger {
//    NotReachable = 0,
//    ReachableViaWiFi,
//    kReachableVia2G,
//    kReachableVia3G,
//    kReachableVia4G
//} NetworkStatus1;

//typedef enum : NSInteger {
//    NotReachable = 0,
//    ReachableViaWiFi,
//    ReachableViaWWAN
//} NetworkStatus;


@interface FFGameDetailViewController () <UITableViewDelegate, UITableViewDataSource>

/**展示图数组*/
@property (nonatomic, strong) NSArray * imagasArray;
/**猜你喜欢数组*/
@property (nonatomic, strong) NSArray * likes;
/**游戏相关数据*/
@property (nonatomic, strong) NSDictionary *dict;
/** 游戏简介 */
@property (nonatomic, strong) NSString *abstract;
/** 游戏特征 */
@property (nonatomic, strong) NSString *feature;
/** 游戏返利 */
@property (nonatomic, strong) NSString *rebate;
/** gif */
@property (nonatomic, strong) NSString *gifUrl;
/** gif 图模式 */
@property (nonatomic, strong) NSString *gifModel;
/** vip */
@property (nonatomic, strong) NSString *vip;

@property (nonatomic, strong) NSDictionary *gameInfo;

/** =============================== */
/**头部视图*/
@property (nonatomic, strong) FFGameDetailTableHeader *tableHeaderView;
/** 上次点击的cell */
@property (nonatomic, strong) FFGameDetailTableViewCell *lastCell;
/**游戏内容和评论*/
@property (nonatomic, strong) UITableView *tableView;
/**用于显示的数组*/
@property (nonatomic, strong) NSArray *showArray;
/**section显示的数组*/
@property (nonatomic, strong) NSArray * sectionTitleArray;
/** 返回的行高 */
@property (nonatomic, strong) NSMutableArray *rowHeightArray;
/**尾部视图:点击显示更多评论*/
@property (nonatomic, strong) UIView *footerView;
/** 更多评论页码 */
@property (nonatomic, strong) FFCommentListController *commentListController;

@end

@implementation FFGameDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.tableView];
}

- (void)initDataSource {
    _sectionTitleArray = @[@"    游戏简介:",@"    游戏特征:",@"    精彩时刻:",@"     VIP价格:",@"    猜你喜欢:",@"    用户评论:"];
    _rowHeightArray = [@[@100.f,@100.f,@100.f,@100.f] mutableCopy];
    _commentArray = @[];
}

- (void)goToTop {
    syLog(@"??");
    [self.tableView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark - responds
- (void)respondsToMoreCommentBtn {
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    self.commentListController.gameID = _gameID;
    self.commentListController.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
    [self.navigationController pushViewController:self.commentListController animated:YES];
}

#pragma mark - tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == _sectionTitleArray.count - 1) {
        return _commentArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FFGameDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE_GAMEDETAIL];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    switch (indexPath.section) {
        case 0:
            [self setAbstractCell:cell IndexPath:indexPath];
            return cell;
        case 1: {
            [self setFeatureCell:cell IndexPath:indexPath];
            return cell;
        }
        case 2: {
            FFGameGifTableViewCell *gifCell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE_GAMEGIF];
            [self setGifCell:gifCell IndexPath:indexPath];
            return gifCell;
        }
        case 3:
            [self setVipCell:cell IndexPath:indexPath];
            return cell;
        case 4: {
            FFClassifyTableCell *likeCell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE_CLASSIFY];
            [self setLikeCell:likeCell IndexPath:indexPath];
            return likeCell;
        }
        default: {
            FFGameCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE_COMMENT];
            [self setCommentCell:commentCell IndePath:indexPath];
            return commentCell;
        }
            break;
    }

    return cell;
}

/** 游戏简介 cell */
- (void)setAbstractCell:(FFGameDetailTableViewCell *)cell IndexPath:(NSIndexPath *)indexPath {
    cell.detail.text = self.abstract;
    cell.detail.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, ((NSNumber *)_rowHeightArray[indexPath.section]).floatValue);
    cell.isOpen = NO;
    cell.tag = 10086;
    if (cell.isOpen) {
        cell.detail.lineBreakMode = NSLineBreakByWordWrapping;
    } else {
        cell.detail.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
}

/** 游戏特性 cell */
- (void)setFeatureCell:(FFGameDetailTableViewCell *)cell IndexPath:(NSIndexPath *)indexPath {
    cell.detail.text = self.feature;
    cell.detail.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, ((NSNumber *)_rowHeightArray[indexPath.section]).floatValue);
    cell.isOpen = NO;
    cell.tag = 10086;
    if (cell.isOpen) {
        cell.detail.lineBreakMode = NSLineBreakByWordWrapping;
    } else {
        cell.detail.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
}

/** gif cell */
- (void)setGifCell:(FFGameGifTableViewCell *)cell IndexPath:(NSIndexPath *)indexPath {
    syLog(@"%@",_gifUrl);
    if ([_gifModel isEqualToString:@"1"]) {
        cell.gifImageView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.618);
    } else {

        cell.gifImageView.frame = CGRectMake(0, 0, kSCREEN_WIDTH * 0.618 * 0.618, kSCREEN_WIDTH * 0.618);

        cell.gifImageView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_WIDTH * 0.618 / 2);
    }

    NSString *states = [self getNetWorkStates];

    if ([states isEqualToString:@"wifi"]) {
        NSString *imagePath = [NSString stringWithFormat:IMAGEURL,_gifUrl];
        //先从缓存中找 GIF 图,如果有就加载,没有就请求
        NSString *path = [[[SDWebImageManager sharedManager] imageCache] defaultCachePathForKey:[imagePath stringByAppendingString:@"gif"]];
        NSData *gifImageData = [NSData dataWithContentsOfFile:path];
        if (gifImageData) {
            cell.gifImageView.image = [UIImage imageWithData:gifImageData];
        } else {
            cell.gifImageView.image = nil;
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,_gifUrl]] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {

                cell.gifImageView.image = image;
                //缓存 gif 图
                NSString *imagePath = [NSString stringWithFormat:IMAGEURL,_gifUrl];

                [[[SDWebImageManager sharedManager] imageCache] storeImageDataToDisk:data forKey:[imagePath stringByAppendingString:@"gif"]];
            }];

        }


        cell.gifImageView.animatedImage = nil;

    } else {

        NSString *imagePath = [NSString stringWithFormat:IMAGEURL,_gifUrl];

        //先从缓存中找 GIF 图,如果有就加载,没有就请求
        NSString *path = [[[SDWebImageManager sharedManager] imageCache] defaultCachePathForKey:[imagePath stringByAppendingString:@"gif"]];
        NSData *gifImageData = [NSData dataWithContentsOfFile:path];

        if (gifImageData) {
            cell.gifImageView.image = [UIImage imageWithData:gifImageData];
        } else {
            [cell.gifImageView sd_setImageWithURL:nil];
        }
            cell.gifImageView.animatedImage = nil;
        }

        cell.isLoadGif = NO;
        if (cell.isLoadGif) {

        } else {
            if (!_gifModel || [_gifModel isEqualToString:@"0"]) {
                [cell.label removeFromSuperview];
            } else {
                [cell.contentView addSubview:cell.label];
            }

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label.text = @"GIF";
}

/** vip cell */
- (void)setVipCell:(FFGameDetailTableViewCell *)cell IndexPath:(NSIndexPath *)indexPath {
    cell.detail.text = self.vip;
    cell.detail.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, ((NSNumber *)_rowHeightArray[indexPath.section]).floatValue);
    cell.isOpen = NO;
    cell.tag = 10086;
    if (cell.isOpen) {
        cell.detail.lineBreakMode = NSLineBreakByWordWrapping;
    } else {
        cell.detail.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
}

/** like cell */
- (void)setLikeCell:(FFClassifyTableCell *)cell IndexPath:(NSIndexPath *)indexPath {
    cell.array = self.likes;
//    cell.delegate = self;
}

/** comment cell */
- (void)setCommentCell:(FFGameCommentCell *)cell IndePath:(NSIndexPath *)indexPath {
    cell.userNick = _commentArray[indexPath.row][@"passport"][@"nickname"];
    cell.contentStr = _commentArray[indexPath.row][@"content"];
    NSMutableString *time = [NSMutableString stringWithFormat:@"%@",_commentArray[indexPath.row][@"create_time"]];
    time = [[time substringToIndex:time.length - 3] mutableCopy];
    NSDate *creatDate = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    cell.time = [formatter stringFromDate:creatDate];
}


#pragma mark - tableViewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        FFGameGifTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.isLoadGif) {
        } else {
            cell.gifUrl = _gifUrl;
            cell.isLoadGif = YES;
        }
    }

    if (indexPath.section < 4 && indexPath.section != 2) {

        FFGameDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        [tableView beginUpdates];

        if (_lastCell) {
//            if (cell.tag == _lastCell.tag) {
//                cell.isOpen = !cell.isOpen;
//            } else {
//                _lastCell.isOpen = NO;
//                cell.isOpen = YES;
//                _lastCell = cell;
//            }

            if (cell == _lastCell) {
                if (cell.isOpen) {
                    cell.isOpen = NO;
                    _lastCell = nil;
                } else {
                    cell.isOpen = YES;
                    _lastCell = cell;
                }
            } else {
                _lastCell.isOpen = NO;
                cell.isOpen = YES;
                _lastCell = cell;
            }
        } else {
            cell.isOpen = YES;
            _lastCell = cell;
        }
        
        if (cell.isOpen) {
            cell.detail.lineBreakMode = NSLineBreakByWordWrapping;
        } else {
            cell.detail.lineBreakMode = NSLineBreakByTruncatingMiddle;
        }

        [tableView endUpdates];
    }

    if (indexPath.section == 5) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        FFReplyToCommentController *replyController = [[FFReplyToCommentController alloc] init];
        NSMutableDictionary *dict = [_commentArray[indexPath.row] mutableCopy];
        [dict setObject:self.topic_id forKey:@"topic_id"];
        replyController.commentDict = dict;
        HIDE_TABBAR;
        HIDE_PARNENT_TABBAR;
        [self.navigationController pushViewController:replyController animated:YES];
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        switch (_gifModel.integerValue) {
            case 0:
                return 0;
            default:
                return kSCREEN_WIDTH * 0.618;
        }
    } else if (indexPath.section == 4) {
        return 100;
    } else if (indexPath.section == 5) {
        return 80;
    } else {
        FFGameDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.isOpen) {
            return ((NSNumber *)_rowHeightArray[indexPath.section]).floatValue;
        } else {
            return 100;
        }
    }

//    switch (indexPath.section) {
//        case 0:
//        case 1: {
//            FFGameDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            if (cell.isOpen) {
//                return ((NSNumber *)_rowHeightArray[indexPath.section]).floatValue;
//            } else {
//                return 100;
//            }
//        }
//        case 3:
//            return 200;
//        case 2: {
//            if (_gifModel.integerValue == 0) {
//                return 0;
//            } else {
//                return kSCREEN_WIDTH * 0.618;
//            }
//        }
//        case 4:
//            return 100;
//        default:
//            return 80;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        switch (_gifModel.integerValue) {
            case 0:
                return 0;
            default:
                return 30;
        }
    } else {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, kSCREEN_WIDTH, 28)];
    label.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    if (section < 4) {

        label.text = self.sectionTitleArray[section];
    } else {
        label.text = [NSString stringWithFormat:@"%@",self.sectionTitleArray[section]];
    }
    [view addSubview:label];
    return view;
}

#pragma mark - setter
- (void)setGameID:(NSString *)gameID {
    _gameID = gameID;
    [self goToTop];
}

- (void)setGameContent:(NSDictionary *)gameContent {
    if (_gameContent != gameContent) {
        _gameContent = gameContent;
        self.gameInfo = gameContent[@"gameinfo"];
        self.likes = gameContent[@"like"];
    }

    syLog(@"game Content === %@",gameContent);
}

- (void)setGameInfo:(NSDictionary *)gameInfo {
    if (_gameInfo != gameInfo) {
        _gameInfo = gameInfo;
        syLog(@"game detail view game info \n =======================================================\n %@",_gameInfo);
        self.imagasArray = gameInfo[@"imgs"];
        self.abstract = gameInfo[@"abstract"];
        self.feature = gameInfo[@"feature"];
        self.gifModel = gameInfo[@"gif_model"];
        self.rebate = gameInfo[@"rebate"];
        self.vip = gameInfo[@"vip"];
        self.gifUrl = gameInfo[@"gif"];
    }
}

//游戏展示的5张图片
- (void)setImagasArray:(NSArray *)imagasArray {
    _imagasArray = imagasArray;
    self.tableHeaderView.imageArray = imagasArray;
}

- (void)setLikes:(NSArray *)likes {
    _likes = likes;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    syLog(@"game ditct");
    [self.tableView reloadData];
}

/** 计算字符串需要的尺寸 */
- (CGSize)sizeForString:(NSString *)string Width:(CGFloat)width Height:(CGFloat)height {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize retSize = [string boundingRectWithSize:CGSizeMake(width, height)
                                          options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    return retSize;
}

//游戏简介
- (void)setAbstract:(NSString *)abstract {
    NSMutableString *str = [abstract mutableCopy];
    NSString *last = [str substringFromIndex:str.length - 1];
    while ([last isEqualToString:@"\n"]) {
        str = [[str substringToIndex:str.length - 1] mutableCopy];
        last = [str substringFromIndex:str.length - 1];
    }
    CGSize size = [self sizeForString:str Width:kSCREEN_WIDTH Height:MAXFLOAT];
    if ((size.height + 10.f) > 100.f) {
        [_rowHeightArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:(size.height + 30.f)]];
    } else {
        [_rowHeightArray replaceObjectAtIndex:0 withObject:@100.f];
    }
    _abstract = str;
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
    [self.tableView reloadData];
}

//游戏特征
- (void)setFeature:(NSString *)feature {
    NSMutableString *str = [feature mutableCopy];
    CGSize size = [self sizeForString:str Width:kSCREEN_WIDTH Height:MAXFLOAT];
    if ((size.height + 10.f) > 100.f) {
        [_rowHeightArray replaceObjectAtIndex:1 withObject:[NSNumber numberWithFloat:(size.height + 30.f)]];
    } else {
        [_rowHeightArray replaceObjectAtIndex:1 withObject:@100.f];
    }
    _feature = str;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:(UITableViewRowAnimationNone)];
}

//游戏返利
- (void)setRebate:(NSString *)rebate {
    NSMutableString *str = [rebate mutableCopy];
    if (str.length != 0) {
        NSString *last = [str substringFromIndex:str.length - 1];
        while ([last isEqualToString:@"\n"]) {
            str = [[str substringToIndex:str.length - 1] mutableCopy];
            last = [str substringFromIndex:str.length - 1];
        }
    }
    CGSize size = [self sizeForString:str Width:kSCREEN_WIDTH Height:MAXFLOAT];
    if ((size.height + 10.f) > 100.f) {
        [_rowHeightArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithFloat:(size.height + 30.f)]];
    } else {
        [_rowHeightArray replaceObjectAtIndex:2 withObject:@100.f];
    }
    _rebate = str;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:(UITableViewRowAnimationNone)];
}

//gifUrl
- (void)setGifUrl:(NSString *)gifUrl {
    _gifUrl = gifUrl;
    //    GifTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    //
    //    cell.isLoadGif = NO;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:(UITableViewRowAnimationNone)];
}

//gifModel
- (void)setGifModel:(NSString *)gifModel {
    _gifModel = gifModel;
    //    syLog(@"%@",_gifUrl);
    //
    //    GifTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    //
    //    cell.isLoadGif = NO;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:(UITableViewRowAnimationNone)];
}

// vip
- (void)setVip:(NSString *)vip {
    NSMutableString *str = [vip mutableCopy];
    CGSize size = [self sizeForString:str Width:kSCREEN_WIDTH Height:MAXFLOAT];
    if ((size.height + 10.f) > 100.f) {
        [_rowHeightArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithFloat:(size.height + 30.f)]];
    } else {
        [_rowHeightArray replaceObjectAtIndex:3 withObject:@100.f];
    }
    _vip = str;
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:(UITableViewRowAnimationNone)];
    [self.tableView reloadData];
}

//评论
- (void)setCommentArray:(NSArray *)commentArray {
    _commentArray = commentArray;

//    syLog(@"comment ===== %@",commentArray);
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:_sectionTitleArray.count - 1] withRowAnimation:(UITableViewRowAnimationNone)];
}




#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 245) style:(UITableViewStylePlain)];

        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.tableFooterView = self.footerView;
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDE_GAMEDETAIL bundle:nil] forCellReuseIdentifier:CELL_IDE_GAMEDETAIL];
        [_tableView registerClass:[FFGameGifTableViewCell class] forCellReuseIdentifier:CELL_IDE_GAMEGIF];
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDE_CLASSIFY bundle:nil] forCellReuseIdentifier:CELL_IDE_CLASSIFY];
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDE_COMMENT bundle:nil] forCellReuseIdentifier:CELL_IDE_COMMENT];

        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.estimatedRowHeight = 100;
        _tableView.autoresizesSubviews = YES;

        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }

    return _tableView;
}


- (FFGameDetailTableHeader *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[FFGameDetailTableHeader alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300)];
    }
    return _tableHeaderView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH,46)];

        _footerView.backgroundColor = RGBCOLOR(247, 247, 247);

        //响应事件
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(0, 1, kSCREEN_WIDTH, 44);
        [button setTitle:@"点击查看更多评论>" forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

        [button addTarget:self action:@selector(respondsToMoreCommentBtn) forControlEvents:(UIControlEventTouchUpInside)];
        button.backgroundColor = [UIColor whiteColor];

        [_footerView addSubview:button];

    }
    return _footerView;
}

- (FFCommentListController *)commentListController {
    if (!_commentListController) {
        _commentListController = [[FFCommentListController alloc] init];
    }
    return _commentListController;
}


- (NSString *)getNetWorkStates {
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
//    NSString *state = [[NSString alloc]init];
//    int netType = 0;
//    //获取到网络返回码
//    for (id child in children) {
//        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
//            //获取到状态栏
//            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
//
//            switch (netType) {
//                case 0:
//                    state = @"无网络";
//                    //无网模式
//                    break;
//                case 1:
//                    state =  @"2G";
//                    break;
//                case 2:
//                    state =  @"3G";
//                    break;
//                case 3:
//                    state =   @"4G";
//                    break;
//                case 5:
//                {
//                    state =  @"wifi";
//                    break;
//                default:
//                    break;
//                }
//            }
//        }
//        //根据状态选择
//    }
//    return state;

    NSString *stateString = nil;
    int netStatusNumber = 0;
    switch ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {

        case NotReachable: {

            stateString = @"无网络";
            netStatusNumber = 0;
        }
            break;

        case ReachableViaWiFi: {

            stateString = @"wifi";
            netStatusNumber = 1;
        }
            break;

        default: {

            stateString = @"不可识别的网络";
            netStatusNumber = -1;
        }
            break;
    }
    return stateString;
}

@end



