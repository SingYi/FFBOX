//
//  FFPackageDetailViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/30.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFPackageDetailViewController.h"
#import "FFDetailPackHeaderView.h"
#import "UIAlertController+FFAlertController.h"

#import "FFPackageModel.h"
#import "MBProgressHUD.h"
#import "FFDetailPackageModel.h"
#import "UIImageView+WebCache.h"

#import "FFGameModel.h"

@interface FFPackageDetailViewController ()

@property (nonatomic, strong) FFDetailPackHeaderView *headerView;
@property (nonatomic, strong) FFPackageModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *logImageView;
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameSubTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadGameBtn;

@property (weak, nonatomic) IBOutlet UILabel *packDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *progress;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *getPackBtn;

@property (weak, nonatomic) IBOutlet UILabel *libaoneirongLabel;
@property (weak, nonatomic) IBOutlet UILabel *libaoneirong;

@property (weak, nonatomic) IBOutlet UILabel *duihuanfangshiLabel;
@property (weak, nonatomic) IBOutlet UILabel *duihuanfangshi;

@property (weak, nonatomic) IBOutlet UILabel *shijianLabel;
@property (weak, nonatomic) IBOutlet UILabel *start_time;
@property (weak, nonatomic) IBOutlet UILabel *end_time;

@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UILabel *attention;



@end

@implementation FFPackageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUserInterface];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.headerView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 80);
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"礼包详情";

//    [self.view addSubview:self.headerView];
    self.tableView.tableFooterView = [UIView new];
    self.libaoneirongLabel.textColor = NAVGATION_BAR_COLOR;
    self.duihuanfangshiLabel.textColor = NAVGATION_BAR_COLOR;
    self.shijianLabel.textColor = NAVGATION_BAR_COLOR;
    self.attentionLabel.textColor = NAVGATION_BAR_COLOR;

    [self.downloadGameBtn setBackgroundColor:NAVGATION_BAR_COLOR];
    [self.downloadGameBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.downloadGameBtn.layer.cornerRadius = 4;
    self.downloadGameBtn.layer.masksToBounds = YES;

    [self.getPackBtn setBackgroundColor:NAVGATION_BAR_COLOR];
    [self.getPackBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.getPackBtn.layer.cornerRadius = 4;
    self.getPackBtn.layer.masksToBounds = YES;

    self.progress.layer.cornerRadius = 2.5;
    self.progress.layer.masksToBounds = YES;

    self.downloadGameBtn.hidden = YES;
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

        if (success) {
            NSDictionary *data = content[@"data"];
            [[FFDetailPackageModel sharedModel] setInfoWithDictionary:data];

            [self refresView];
//            [self.headerView refreshView];
            syLog(@"package id === %@",[FFDetailPackageModel sharedModel].package_id);
        } else {

        }

    }];
}

#pragma mark - setter
- (void)refresView {
    FFDetailPackageModel *model = [FFDetailPackageModel sharedModel];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",model.logo]];
    [self.logImageView sd_setImageWithURL:url];

    self.gameNameLabel.text = [NSString stringWithFormat:@"%@",model.game_name];
    self.gameSizeLabel.text = [NSString stringWithFormat:@"%@M",model.game_size];
//    self.gameSubTitleLabel.text = [NSString stringWithFormat:@"%@",model.]

    self.packDetailLabel.text = [NSString stringWithFormat:@"%@",model.pack_name];

    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:model.start_time.integerValue];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:model.end_time.integerValue];
    self.start_time.text = [NSString stringWithFormat:@"开始时间 : %@",[formatter stringFromDate:startDate]];
    self.end_time.text = [NSString stringWithFormat:@"结束时间 : %@",[formatter stringFromDate:endDate]];

    self.libaoneirong.text = [NSString stringWithFormat:@"%@",model.pack_abstract];
    self.duihuanfangshi.text = [NSString stringWithFormat:@"%@",model.pack_method];
    self.attention.text = [NSString stringWithFormat:@"%@",model.pack_notice];

    CGFloat total = model.pack_counts.floatValue + model.pack_used_counts.floatValue;
    CGFloat current = (model.pack_counts.floatValue / total * 100);
    self.progressLabel.text = [NSString stringWithFormat:@" %.2lf%% ",current];
    UIView *progress1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.progress.bounds.size.width * current / 100, self.progress.bounds.size.height)];
    progress1.layer.cornerRadius = 2.5;
    progress1.layer.masksToBounds = YES;
    progress1.backgroundColor = NAVGATION_BAR_COLOR;
    [self.progress addSubview:progress1];


    if (model.card && model.card.length > 1) {
        [self.getPackBtn setTitle:@"复制" forState:(UIControlStateNormal)];
        [self.getPackBtn setBackgroundColor:[UIColor darkGrayColor]];
    } else {
        [self.getPackBtn setTitle:@"领取" forState:(UIControlStateNormal)];
        [self.getPackBtn setBackgroundColor:NAVGATION_BAR_COLOR];
    }

    self.downloadGameBtn.hidden = !([FFDetailPackageModel sharedModel].download_url && [FFDetailPackageModel sharedModel].download_url.length > 5);
}

#pragma mark - method
- (IBAction)downloadGame:(id)sender {
    syLog(@"下载游戏");
    if ([FFDetailPackageModel sharedModel].download_url && [FFDetailPackageModel sharedModel].download_url.length > 5) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[FFDetailPackageModel sharedModel].download_url]];
    }
}

- (IBAction)getPackage:(id)sender {
    syLog(@"获取礼包");
    NSString *str = [FFDetailPackageModel sharedModel].card;
    if ([str isKindOfClass:[NSNull class]] || str == nil || str.length < 1) {
        //领取礼包
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.model getPackageWithGiftID:[FFDetailPackageModel sharedModel].package_id Completion:^(NSDictionary *content, BOOL success) {
            [hud hideAnimated:YES];
            if (success) {
                [self getPackageInfo];
                [UIAlertController showAlertMessage:@"领取成功" dismissTime:0.7 dismissBlock:nil];
            } else {
                [UIAlertController showAlertMessage:@"领取失败" dismissTime:0.7 dismissBlock:nil];
            }
        }];
    } else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str;
        [UIAlertController showAlertMessage:@"已复制礼包兑换码" dismissTime:0.7 dismissBlock:nil];
    }
}




#pragma mark - getter
- (FFDetailPackHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFDetailPackHeaderView alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 80)];
    }
    return _headerView;
}

- (FFPackageModel *)model {
    if (!_model) {
        _model = [[FFPackageModel alloc] init];
    }
    return _model;
}






@end
