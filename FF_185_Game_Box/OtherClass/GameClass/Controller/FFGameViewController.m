//
//  FFGameViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFGameViewController.h"
#import "FFGameModel.h"

#import "FFGameHeaderView.h"
#import "FFGameFooterView.h"

#import "FFGameDetailViewController.h"
#import "FFGameRaidersViewController.h"
#import "FFGamePackageViewController.h"
#import "FFGameServiceViewController.h"
#import "FFCommentListController.h"

#import "FFWriteCommentController.h"
#import "FFLoginViewController.h"
#import "FFSharedController.h"


#import "ChangyanSDK.h"

@interface FFGameViewController ()<FFGameHeaderViewDelegate, FFGameFooterViewDelegate, UIScrollViewDelegate>

/** header view */
@property (nonatomic, strong) FFGameHeaderView *headerView;
/** footer view */
@property (nonatomic, strong) FFGameFooterView *footerView;
/** scroll view */
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isAnimation;

@property (nonatomic, strong) FFGameDetailViewController *gDetailViewController;
@property (nonatomic, strong) FFGameRaidersViewController *gRaidersViewController;
@property (nonatomic, strong) FFGamePackageViewController *gPackageViewController;
@property (nonatomic, strong) FFGameServiceViewController *gServiceViewController;
@property (nonatomic, strong) FFCommentListController *commentListController;
@property (nonatomic, strong) NSArray<UIViewController *> *gChildControllers;
@property (nonatomic, strong) UIViewController *lastController;

@property (nonatomic, strong) FFWriteCommentController *writeComment;

@property (nonatomic, strong) NSDictionary *gameinfo;

@end


static FFGameViewController *controller = nil;

@implementation FFGameViewController

+ (instancetype)sharedController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[FFGameViewController alloc] init];
    });
    return controller;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setSubviewFrame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
    [self initDataSource];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"游戏详情";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我要评论" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightButton)];

    /** footer view */
    [self.view addSubview:self.headerView];
    /** scroll view */
    [self.view addSubview:self.scrollView];
    /** footer view */
    [self.view addSubview:self.footerView];
}

- (void)initDataSource {
    _gChildControllers = [@[self.gDetailViewController,self.commentListController,self.gPackageViewController,self.gServiceViewController] copy];




    [self addChildViewController:_gChildControllers[0]];
    [self.scrollView addSubview:_gChildControllers[0].view];
    [_gChildControllers[0] didMoveToParentViewController:self];
}

