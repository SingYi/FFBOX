//
//  FFPackageDetailViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/30.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFPackageDetailViewController.h"
#import "FFPackageModel.h"
#import "MBProgressHUD.h"

@interface FFPackageDetailViewController ()

@end

@implementation FFPackageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"礼包详情";
}

- (void)setPid:(NSString *)pid {
    _pid = pid;
    syLog(@"礼包详情 === pid -> %@",_pid);
    [self getPackageInfo];
}

- (void)getPackageInfo {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FFPackageModel getPackageDetailInfoWithID:self.pid Completion:^(NSDictionary *content, BOOL success) {
        [hud hideAnimated:YES];
        syLog(@"礼包详情 === %@",content);
    }];
}








@end
