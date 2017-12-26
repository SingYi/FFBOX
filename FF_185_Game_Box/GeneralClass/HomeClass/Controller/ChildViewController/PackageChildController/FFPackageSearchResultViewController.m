//
//  FFPackageSearchResultViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/15.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFPackageSearchResultViewController.h"
#import "FFpackageCell.h"
#import "FFPackageModel.h"

#define CELL_IDE @"FFpackageCell"

@interface FFPackageSearchResultViewController () <UITableViewDelegate, FFpackageCellDelegate>

@property (nonatomic, strong) FFPackageModel *model;

@end

@implementation FFPackageSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    CGFloat height = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    self.tableView.frame = CGRectMake(0, height, kSCREEN_WIDTH, kSCREEN_HEIGHT - height);
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initDataSource {
    [super initDataSource];
    BOX_REGISTER_CELL;
}


- (void)searchPackage:(NSString *)name {
    BOX_START_ANIMATION;
    [FFPackageModel searchPackageWith:name Completion:^(NSDictionary *content, BOOL success) {
        BOX_STOP_ANIMATION;
        syLog(@"searc result = %@",content);
        if (success) {
            self.showArray = [content[@"data"][@"list"] mutableCopy];
            if (self.showArray.count > 0) {
                [self.tableView reloadData];
            } else {
                BOX_MESSAGE(@"未查询到相关礼包");
            }
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFpackageCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.delegate = self;

    cell.currentIdx = indexPath.row;



    cell.dict = self.showArray[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - cell delegate
- (void)FFpackageCell:(FFpackageCell *)cell select:(NSInteger)idx {
    syLog(@"领取礼包");

    NSString *str = self.showArray[idx][@"card"];

    if ([str isKindOfClass:[NSNull class]]) {
        //领取礼包
        [self.model getPackageWithGiftID:self.showArray[idx][@"id"] Completion:^(NSDictionary *content, BOOL success) {
            if (success) {
                NSMutableDictionary *dict = [self.showArray[idx] mutableCopy];
                [dict setObject:content[@"data"] forKey:@"card"];
                [self.showArray replaceObjectAtIndex:idx withObject:dict];

                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
                BOX_MESSAGE(@"领取成功");
            } else {
                BOX_MESSAGE(@"领取失败");
                //                BOX_MESSAGE(content[@"msg"]);
            }
            syLog(@"%@",content);
        }];
    } else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str;
        BOX_MESSAGE(@"已复制礼包兑换码");
    }
}

#pragma mark - getter
- (FFPackageModel *)model {
    if (!_model) {
        _model = [[FFPackageModel alloc] init];
    }
    return _model;
}


@end