#pragma mark - responds
- (void)respondsToRightButton {
    HIDE_TABBAR;
    if (SSKEYCHAIN_UID) {
        [self.navigationController pushViewController:self.writeComment animated:YES];
        return;
    } else {
        [self.navigationController pushViewController:[FFLoginViewController new] animated:YES];
    }
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    //设置选择视图的浮标
    [self.headerView.selectView reomveLabelWithX:(x / scrollView.contentSize.width * kSCREEN_WIDTH)];

    CGFloat index = x / kSCREEN_WIDTH;
    NSInteger afterIndex = index * 10000;
    NSInteger i = afterIndex / 10000;
    NSInteger other = afterIndex % 10000;

    if (i < _gChildControllers.count - 1 && other != 0) {
        [self hAddChildViewController:_gChildControllers[i]];
        [self hAddChildViewController:_gChildControllers[i + 1]];
    } else if (other == 0) {
        if (i > 0) {
            [self hChildControllerRemove:_gChildControllers[i - 1]];
            if (i != _gChildControllers.count - 1) {
                [self hChildControllerRemove:_gChildControllers[i + 1]];
            }
        } else {
            [self hAddChildViewController:_gChildControllers[0]];
            [self hChildControllerRemove:_gChildControllers[i + 1]];
        }
    }

    NSArray *array = self.childViewControllers;
    if (array.count == 1) {
        self.lastController = array[0];
    } else {
        self.lastController = nil;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.headerView.selectView.userInteractionEnabled = NO;
    _isAnimation = YES;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.headerView.selectView.userInteractionEnabled = YES;
    _isAnimation = NO;
}

- (void)hAddChildViewController:(UIViewController *)controller {
    [self addChildViewController:controller];
    [self.scrollView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

- (void)hChildControllerRemove:(UIViewController *)controller {
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}


#pragma mark - header view delegate
- (void)FFGameHeaderView:(FFGameHeaderView *)view didselectBtnAtIndex:(NSInteger)idx {

    if (_isAnimation || self.lastController == _gChildControllers[idx]) {
        return;
    }

    if (self.lastController != nil) {
        [self hAddChildViewController:_gChildControllers[idx]];
        [self hChildControllerRemove:self.lastController];
    } else {
        [self hAddChildViewController:_gChildControllers[idx]];
    }

    self.lastController = _gChildControllers[idx];

//
//    if (i < _gChildControllers.count - 1 && other != 0) {
//        [self hAddChildViewController:_gChildControllers[i]];
//        [self hAddChildViewController:_gChildControllers[i + 1]];
//    } else if (other == 0) {
//        if (i > 0) {
//            [self hChildControllerRemove:_gChildControllers[i - 1]];
//            if (i != _gChildControllers.count - 1) {
//                [self hChildControllerRemove:_gChildControllers[i + 1]];
//            }
//        } else {
//            [self hAddChildViewController:_gChildControllers[0]];
//            [self hChildControllerRemove:_gChildControllers[i + 1]];
//        }
//    }

//    NSArray *array = self.childViewControllers;
//    if (array.count == 1) {
//        self.lastController = array[0];
//    } else {
//        self.lastController = nil;
//    }

    [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * idx, 0) animated:NO];
}

#pragma mark - footer view delegate
- (void)FFGameFooterView:(FFGameFooterView *)detailFooter clickShareBtn:(UIButton *)sender {
    syLog(@"shared game ===== %@",self.gameinfo);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.gameLogo forKey:@"image"];
    [dict setObject:self.gameName forKey:@"title"];
    [dict setObject:[NSString stringWithFormat:@"http://m.185sy.com/Game-appGameinfo-id-%@.html",self.gameID] forKey:@"url"];
    [FFSharedController sharedGameWith:dict];
}

- (void)FFGameFooterView:(FFGameFooterView *)detailFooter clickDownLoadBtn:(UIButton *)sender {
    syLog(@"download game ===== %@",self.gameinfo);

    if ([Channel isEqualToString:@"185"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.gameinfo[@"ios_url"]]];
    } else {
        [FFGameModel gameDownloadWithTag:self.gameinfo[@"tag"] Comoletion:^(NSDictionary *content, BOOL success) {
            NSString *url = content[@"data"][@"download_url"];
            syLog(@"downLoadUrl == %@",url);
            ([url isKindOfClass:[NSString class]]) ? ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]) : (BOX_MESSAGE(@"链接出错,请稍后尝试"));

        }];
    }

    [FFStatisticsModel customEventsWith:@"down_laod_game" Extra:@{@"game_name":self.gameinfo[@"gamename"],@"game_id":self.gameinfo[@"id"]}];
}

- (void)FFGameFooterView:(FFGameFooterView *)detailFooter clickCollecBtn:(UIButton *)sender {
    if (SSKEYCHAIN_USER_NAME == nil || SSKEYCHAIN_UID == nil) {
        BOX_MESSAGE(@"尚未登录");
        return;
    }
    if (self.gameinfo && _gameinfo[@"collect"]) {
        BOOL isCollect = self.footerView.isCollection;
        if (isCollect) {
            [FFGameModel gameCollectWithType:@"2" GameID:self.gameID Comoletion:^(NSDictionary *content, BOOL success) {
                //取消收藏
                if (success) {
                    self.footerView.isCollection = NO;
//                    syLog(@"collection  === %@",content);
                } else {
                    BOX_MESSAGE(content[@"msg"]);
                }
            }];
        } else {
            [FFGameModel gameCollectWithType:@"1" GameID:self.gameID Comoletion:^(NSDictionary *content, BOOL success) {
                //取消收藏
                if (success) {
                    self.footerView.isCollection = YES;
//                    syLog(@"collection  === %@",content);
                } else {
                    BOX_MESSAGE(content[@"msg"]);
                }
            }];
        }
    }
    syLog(@"收藏");
}


