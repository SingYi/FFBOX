//
//  FFGameServiceViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFGameServiceViewController.h"


@interface FFGameServiceViewController ()

@end

@implementation FFGameServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.mj_footer = nil;
}

- (void)initDataSource {

}

- (void)refreshNewData {
    [FFOpenServerModel gameServerOpenWithGameID:_gameID Completion:^(NSDictionary *content, BOOL success) {
        if (success) {
            self.showArray = content[@"data"];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        syLog(@"game open service == %@",content);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFOpenServerCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];

    NSMutableDictionary *dict = [self.showArray[indexPath.row] mutableCopy];

    cell.gameLogo.image = self.gameLogo;
    cell.dict = dict;
    if (self.gameName) {
        [dict setObject:self.gameName forKey:@"gamename"];
    }


    return cell;
}


- (void)setGameID:(NSString *)gameID {
    syLog(@"???????????????????");
    if ([_gameID isEqualToString:gameID]) {
        return;
    } else {
        _gameID = gameID;
        [self refreshNewData];
    }
}








@end
