//
//  FFDriveController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/8.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveController.h"
#import "FFSelectHeaderView.h"
#import "FFDriveModel.h"

#import "FFDrivePostStatusViewController.h"
#import "UIAlertController+FFAlertController.h"
#import "UIButton+FFButton.h"
#import "FFDriveThroughInfoViewController.h"

#import "UINavigationController+Cloudox.h"
#import "UIViewController+Cloudox.h"


@interface FFDriveController ()<FFSelectHeaderViewDelegate,UIScrollViewDelegate>


@end

@implementation FFDriveController {
    UIViewController *lastController;
    BOOL _isAnimation;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = NAVGATION_BAR_COLOR;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.navigationItem.title = @"秋名山";

    [self addSubViews];
}

- (void)initDataSource {

    self.selectHeaderView.headerTitleArray = @[@"全部",@"热门",@"关注",@"我的"];
    [self setFchildControllerWithClassNames:@[@"FFDriveAllInfoViewController",
                                              @"FFDriveHotInfoViewController",
                                              @"FFDriveAttentionInfoViewController",
                                              @"UIViewController"]];
}

- (void)addSubViews {
    self.navigationItem.rightBarButtonItem = self.throughtBarbutton;
    [self.view addSubview:self.selectHeaderView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.postStatusButton];
    [self addChildViewController:self.fChildControllers[0]];
    [self.scrollView addSubview:self.self.fChildControllers[0].view];
}

#pragma mark - responds
- (void)respondsToThroughtButton {
    HIDE_TABBAR;
    [self.navigationController pushViewController:self.throughtViewController animated:YES];
    SHOW_TABBAR;
}

#pragma mark - select view delegate
- (void)FFSelectHeaderView:(FFSelectHeaderView *)view didSelectTitleWithIndex:(NSUInteger)idx {
    if (_isAnimation || lastController == self.fChildControllers[idx]) {
        return;
    }

    if (lastController != nil) {
        [self hAddChildViewController:self.fChildControllers[idx]];
        [self hChildControllerRemove:lastController];
    } else {
        [self hAddChildViewController:self.fChildControllers[idx]];
    }

    lastController = self.fChildControllers[idx];

    [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * idx, 0) animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    //设置选择视图的浮标
//    [self.selectHeaderView reomveLabelWithX:(x / scrollView.contentSize.width * kSCREEN_WIDTH)];
    [self.selectHeaderView setCursorX:(x / scrollView.contentSize.width * kSCREEN_WIDTH)];

    CGFloat index = x / kSCREEN_WIDTH;
    NSInteger afterIndex = index * 10000;
    NSInteger i = afterIndex / 10000;
    NSInteger other = afterIndex % 10000;

    if (i < self.fChildControllers.count - 1 && other != 0) {
        [self hAddChildViewController:self.fChildControllers[i]];
        [self hAddChildViewController:self.fChildControllers[i + 1]];
    } else if (other == 0) {
        if (i > 0) {
            [self hChildControllerRemove:self.fChildControllers[i - 1]];
            if (i != self.fChildControllers.count - 1) {
                [self hChildControllerRemove:self.fChildControllers[i + 1]];
            }
        } else {
            [self hAddChildViewController:self.fChildControllers[0]];
            [self hChildControllerRemove:self.fChildControllers[i + 1]];
        }
    }

    NSArray *array = self.childViewControllers;
    if (array.count == 1) {
        lastController = array[0];
    } else {
        lastController = nil;
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.selectHeaderView.userInteractionEnabled = NO;
    _isAnimation = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.selectHeaderView.userInteractionEnabled = YES;
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

#pragma mark - responds
- (void)respondsToPostStatusButton {
    syLog(@"发送状态");
    FFDrivePostStatusViewController *postStatusViewController = [[FFDrivePostStatusViewController alloc] init];
    HIDE_TABBAR;
    [self.navigationController pushViewController:postStatusViewController animated:YES];
    SHOW_TABBAR;
}


#pragma mark - set frame
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.selectHeaderView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 50);
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.selectHeaderView.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.selectHeaderView.frame) - CGRectGetHeight(self.tabBarController.tabBar.frame));

    if (self.fChildControllers.count > 0) {
        [self.fChildControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.view.frame = CGRectMake(idx * kSCREEN_WIDTH, 0, kSCREEN_WIDTH, self.scrollView.bounds.size.height);
        }];
        self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH * self.fChildControllers.count, self.scrollView.bounds.size.height);
    } else {
        self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, self.scrollView.bounds.size.height);
    }

}

- (void)setFchildControllerWithClassNames:(NSArray *)classNames {
    if (![classNames isKindOfClass:[NSArray class]]) return;
    if (classNames != nil && classNames.count > 0) {
        self.fChildControllers = [NSMutableArray arrayWithCapacity:classNames.count];
        [classNames enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Class class = NSClassFromString(obj);
            id vc;
            if (class) {
                vc = [[class alloc] init];
            } else {
                vc = [[UIViewController alloc] init];
            }
            [self.fChildControllers addObject:vc];
        }];
    } else {
        self.fChildControllers = nil;
        syLog(@"开车页面初始化失败 : 传入的基本数组出错");
    }
}


#pragma mark - getter
- (FFSelectHeaderView *)selectHeaderView {
    if (!_selectHeaderView) {
        _selectHeaderView = [[FFSelectHeaderView alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 50)];
        _selectHeaderView.delegate = self;
        _selectHeaderView.lineColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    return _selectHeaderView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIButton *)postStatusButton {
    if (!_postStatusButton) {
        
        _postStatusButton = [UIButton createButtonBounds:CGRectMake(0, 0, 80, 80) center:CGPointMake(kSCREEN_WIDTH - 50, self.view.bounds.size.height - 100) title:nil imageName:@"Community_Post_Status" action:^(UIButton *button) {
            [self respondsToPostStatusButton];
        }];

        [_postStatusButton layoutButtonWithImageStyle:(FFButtonImageOnTop) imageTitleSpace:0];
    }
    return _postStatusButton;
}

- (UIBarButtonItem *)throughtBarbutton {
    if (!_throughtBarbutton) {
        _throughtBarbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Community_Send"] style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToThroughtButton)];
    }
    return _throughtBarbutton;
}

- (FFDriveThroughInfoViewController *)throughtViewController {
    if (!_throughtViewController) {
        _throughtViewController = [[FFDriveThroughInfoViewController alloc] init];
    }
    return _throughtViewController;
}






@end
