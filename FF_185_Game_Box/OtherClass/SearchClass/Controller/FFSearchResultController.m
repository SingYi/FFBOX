//
//  FFSearchResultController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFSearchResultController.h"
#import "FFSearchModel.h"
#import "FFGameViewController.h"

@interface FFSearchResultController ()

@property (nonatomic, strong) NSString *keyWord;

@end

@implementation FFSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"搜索结果";
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
}

- (void)initDataSource {
    [super initDataSource];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
}

#pragma mark - method
+ (instancetype)resultControllerWithKeyWord:(NSString *)keyWord {
    FFSearchResultController *resultConroller = [[FFSearchResultController alloc] init];
    resultConroller.keyWord = keyWord;
    return resultConroller;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id cell = [tableView cellForRowAtIndexPath:indexPath];

    Class FFFpackageCell = NSClassFromString(@"FFpackageCell");
    if ([cell isKindOfClass:FFFpackageCell]) {
        return;
    }

    UIImageView *imageView = [cell valueForKey:@"gameLogo"];
    NSDictionary *dict = self.showArray[indexPath.row];

    Class FFGameViewController = NSClassFromString(@"FFGameViewController");

    id vc = [FFGameViewController performSelector:@selector(sharedController)];
    if (dict[@"gamename"]) {
        [vc setValue:dict[@"gamename"] forKey:@"gameName"];
    }

    if (dict[@"gameName"]) {
        [vc setValue:dict[@"gameName"] forKey:@"gameName"];
    }

    if (dict[@"id"]) {
        [vc setValue:dict[@"id"] forKey:@"gameID"];
    } else {
        return;
    }

    if (imageView) {
        [vc setValue:imageView.image forKey:@"gameLogo"];
    }


    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    [self.navigationController pushViewController:vc animated:YES];

    syLog(@"???????????????????????");
}

#pragma mark - setter
- (void)setKeyWord:(NSString *)keyWord {
    if (keyWord && ![keyWord isEqualToString:_keyWord]) {
        self.showArray = nil;
        _keyWord = keyWord;

        BOX_START_ANIMATION;
        [FFSearchModel searchGameWithKeyword:keyWord Completion:^(NSDictionary *content, BOOL success) {
            BOX_STOP_ANIMATION;
            if (success) {
                self.showArray = content[@"data"];
                [self.tableView reloadData];
                if (self.showArray.count > 0) {

                } else {
                    BOX_MESSAGE(@"未找到相关游戏");
                }
            } else {
                BOX_MESSAGE(content[@"msg"]);
            }
        }];
    }
}







@end
