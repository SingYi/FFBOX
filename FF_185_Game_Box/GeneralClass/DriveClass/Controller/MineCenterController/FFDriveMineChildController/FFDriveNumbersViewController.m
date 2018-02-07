//
//  FFDriveNumbersViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/29.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveNumbersViewController.h"
#import "FFDriveModel.h"
#import "FFDriveDetailInfoViewController.h"

@interface FFDriveNumbersViewController () <UITableViewDelegate>


@end


@implementation FFDriveNumbersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



#pragma mark - setter
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    [self canScroll:scrollView];
}

#pragma mark - getter
- (DynamicType)dynamicType {
    return CheckUserDynamic;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self pushDetailControllerWith:indexPath Comment:NO];
}

- (void)pushDetailControllerWith:(NSIndexPath *)indexPath Comment:(BOOL)isComment {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushDetailController" object:self.showArray[indexPath.row] userInfo:self.showArray[indexPath.row]];
}






@end










