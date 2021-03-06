//
//  FFBasicPackageViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/17.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicPackageViewController.h"
#import "FFpackageCell.h"

#define CELL_IDE @"FFpackageCell"

@interface FFBasicPackageViewController () <FFpackageCellDelegate>

@end

@implementation FFBasicPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    [super initUserInterface];
}

- (void)initDataSource {
    BOX_REGISTER_CELL;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFpackageCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.currentIdx = indexPath.row;
    cell.dict = self.showArray[indexPath.row];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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
            }
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
