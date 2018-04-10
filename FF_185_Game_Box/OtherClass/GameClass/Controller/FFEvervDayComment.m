//
//  FFEvervDayComment.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/28.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFEvervDayComment.h"
#import "FFRankListModel.h"
#import "FFViewFactory.h"
#import "SDWebImageDownloader.h"

#import "UINavigationController+Cloudox.h"
#import "UIViewController+Cloudox.h"

@interface FFEvervDayComment ()

@end

@implementation FFEvervDayComment

- (instancetype)init {
    self = [super init];
    if (self) {
        [self getCommentGame];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBgAlpha = @"1.0";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)getCommentGame {
    FFRankListModel *model = [[FFRankListModel alloc] init];
    model.gameType = @"2";
    BOX_START_ANIMATION;
    WeakSelf;
    [model loadNewRankListWithCompletion:^(NSDictionary *content, BOOL success) {
        BOX_STOP_ANIMATION;
        if (success) {
            syLog(@"content == %@",content);
            NSArray *array = content[@"data"];
            [weakSelf setGameDict:array.firstObject];
        } else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
    
}

- (void)setGameDict:(NSDictionary *)dict {
    self.gameID = dict[@"id"];
    self.gameName = dict[@"gamename"];
    NSString *url = [NSString stringWithFormat:IMAGEURL,dict[@"logo"]];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:(SDWebImageDownloaderLowPriority) progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (finished) {
            self.gameLogo = image;
        }
    }];
}










@end