#pragma mark - setter
- (void)setGameID:(NSString *)gameID {
    syLog(@"game view controller game id === %@",gameID);
    [self.gDetailViewController goToTop];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];

    if ([_gameID isEqualToString:gameID]) {
//        if (_gameinfo == nil || _gameinfo.count == 0) {
//            BOX_MESSAGE(@"加载失败");
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        return;
    } else {
        _gameID = gameID;
    }

    self.gServiceViewController.gameID = gameID;
    self.gPackageViewController.gameID = gameID;
    self.gRaidersViewController.gameID = gameID;
    self.commentListController.gameID = _gameID;

    syLog(@"new game ");
    BOX_START_ANIMATION;
    [FFGameModel gameInfoWithGameID:gameID Comoletion:^(NSDictionary *content, BOOL success) {
//        BOX_START_ANIMATION;



        if (success) {
            NSDictionary *dict = content[@"data"];
            self.gameinfo = dict[@"gameinfo"];
            self.headerView.gameInfo = dict[@"gameinfo"];
            self.gDetailViewController.gameContent = dict;
            //设置游戏名称
            [self setGameName:dict[@"gameinfo"][@"gamename"]];

        } else {
            [self.navigationController popViewControllerAnimated:YES];
            BOX_MESSAGE(@"加载失败");
        }
        BOX_STOP_ANIMATION;

    }];

    //获取评论
    [self getGameComments];
    //获取评论数
    [self getGameCommentsNumber];
}

/** 设置 logo */
- (void)setGameInfoLogo:(NSString *)url {
    syLog(@"game info logo url === %@",url);

    [[[SDWebImageManager sharedManager] imageDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,url]] options:(SDWebImageDownloaderHighPriority) progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (finished) {
            self.gameLogo = image;
        }
    }];
}

/** 获取游戏评论 */
- (void)getGameComments {
    //获取游戏评论
    [ChangyanSDK loadTopic:@"" topicTitle:nil topicSourceID:[NSString stringWithFormat:@"game_%@",_gameID] pageSize:@"3" hotSize:nil orderBy:nil style:nil depth:nil subSize:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {

        if (statusCode == 0) {
            NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            self.gDetailViewController.commentArray = dic[@"comments"];
            self.gDetailViewController.gameID = _gameID;
            self.gDetailViewController.topic_id = dic[@"topic_id"];
            self.writeComment.gameName = dic[@"topic_id"];

        } else {

        }
    }];
}

/** 获取评论数目 */
- (void)getGameCommentsNumber {
    [ChangyanSDK getCommentCount:@"" topicSourceID:[NSString stringWithFormat:@"game_%@",_gameID] topicUrl:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {

            if (statusCode == 0) {
                syLog(@"game comment number === %@", responseStr);
                NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];

                if (dic != nil) {
                    NSString *pinglun = nil;
                    id dict1 = dic[@"result"];
                    id dict2 = [dict1 allValues][0];
                    if ([dict2 isKindOfClass:[NSDictionary class]]) {
                        pinglun = [NSString stringWithFormat:@"评论(%@)",dict2[@"comments"]];
                        syLog(@"????????????????????????????????????????????????");
                    } else {
                        pinglun = @"评论";
                    }
                    syLog(@"game comment numbe dict === %@",dic);
                    self.headerView.selectView.btnNameArray = @[@"详情",pinglun,@"礼包",@"开服"];
                }

            } else {

            }
    }];
}

