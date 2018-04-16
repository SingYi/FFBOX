//
//  FFGameDetailViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFGameDetailViewController.h"
#import "FFGameViewController.h"

#import "FFGameDetailTableHeader.h"

#import "UIImageView+WebCache.h"

#import "FFGameDetailTableViewCell.h"
#import "FFGameGifTableViewCell.h"
#import "FFClassifyTableCell.h"
#import "FFGameCommentCell.h"
#import "FFWebViewController.h"

#import "FFCommentListController.h"
#import "FFReplyToCommentController.h"

#import "Reachability.h"

#import "FFGameModel.h"

#import "FFDetailSectionHeader.h"

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


typedef enum : NSUInteger {
    GameIntroductionCell = 0,
    GameFeaturesCell,
    ExclusiveEvent,
    GameGifCell,
    GameVipCell,
    UserLike
} DetailCellIndex;


typedef enum : NSUInteger {
    SectionModel1 = 0,
    SectionModel2
} SectionModel;



@interface FFGameDetailViewController () <UITableViewDelegate, UITableViewDataSource, FFClassifyTableCellDelegate>

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

@property (nonatomic, strong) NSMutableArray<UIView *> *sectionHeaderArray;

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


@property (nonatomic, strong) NSArray *sectionDict;
@property (nonatomic, strong) NSArray *sectionRowHight;
@property (nonatomic, assign) SectionModel sectionModel;

@end

@implementation FFGameDetailViewController {
    NSDictionary *_gameAvtivity;
}

- (NSArray *)sectionDict {
    if (!_sectionDict) {
        _sectionDict = @[@[@"    游戏简介:",@"    游戏特征:",@"    精彩时刻:",@"     VIP价格:",@"    猜你喜欢:"],
                         @[@"    游戏简介:",@"    游戏特征:",@"    独家活动:",@"    精彩时刻:",@"     VIP价格:",@"    猜你喜欢:"]];
    }
    return _sectionDict;
}

- (NSArray *)sectionRowHight {
    if (!_sectionRowHight) {
        _sectionRowHight = @[@[@100.f,@100.f,@100.f,@100.f],
                             @[@100.f,@100.f,@44.f,@100.f,@120.f]];
    }
    return _sectionRowHight;
}

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

     self.sectionModel = SectionModel1;


    //游戏活动回调
    [CURRENT_GAME setActivityCallBackBlock:^(NSDictionary *content, BOOL success) {
        syLog(@"游戏活动 == %@",content);
        NSArray *array = content[@"data"][@"list"];
        if (success && ![array isKindOfClass:[NSNull class]]) {
            _gameAvtivity = array.firstObject;
            self.sectionModel = SectionModel2;
            [self setActivityCell];
        }
    }];

}



- (void)goToTop {
    [self.tableView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark - responds

#pragma mark - tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFGameDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE_GAMEDETAIL];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    switch (indexPath.section) {
        case GameIntroductionCell:
            [self setAbstractCell:cell IndexPath:indexPath];
            return cell;
        case GameFeaturesCell: {
            [self setFeatureCell:cell IndexPath:indexPath];
            return cell;
        }
        case ExclusiveEvent: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExclusiveEventCell" forIndexPath:indexPath];
            cell.textLabel.text = _gameAvtivity[@"title"];

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        case GameGifCell: {
            FFGameGifTableViewCell *gifCell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE_GAMEGIF];
            [self setGifCell:gifCell IndexPath:indexPath];
            return gifCell;
        }
        case GameVipCell: {
            [self setVipCell:cell IndexPath:indexPath];
            return cell;
        }
        case UserLike: {
            FFClassifyTableCell *likeCell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE_CLASSIFY];
            likeCell.delegate = self;
            [self setLikeCell:likeCell IndexPath:indexPath];
            return likeCell;
        }
        default: {
            return nil;
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

#pragma mark  delegate
- (void)FFClassifyTableCell:(FFClassifyTableCell *)cell clickGame:(NSDictionary *)dict {
    syLog(@"classify cell == =%@", dict);
    NSString *gameID = [NSString stringWithFormat:@"%@",dict[@"id"]];
    [[FFGameViewController sharedController] setGameID:gameID];
}



#pragma mark - tableViewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.section) {
        case GameGifCell: {
            FFGameGifTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell.isLoadGif) {
                cell.gifUrl = _gifUrl;
                cell.isLoadGif = YES;
            }
            break;
        }
        case ExclusiveEvent: {
            [self showEventDetail];
            break;
        }
        case GameIntroductionCell:
        case GameFeaturesCell:
        case GameVipCell: {
            [self openOrCloseCellWithIndexPath:indexPath];
            break;
        }
        case UserLike: {

            break;
        }
        default:
            break;
    }
}

- (void)openOrCloseCellWithIndexPath:(NSIndexPath *)indexPath {
    FFGameDetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self.tableView beginUpdates];
    if (_lastCell) {
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
    if (indexPath.section == GameGifCell && cell.isOpen) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height)];
    }
    [self.tableView endUpdates];
}

- (void)setActivityCell {
    NSMutableString *str = [_gameAvtivity[@"title"] mutableCopy];
    if (str.length > 0) {
        [_rowHeightArray replaceObjectAtIndex:ExclusiveEvent withObject:@44.f];
    } else {
        [_rowHeightArray replaceObjectAtIndex:ExclusiveEvent withObject:@0.f];
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:ExclusiveEvent]] withRowAnimation:(UITableViewRowAnimationNone)];
}

