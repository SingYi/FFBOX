//
//  FFDiscountViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/5/3.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDiscountViewController.h"
#import "FFDiscountModel.h"

@interface FFDiscountViewController ()

@property (nonatomic, assign) NSUInteger currentPage;


@end

@implementation FFDiscountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initDataSource {
    [super initDataSource];
    self.collectionArray = @[@"新游",@"热门",@"分类"];
    self.collectionImage = @[@"New_recomment_rebate",@"New_recomment_activity",@"New_recomment_package"];

    NSArray<NSString *> *controllerName = @[@"FFNewDiscountViewController",
                                            @"FFLowDiscountViewController",
                                            @"FFDiscountClassifyViewController"];

    self.childControllers = [NSMutableArray arrayWithCapacity:controllerName.count];
    for (NSString *vcName in controllerName) {
        Class ViewController = NSClassFromString(vcName);
        id vc = [[ViewController alloc] init];
        if (vc != nil) {
            [self.childControllers addObject:vc];
        } else {
            printf("%s error :  View Controller does not exist",__func__);
            [self.childControllers addObject:[UIViewController new]];
        }
    }
    //刷新视图
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - method
- (void)refreshNewData {
    _currentPage = 1;
    [FFDiscountModel discountGameWithPage:[NSString stringWithFormat:@"%lu",_currentPage] Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            self.carouselView.rollingArray = content[@"data"][@"banner"];
            self.showArray = [content[@"data"][@"gamelist"] mutableCopy];
            [self.tableView reloadData];
        } else {

        }

        if (self.showArray && self.showArray.count > 0) {
            self.tableView.backgroundView = nil;
        } else {
            self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }

        if (self.carouselView.rollingArray.count > 0) {
            self.tableView.tableHeaderView = self.carouselView;
        } else {
            self.tableView.tableHeaderView = nil;
        }

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    _currentPage++;
    [FFDiscountModel discountGameWithPage:[NSString stringWithFormat:@"%lu",_currentPage] Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            NSMutableArray *array = [content[@"data"][@"gamelist"] mutableCopy];
            if (array.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.showArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }
        } else {
            [self.tableView.mj_footer endRefreshing];
        }

        if (self.showArray && self.showArray.count > 0) {
            self.tableView.backgroundView = nil;
        } else {
            self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwangluo"]];
        }
    }];
}








@end