- (void)setGameinfo:(NSDictionary *)gameinfo {
    _gameinfo = gameinfo;
    self.footerView.isCollection = ((NSString *)gameinfo[@"collect"]).boolValue;
    [self setGameInfoLogo:_gameinfo[@"logo"]];
}

/** 设置游戏图标 */
- (void)setGameLogo:(UIImage *)gameLogo {
   syLog(@"game view controller game logo === %@",gameLogo);
    if (gameLogo == nil || gameLogo == _gameLogo) {
//        return;
    } else {
        _gameLogo = gameLogo;
        self.headerView.gameLogo.image = gameLogo;
        self.gServiceViewController.gameLogo = gameLogo;
        self.gPackageViewController.gameLogo = gameLogo;
        self.gRaidersViewController.gameLogo = gameLogo;
    }
}

/** 设置游戏名称 */
- (void)setGameName:(NSString *)gameName {
    _gameName = gameName;
    self.headerView.gameNameLabel.text = gameName;
    self.gServiceViewController.gameName = gameName;
    self.gPackageViewController.gameName = gameName;
    self.gRaidersViewController.gameName = gameName;
}

#pragma mark - set frame
- (void)setSubviewFrame {
    self.headerView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 124);
    self.footerView.frame = CGRectMake(0, kSCREEN_HEIGHT - 50, kSCREEN_WIDTH, 50);

    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame) + 7, kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.headerView.frame) - self.footerView.bounds.size.height - 7);

    [self.scrollView setContentSize:CGSizeMake(kSCREEN_WIDTH * self.gChildControllers.count, self.scrollView.frame.size.height)];

    self.gDetailViewController.view.frame = self.scrollView.bounds;
//    self.gRaidersViewController.view.frame = CGRectMake(kSCREEN_WIDTH, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
    self.commentListController.view.frame = CGRectMake(kSCREEN_WIDTH, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
    self.commentListController.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
    self.gPackageViewController.view.frame = CGRectMake(kSCREEN_WIDTH * 2, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
    self.gServiceViewController.view.frame = CGRectMake(kSCREEN_WIDTH * 3, 0, kSCREEN_WIDTH, self.scrollView.frame.size.height);
}


#pragma mark - getter
- (FFGameHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFGameHeaderView alloc] init];
        _headerView.layer.shadowColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
        _headerView.layer.shadowOpacity = 1.f;
        _headerView.layer.shadowRadius = 5.f;
        _headerView.layer.shadowOffset = CGSizeMake(0, 5);
        _headerView.delegate = self;
    }
    return _headerView;
}

- (FFGameFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[FFGameFooterView alloc]init];
        _footerView.delegate = self;
    }
    return _footerView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (FFGameDetailViewController *)gDetailViewController {
    if (!_gDetailViewController) {
        _gDetailViewController = [[FFGameDetailViewController alloc] init];
    }
    return _gDetailViewController;
}

- (FFGameRaidersViewController *)gRaidersViewController {
    if (!_gRaidersViewController) {
        _gRaidersViewController = [[FFGameRaidersViewController alloc] init];
    }
    return _gRaidersViewController;
}

- (FFGamePackageViewController *)gPackageViewController {
    if (!_gPackageViewController) {
        _gPackageViewController = [[FFGamePackageViewController alloc] init];
    }
    return _gPackageViewController;
}

- (FFGameServiceViewController *)gServiceViewController {
    if (!_gServiceViewController) {
        _gServiceViewController = [[FFGameServiceViewController alloc] init];
    }
    return _gServiceViewController;
}

- (FFWriteCommentController *)writeComment {
    if (!_writeComment) {
        _writeComment = [[FFWriteCommentController alloc] init];
    }
    return _writeComment;
}

- (FFCommentListController *)commentListController {
    if (!_commentListController) {
        _commentListController = [[FFCommentListController alloc] init];
    }
    return _commentListController;
}


@end