- (void)showEventDetail {
    NSString *url = _gameAvtivity[@"info_url"];
    FFWebViewController *webVC = [FFWebViewController new];
    webVC.webURL = url;
    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:webVC animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case ExclusiveEvent: {
            return (_gameAvtivity[@"title"] != nil) ? 66 : 0;
        }
        case GameGifCell: {
            return ((_gifModel.integerValue == 0) ? 0: kSCREEN_WIDTH * 0.618);
        }
        case UserLike: {
            return  100;
        }
        default: {
            FFGameDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell.isOpen) {
                return ((NSNumber *)_rowHeightArray[indexPath.section]).floatValue;
            } else {
                return 100;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2 && _gifModel.integerValue == 0) {
        return 0;
    } else {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sectionHeaderArray[section];
}

#pragma mark - setter
- (void)setGameID:(NSString *)gameID {
    _gameID = gameID;
    self.sectionModel = SectionModel1;
    [self goToTop];
}

- (void)setSectionModel:(SectionModel)sectionModel {
    _sectionModel = sectionModel;
    _sectionTitleArray = self.sectionDict[1];
    _rowHeightArray = [self.sectionRowHight[1] mutableCopy];

    _sectionHeaderArray = [NSMutableArray arrayWithCapacity:_sectionTitleArray.count];
    [_sectionTitleArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
        view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, kSCREEN_WIDTH, 28)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = obj;
        [view addSubview:label];
        [_sectionHeaderArray addObject:view];
    }];

    [self.tableView reloadData];
}

- (void)setUserInterFace {
    self.imagasArray    = CURRENT_GAME.showImageArray;
    self.abstract       = CURRENT_GAME.game_introduction;
    self.feature        = CURRENT_GAME.game_feature;
    self.gifModel       = CURRENT_GAME.gif_model;
    self.rebate         = CURRENT_GAME.game_rebate;
    self.vip            = CURRENT_GAME.game_vip_amount;
    self.gifUrl         = CURRENT_GAME.gif_url;
    self.likes          = CURRENT_GAME.like;
}

- (void)setGameContent:(NSDictionary *)gameContent {
    if (_gameContent != gameContent) {
        _gameContent = gameContent;
        self.gameInfo = gameContent[@"gameinfo"];
        self.likes = gameContent[@"like"];
    }

    syLog(@"game Content === %@",gameContent);
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
        [_rowHeightArray replaceObjectAtIndex:GameIntroductionCell withObject:[NSNumber numberWithFloat:(size.height + 30.f)]];
    } else {
        [_rowHeightArray replaceObjectAtIndex:GameIntroductionCell withObject:@100.f];
    }
    _abstract = str;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:GameIntroductionCell]] withRowAnimation:(UITableViewRowAnimationNone)];
}

//游戏特征
- (void)setFeature:(NSString *)feature {
    NSMutableString *str = [feature mutableCopy];
    CGSize size = [self sizeForString:str Width:kSCREEN_WIDTH Height:MAXFLOAT];
    if ((size.height + 10.f) > 100.f) {
        [_rowHeightArray replaceObjectAtIndex:GameFeaturesCell withObject:[NSNumber numberWithFloat:(size.height + 30.f)]];
    } else {
        [_rowHeightArray replaceObjectAtIndex:GameFeaturesCell withObject:@100.f];
    }
    _feature = str;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:GameFeaturesCell]] withRowAnimation:(UITableViewRowAnimationNone)];
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
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:GameGifCell]] withRowAnimation:(UITableViewRowAnimationNone)];
}

//gifModel
- (void)setGifModel:(NSString *)gifModel {
    _gifModel = gifModel;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:GameGifCell]] withRowAnimation:(UITableViewRowAnimationNone)];
}

// vip
- (void)setVip:(NSString *)vip {
    NSMutableString *str = [vip mutableCopy];
    CGSize size = [self sizeForString:str Width:kSCREEN_WIDTH Height:MAXFLOAT];
    if ((size.height + 10.f) > 100.f) {
        [_rowHeightArray replaceObjectAtIndex:GameVipCell withObject:[NSNumber numberWithFloat:(size.height + 30.f)]];
    } else {
        [_rowHeightArray replaceObjectAtIndex:GameVipCell withObject:@100.f];
    }
    _vip = str;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:GameVipCell]] withRowAnimation:(UITableViewRowAnimationNone)];
}

//评论
- (void)setCommentArray:(NSArray *)commentArray {
    _commentArray = commentArray;
}




#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 245) style:(UITableViewStylePlain)];

        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDE_GAMEDETAIL bundle:nil] forCellReuseIdentifier:CELL_IDE_GAMEDETAIL];
        [_tableView registerClass:[FFGameGifTableViewCell class] forCellReuseIdentifier:CELL_IDE_GAMEGIF];
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDE_CLASSIFY bundle:nil] forCellReuseIdentifier:CELL_IDE_CLASSIFY];
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDE_COMMENT bundle:nil] forCellReuseIdentifier:CELL_IDE_COMMENT];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ExclusiveEventCell"];
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



