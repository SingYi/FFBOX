//
//  FFGmaeRaidersViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFGameRaidersViewController.h"
#import "FFRaidersCell.h"
#import "FFGameModel.h"
#import "FFWebViewController.h"

#define CELL_IDE @"FFRaidersCell"

@interface FFGameRaidersViewController ()

//@property (nonatomic, strong)

@end

@implementation FFGameRaidersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.mj_footer = nil;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    BOX_REGISTER_CELL;
}

- (void)refreshNewData {
    [FFGameModel raidersWithGameID:self.gameID Comoletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            id data = content[@"data"][@"list"];
            if ([data isKindOfClass:[NSNull class]] || data == nil) {
                self.showArray = nil;
            } else {
                self.showArray = content[@"data"][@"list"];
            }
            [self.tableView reloadData];
        }



        [self.tableView.mj_header endRefreshing];
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFRaidersCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];

    cell.dict = self.showArray[indexPath.row];
    cell.gameLogo.image = self.gameLogo;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *url =  self.showArray[indexPath.row][@"info_url"];

    HIDE_TABBAR;
    HIDE_PARNENT_TABBAR;
    FFWebViewController *webView = [[FFWebViewController alloc] init];
    webView.webURL = url;
    [self.navigationController pushViewController:webView animated:YES];

}

- (void)setGameID:(NSString *)gameID {
    _gameID = gameID;
    [self refreshNewData];
}

- (void)setGameLogo:(UIImage *)gameLogo {
    _gameLogo = gameLogo;
}





@end
